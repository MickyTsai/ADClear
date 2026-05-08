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
    case checkContentBlockerEnable
    case isContentBlockerEnable(Bool)

    @CasePathable
    enum Alert {
      case cancel
      case alreadyEnableContentBlocker
    }
  }

  var body: some ReducerOf<Self> {
    @Dependency(\.contentBlockerService) var contentBlockerService

    Reduce { state, action in
      switch action {

      case .alert:
        return .none

      case .scenceDidActive:
        return .send(.checkContentBlockerEnable)

      case .checkContentBlockerEnable:
        return .run { send in
          let contentBlockerID = "com.mickytsai.ADClear.ContentBlocker"
          let isEnable = await contentBlockerService.getStateOfContentBlocker(contentBlockerID)
          await send(.isContentBlockerEnable(isEnable))
        }

      case .isContentBlockerEnable(let isEnable):
        state.isEnableContentBlocker = isEnable
        if !isEnable {
          state.alert = .disableContentBlockerAlert
        }
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

extension AlertState<HomeFeature.Action.Alert> {
  static var disableContentBlockerAlert: Self {
    AlertState {
      TextState("disableContentBlockerAlert")
    } actions: {
      ButtonState(role: .cancel,
                  label: {TextState("cancel")} )
      ButtonState(action: .alreadyEnableContentBlocker,
                  label: {TextState("Enabled")})
      
    } message: {
      TextState("""
「前往啟用 Safari 延伸功能」
設定 > App > Safari > 延伸功能
""")
    }
  }
}
