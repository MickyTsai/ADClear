//
//  BlockerListFeature.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture
import Services
import Models
import Foundation
import OSLog

@Reducer
struct BlockerListFeature {
  private let logger = Logger(subsystem: "Featuers", category: "BlockerListFeature")
  
  @ObservableState
  struct State: Equatable {
    var ruleItems: [RuleItem] = []
  }

  enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
    case loadRules
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .binding:
        return .none
        
      case .loadRules:
        return .run { send in
          @Dependency(\.safariConverterLibService) var safariConverterLibService
          let rules = try await safariConverterLibService.getRules()
          await send(.binding(.set(\.ruleItems, rules)))
        }
        catch: { error, _ in
          logger.log("取得已下載好的規則 失敗")
        }
      }
    }
  }
}
