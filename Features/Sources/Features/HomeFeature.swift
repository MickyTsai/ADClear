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
  }
  
  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case scenceDidActive
    case isContentBlockerEnable(Bool)
    
    case tapRefreshBtn
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
      
    case .isContentBlockerEnable(let isEnable):
      state.isEnableContentBlocker = isEnable
      if !isEnable {
        state.alert = .disableContentBlockerAlert
      }
      return .none
      
    case .tapRefreshBtn:
      return .run { _ in
        let url = URL(string: "https://easylist-downloads.adblockplus.org/easylist.txt")!
        try await safariConverterLibService.fetchRules(url)
      }
      
    case .tapAboutBtn:
      return .none
      
    case .tapBottomView:
      state.alert = .tapBottomViewAlert
      return .none
    }
  }
}
