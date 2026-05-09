//
//  HomeFeature.swift
//  Features
//
//  Created by Micky on 2026/5/8.
//

import ComposableArchitecture

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

    @CasePathable
    enum Alert {
      case cancel
      case alreadyEnableContentBlocker
    }
  }

  var body: some ReducerOf<Self> {
    Reduce(core)
      .ifLet(\.$alert, action: \.alert)
  }
  
  func core(into state: inout State, action: Action) -> Effect<Action> {
    @Dependency(\.contentBlockerService) var contentBlockerService
    
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
    }
  }
}
