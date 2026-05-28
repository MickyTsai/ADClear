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
  
  func testTapReportCell_canSendMailDisable() async throws {
    let testStore = TestStore(
      initialState: AboutFeature.State(),
      reducer: { AboutFeature() }
    ) {
      $0.mailComposeService.canSendMail = { false }
    }
    
    await testStore.send(.tapReportCell)
    await testStore.receive(.isIosMailEnable(false)) {
      $0.alert = .pleaseEnableMail
    }
  }
}

