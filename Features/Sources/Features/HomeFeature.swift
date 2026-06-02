//
//  HomeFeature.swift
//  Features
//
//  Created by Micky on 2026/5/8.
//

import ComposableArchitecture
import Foundation
import Services

@Reducer
struct HomeFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var alert: AlertState<Action.Alert>?
    var path = StackState<Path.State>()
    var isEnableContentBlocker = false
    var isRefreshingContentBlocker = false
  }

  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case path(StackActionOf<Path>)
    case scenceDidActive
    case isContentBlockerEnable(Bool)
    case tapRefreshBtn
    case fetchRulesCount(Int)
    case reloadContentBlocker
    case refreshOver
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
      .forEach(\.path, action: \.path)
  }

  func core(into state: inout State, action: Action) -> Effect<Action> {

    enum CancelID {
      case getStateOfContentBlocker
      case tapRefreshBtn
    }

    /// 取得 ContentBlocker 狀態
    func getStateOfContentBlocker() -> Effect<Action> {
      .run { send in
        @Dependency(\.contentBlockerService) var contentBlockerService
        let contentBlockerID = "com.mickytsai.ADClear.ContentBlocker"
        let isEnable = await contentBlockerService.getStateOfContentBlocker(contentBlockerID)
        await send(.isContentBlockerEnable(isEnable))
      }
      .cancellable(id: CancelID.getStateOfContentBlocker, cancelInFlight: true)
    }

    /// 刷新 ContentBlocker
    func refreshingContentBlocker() -> Effect<Action> {
      .run { send in
        // 檢查 ContentBlocker 狀態
        @Dependency(\.contentBlockerService) var contentBlockerService
        let contentBlockerID = "com.mickytsai.ADClear.ContentBlocker"
        let isEnable = await contentBlockerService.getStateOfContentBlocker(contentBlockerID)
        await send(.isContentBlockerEnable(isEnable))

        // 從 easylist 抓取新規則
        guard isEnable else { return }
        @Dependency(\.safariConverterLibService) var safariConverterLibService
        let rulesCount = try await safariConverterLibService.fetchRules(URL.easylist)
        await send(.fetchRulesCount(rulesCount))
      }
      catch: { error, send in
        //TODO: Log error
      }
      .cancellable(id: CancelID.tapRefreshBtn, cancelInFlight: true)
    }

    switch action {

    case .alert(.presented(.alreadyEnableContentBlocker)):
      return getStateOfContentBlocker()

    case .alert(.presented(.openURL)):
      return .run { send in
        @Dependency(\.openURL) var openURL
        await openURL(.tcaWebsite)
      }

    case .alert:
      return .none

    case .path(.element(id: _, action: .about(.tapBlockerListcell))):
      state.path.append(.blockerList(.init()))
      return .none

    case .path:
      return .none

    // APP畫面進入前景
    case .scenceDidActive:
      return getStateOfContentBlocker()

    // ContentBlocker 狀態
    case .isContentBlockerEnable(let isEnable):
      state.isEnableContentBlocker = isEnable
      if !isEnable {
        state.alert = .disableContentBlockerAlert
        state.isRefreshingContentBlocker = false
      }
      return .none

    // 點擊左上的刷新按鈕
    case .tapRefreshBtn:
      state.isRefreshingContentBlocker = true
      return refreshingContentBlocker()

    // 更新規則數量
    case .fetchRulesCount(let count):
//      state.alert = AlertState.fetchRulesCountAlert(count: count)
      return .send(.reloadContentBlocker)
    
    // 重載 ContentBlocker
    case .reloadContentBlocker:
      return .run { send in
        @Dependency(\.contentBlockerService) var contentBlockerService
        let contentBlockerID = "com.mickytsai.ADClear.ContentBlocker"
        try await contentBlockerService.reloadContentBlocker(contentBlockerID)
        await send(.refreshOver)
      }
      catch: { error, send in
        // TODO: log error
        
      }
    
    // 更新結束
    case .refreshOver:
      state.isRefreshingContentBlocker = false
      return .none
      
    // 點擊右上的關於我按鈕
    case .tapAboutBtn:
      state.path.append(.about(.init()))
      return .none

    // 點擊下方的按鈕
    case .tapBottomView:
      state.alert = .tapBottomViewAlert
      return .none
    }
  }
}
