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
  struct State: Equatable {}

  enum Action: Equatable {
    case tapBlockerListcell
    case tapReportCell
    case tapRateCell
    case tapAboutCell
  }

  var body: some ReducerOf<Self> {
    @Dependency(\.openURL) var openURL

    Reduce { state, action in
      switch action {

      case .tapBlockerListcell:
        return .none
      case .tapReportCell:
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
  }
}
