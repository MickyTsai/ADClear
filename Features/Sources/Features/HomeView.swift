//
//  HomeView.swift
//  Features
//
//  Created by Micky on 2026/5/8.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
  @Environment(\.scenePhase) private var scenePhase
  
  let store: StoreOf<HomeFeature>

  var body: some View {
    Text("User ContentBlocker is \(store.isEnableContentBlocker ? "Enabled" : "Disabled")")
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
