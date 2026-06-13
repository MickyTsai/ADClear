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
    case tapReportCell
    case tapAboutCell
  }

  var body: some ReducerOf<Self> {
    @Dependency(\.openURL) var openURL

    Reduce { state, action in
      switch action {
        
      case .tapReportCell:
        return .run { send in
          await openURL(.reportByEmail)
        }
        
      case .tapAboutCell:
        return .run { send in
          await openURL(.github)
        }
      }
    }
  }
}
