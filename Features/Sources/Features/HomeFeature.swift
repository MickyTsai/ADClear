//
//  HomeFeature.swift
//  Features
//
//  Created by Micky on 2026/5/8.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var alert: AlertState<Action.Alert>?
    var isEnableContentBlocker = false
    var rulesCount = 0
  }
  
  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case scenceDidActive
    case isContentBlockerEnable(Bool)
    case tapRefreshBtn
    case fetchRulesCount(Int)
    case tapAboutBtn
    case tapBottomView

    @CasePathable
    enum Alert {
      case cancel
      case alreadyEnableContentBlocker
      case openURL
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce(core)
      .ifLet(\.$alert, action: \.alert)
  }
  
  func core(into state: inout State, action: Action) -> Effect<Action> {
    @Dependency(\.contentBlockerService) var contentBlockerService
    @Dependency(\.safariConverterLibService) var safariConverterLibService
    @Dependency(\.openURL) var openURL
    
    // 取得 ContentBlocker 狀態
    func getStateOfContentBlocker() -> Effect<Action> {
      return .run { send in
        let contentBlockerID = "com.mickytsai.ADClear.ContentBlocker"
        let isEnable = await contentBlockerService.getStateOfContentBlocker(contentBlockerID)
        await send(.isContentBlockerEnable(isEnable))
      }
    }
    
    switch action {
      
    case .alert(.presented(.alreadyEnableContentBlocker)):
      return getStateOfContentBlocker()
      
    case .alert(.presented(.openURL)):
      return .run { send in
        await openURL(URL(string: "https://github.com/pointfreeco/swift-composable-architecture/tree/7517cc32aa083773f096dc4724a0b83215bf3c55")!)
      }
      
    case .alert:
      return .none
      
    case .scenceDidActive:
      return getStateOfContentBlocker()
      
    // ContentBlocker 狀態
    case .isContentBlockerEnable(let isEnable):
      state.isEnableContentBlocker = isEnable
      if !isEnable {
        state.alert = .disableContentBlockerAlert
      }
      return .none
      
    // 點擊左上的刷新按鈕
    case .tapRefreshBtn:
      return .run { send in
        // 檢查 ContentBlocker 狀態
        let contentBlockerID = "com.mickytsai.ADClear.ContentBlocker"
        let isEnable = await contentBlockerService.getStateOfContentBlocker(contentBlockerID)
        await send(.isContentBlockerEnable(isEnable))
        guard isEnable else { return }
        
        // 從 easylist 抓取新規則
        let url = URL(string: "https://easylist-downloads.adblockplus.org/easylist.txt")!
        let rulesCount = try await safariConverterLibService.fetchRules(url)
        await send (.fetchRulesCount(rulesCount))
      }
     
    // 更新規則數量
    case .fetchRulesCount(let count):
      state.rulesCount = count
      state.alert = AlertState.fetchRulesCountAlert(count: count)
      return .none
     
    // 點擊右上的關於我按鈕
    case .tapAboutBtn:
      return .none
      
    // 點擊下方的按鈕
    case .tapBottomView:
      state.alert = .tapBottomViewAlert
      return .none
    }
  }
}
