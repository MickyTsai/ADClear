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
          Text("\(ruleItem.title)")
            .font(.headline)
          Text("\(ruleItem.discription)")
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
            .init(title: "測試 title", discription: "測試 discription"),
            .init(title: "測試 title2", discription: "測試 discription2")]
        ),
        reducer: { BlockerListFeature() }))
  }
  .preferredColorScheme(.dark)
}
