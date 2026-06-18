//
//  BlockerListFeatureTests.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/30.
//

import ComposableArchitecture
import XCTest
import Models

@testable import Features

@MainActor
final class BlockerListFeatureTests: XCTestCase {

  func test_LoadRules() async throws {
    let ruleItem = RuleItem(domain: "example.com", selectors: [".ad-container"])
    
    let testStore = TestStore(
      initialState: BlockerListFeature.State(),
      reducer: { BlockerListFeature() }
    ) {
      $0.safariConverterLibService.getRules = {
        [ruleItem]
      }
    }
    
    await testStore.send(.loadRules)
    await testStore.receive(.binding(.set(\.ruleItems, [ruleItem]))) {
      $0.ruleItems = [ruleItem]
    }
  }
}
