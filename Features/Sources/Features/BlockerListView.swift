//
//  BlockerListView.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture
import SwiftUI
import Models

struct BlockerListView: View {
  var store: StoreOf<BlockerListFeature>

  var body: some View {
    List {
      ForEach(store.ruleItems) { ruleItem in
        VStack(alignment: .leading) {
          Text("\(ruleItem.domain)")
            .font(.headline)
          Text("\(ruleItem.selectors.joined(separator: ", "))")
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
    }
    .navigationTitle("已封鎖的蓋版廣告網站")
    .navigationBarTitleDisplayMode(.inline)
    .task {
      await store.send(.loadRules).finish()
    }
  }
}

#Preview {
  NavigationStack {
    BlockerListView(
      store: .init(
        initialState: BlockerListFeature.State(
          ruleItems: [
            .init(domain: "測試 domain", selectors: ["測試 selectors"]),
            .init(domain: "測試 domain2", selectors: ["測試 selectors2"])]
        ),
        reducer: { BlockerListFeature() }))
  }
}
