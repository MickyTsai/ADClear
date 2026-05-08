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
    var isEnableContentBlocker = false
  }
  
  enum Action: Equatable {
    case scenceDidActive
    case checkContentBlockerEnable
    case isContentBlockerEnable(Bool)
  }
  
  var body: some ReducerOf<Self> {
    @Dependency(\.contentBlockerService) var contentBlockerService

    Reduce {state, action in
      switch action {
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
        return .none
      }
    }
  }
}

