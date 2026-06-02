//
//  BlockerListFeatureTests.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/30.
//

import ComposableArchitecture
import XCTest

@testable import Features

@MainActor
final class BlockerListFeatureTests: XCTestCase {
  func testLoadRules() async throws {
    let testStore = TestStore(
      initialState: BlockerListFeature.State(),
      reducer: { BlockerListFeature() }
    )
    
    await testStore.send(.loadRules)
    await testStore.receive(.reciveRuleItems([]))
  }
  
  func testReciveRules() async throws {
    
  }
}
