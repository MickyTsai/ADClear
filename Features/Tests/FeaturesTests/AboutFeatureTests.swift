//
//  AboutFeatureTests.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/28.
//

import ComposableArchitecture
import XCTest

@testable import Features

@MainActor
final class AboutFeatureTests: XCTestCase {
  
  func testTapReportCell() async throws {
    let testStore = TestStore(
      initialState: AboutFeature.State(),
      reducer: { AboutFeature() }
    )
  }
}

