//
//  BlockerListFeature.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture

@Reducer
struct BlockerListFeature {
  @ObservableState
  struct State: Equatable {
    var ruleItems: [RuleItem] = []
  }
  
  enum Action: Equatable {}
  
  var body: some ReducerOf<Self> {}
}

