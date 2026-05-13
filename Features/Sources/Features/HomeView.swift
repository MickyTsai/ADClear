//
//  HomeView.swift
//  Features
//
//  Created by Micky on 2026/5/8.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
  @Environment(\.scenePhase) private var scenePhase

  @Bindable var store: StoreOf<HomeFeature>

  var body: some View {
    NavigationStack {
      VStack {
        descriptionView
      }
      .navigationTitle("AD Blocker")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar(content: {
        ToolbarItem(placement: .topBarLeading) {
          refreshButton
        }
      })
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
    .alert($store.scope(state: \.alert, action: \.alert))
  }

  @MainActor
  @ViewBuilder
  private var descriptionView: some View {
    Text("User ContentBlocker is \(store.isEnableContentBlocker ? "Enabled" : "Disabled")")
  }

  @MainActor
  @ViewBuilder
  private var refreshButton: some View {
    Button {
      store.send(.tapRefreshBtn)
    } label: {
      Image(systemName: "arrow.clockwise.circle")
    }
  }
}

#Preview {
  HomeView(
    store: .init(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ))
}
