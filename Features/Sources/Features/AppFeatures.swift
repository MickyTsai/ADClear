// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import ComposableArchitecture
import Services

@main
struct ADClearApp: App {
  var body: some Scene {
    WindowGroup {
      HomeView(store: Store(initialState: AppFeature.State(),
                            reducer: { AppFeature() }))
    }
  }
}

struct HomeView: View {
  @Environment(\.scenePhase) private var scenePhase
  
  let store: StoreOf<AppFeature>

  var body: some View {
    Text("ADClearApp")
      .onChange(of: scenePhase) { _, newPhase in
        switch newPhase {
          
        case .background, .inactive:
          break
        case .active:
          store.send(.scenceDidActive)
        @unknown default:
          fatalError()
        }
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
    @Dependency(\.contentBlockerService) var contentBlockerService

    Reduce { state, action in
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
        return .none
      }
    }
  }
}

