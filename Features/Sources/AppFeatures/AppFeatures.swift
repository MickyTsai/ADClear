// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import ComposableArchitecture

@main
struct ADClearApp: App {
  var body: some Scene {
    WindowGroup {
      Text("ADClearApp")
    }
  }
}

@Reducer
struct AppFeature {
  @ObservableState
  struct State: Equatable {}
  
  enum Action: Equatable {
    case scenceDidActive
    case checkContentBlockerEnable
    case isContentBlockerEnable(Bool)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .scenceDidActive:
        return .send(.checkContentBlockerEnable)
      case .checkContentBlockerEnable:
        return .send(.isContentBlockerEnable(false))
      case .isContentBlockerEnable(let isEnable):
        return .none
      }
      
    }
  }
}

