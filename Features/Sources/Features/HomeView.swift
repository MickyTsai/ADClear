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
    NavigationStack(
      path: $store.scope(state:\.path, action: \.path)
    ) {
      VStack {
        statusView
        Spacer()
        bottomView
      }
      .navigationTitle("AD Blocker")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar(content: {
        ToolbarItem(placement: .topBarLeading) {
          refreshButton
        }
        ToolbarItem(placement: .topBarTrailing) {
          aboutButton
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
    } destination: { store in
      switch store.case {
      case .about(let store):
        AboutView(store: store)
      case .blockerList(let store):
        BlockerListView(store: store)
      }
    }
    .alert($store.scope(state: \.alert, action: \.alert))
    .tint(.white)
  }

  @MainActor
  @ViewBuilder
  private var statusView: some View {
    if store.isRefreshingContentBlocker != .none {
      ProgressView()
      Text("\(store.isRefreshingContentBlocker.rawValue)")
    } else {
      Text("User ContentBlocker is \(store.isEnableContentBlocker ? "Enabled" : "Disabled")")
    }
  }

  @MainActor
  @ViewBuilder
  private var refreshButton: some View {
    Button {
      store.send(.tapRefreshBtn)
    } label: {
        Image(systemName: "arrow.clockwise.circle")
    }
    .disabled(store.isRefreshingContentBlocker != .none)
  }
  
  @MainActor
  @ViewBuilder
  private var aboutButton: some View {
    Button {
      store.send(.tapAboutBtn)
    } label: {
      Image(systemName: "gearshape.fill")
    }
  }
  
  @MainActor
  @ViewBuilder
  private var bottomView: some View {
    Button {
      store.send(.tapBottomView)
    } label: {
      Text("bottomView")
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
