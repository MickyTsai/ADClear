// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import ComposableArchitecture
import Services

@main
struct ADClearApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: Store(initialState: AppFeature.State(),
                            reducer: { AppFeature() }))
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    HomeView(store: store.scope(state: \.home, action: \.home))
  }
}

@Reducer
struct AppFeature {
  @ObservableState
  struct State: Equatable {
    var home = HomeFeature.State()
  }
  
  enum Action: Equatable {
    case home(HomeFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.home, action: \.home) {
      HomeFeature()
    }
  }
}

