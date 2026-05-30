//
//  BlockerListFeature.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture
import Models

@Reducer
struct BlockerListFeature {
  @ObservableState
  struct State: Equatable {
    var ruleItems: [RuleItem] = []
  }

  enum Action: Equatable {
    case loadRules
    case reciveRules([Rule])
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loadRules:
        return .run { send in
          //TODO: 從本地取得規則清單
          let rules = [Rule]()
          await send(.reciveRules(rules))
        }
      case .reciveRules(let rules):
        //TODO: 將檔案轉檔成要顯示的格式（RuleItem）
        return .none
      }
    }
  }
}
