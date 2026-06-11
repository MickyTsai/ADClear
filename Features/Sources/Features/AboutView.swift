//
//  AboutView.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture
import SwiftUI

struct AboutView: View {
  @Bindable var store: StoreOf<AboutFeature>

  var body: some View {
    List {
      Section {
        reportCell
        rateCell
        shareCell
        aboutCell
      }
    }
    .navigationTitle("關於")
    .navigationBarTitleDisplayMode(.inline)
  }

  @MainActor
  @ViewBuilder
  private var reportCell: some View {
    Button {
      store.send(.tapReportCell)
    } label: {
      VStack(alignment: .leading) {
        Text("回報")
        Text("附上截圖以利判斷")
          .font(.caption)
      }
    }
  }

  @MainActor
  @ViewBuilder
  private var rateCell: some View {
    Button {
      store.send(.tapRateCell)
    } label: {
      Text("評分")
    }
  }

  @MainActor
  @ViewBuilder
  private var shareCell: some View {
    ShareLink(item: .appStore) {
      Text("推薦給朋友")
    }
  }

  @MainActor
  @ViewBuilder
  private var aboutCell: some View {
    Button {
      store.send(.tapAboutCell)
    } label: {
      VStack(alignment: .leading) {
        Text("關於")
        Text("V1.10(17)")
          .font(.caption2)
      }
    }
  }
}

#Preview {
  NavigationStack {
    AboutView(
      store: .init(
        initialState: AboutFeature.State(),
        reducer: { AboutFeature() }))
  }
}
