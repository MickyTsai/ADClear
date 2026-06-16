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
  
  func test_tapReportCell_openURL() async throws {
    let expectation = XCTestExpectation(description: "openURL")

    let testStore = TestStore(
      initialState: AboutFeature.State(),
      reducer: { AboutFeature() }
    ) {
      $0.openURL = .init(handler: { url in
        XCTAssertEqual(url, URL(string: "mailto:micky.adclear@gmail.com")!)
        expectation.fulfill()
        return true
      })
    }
    
    await testStore.send(.tapReportCell)
    await fulfillment(of: [expectation], timeout: 1)
  }
  
  func test_tapAboutCell_openURL() async throws {
    let expectation = XCTestExpectation(description: "openURL")

    let testStore = TestStore(
      initialState: AboutFeature.State(),
      reducer: { AboutFeature() }
    ) {
      $0.openURL = .init(handler: { url in
        XCTAssertEqual(url, URL(string: "https://github.com/MickyTsai/ADClear")!)
        expectation.fulfill()
        return true
      })
    }

    await testStore.send(.tapAboutCell)
    await fulfillment(of: [expectation], timeout: 1)
  }
}
