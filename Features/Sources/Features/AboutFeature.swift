//
//  AboutFeature.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture

@Reducer
struct AboutFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var alert: AlertState<Action.Alert>?
  }

  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case tapBlockerListcell
    case tapReportCell
    case isIosMailEnable(Bool)
    case tapRateCell
    case tapAboutCell

    @CasePathable
    enum Alert {
      case cancel
    }
  }

  var body: some ReducerOf<Self> {
    @Dependency(\.openURL) var openURL
    @Dependency(\.mailComposeService) var mailComposeService

    Reduce { state, action in
      switch action {

      case .alert(.presented(.cancel)):
        return .none
        
      case .alert:
        return .none
        
      case .tapBlockerListcell:
        return .none
        
      case .tapReportCell:
        return .run { send in
          let enableMail = await mailComposeService.canSendMail()
          await send(.isIosMailEnable(enableMail))
        }
        
      case .isIosMailEnable(let isEnable):
        if isEnable {
          //TODO: 寄送郵件
        } else {
          state.alert = .pleaseEnableMail
        }
        return .none
        
      case .tapRateCell:
        return .run { send in
          await openURL(.appStore)
        }
        
      case .tapAboutCell:
        return .run { send in
          await openURL(.github)
        }
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}
