//
//  BlockerListView.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture
import SwiftUI

struct BlockerListView: View {
  var store: StoreOf<BlockerListFeature>

  var body: some View {
    Text("BlockerListView")
  }
}

#Preview {
  BlockerListView(
    store: .init(
      initialState: BlockerListFeature.State(),
      reducer: { BlockerListFeature() }))
}
