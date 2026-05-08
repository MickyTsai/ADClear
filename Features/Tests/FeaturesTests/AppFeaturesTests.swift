import ComposableArchitecture
import XCTest

@testable import Features

@MainActor
final class AppFeaturesTests: XCTestCase {
  
  // 進入畫面_contentBlocker權限未開啟
  func test_scenceDidActive_contentBlockerDisable() async throws {
    let testStore = TestStore(initialState: HomeFeature.State(),
                              reducer: { HomeFeature() }) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in false}
    }
    
    await testStore.send(.scenceDidActive)
    await testStore.receive(.checkContentBlockerEnable)
    await testStore.receive(.isContentBlockerEnable(false))
  }
  
  // 進入畫面_contentBlocker權限未開啟_後續使用者開啟
  func test_scenceDidActive_contentBlockerDisable_userEnabled() async throws {
    let testStore = TestStore(initialState: HomeFeature.State(),
                              reducer: { HomeFeature() }) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in false}
    }
    
    await testStore.send(.scenceDidActive)
    await testStore.receive(.checkContentBlockerEnable)
    await testStore.receive(.isContentBlockerEnable(false))
    
    // 模擬使用者後續已開啟
    testStore.dependencies.contentBlockerService.getStateOfContentBlocker = { _ in true }
    await testStore.send(.scenceDidActive)
    await testStore.receive(.checkContentBlockerEnable)
    await testStore.receive(.isContentBlockerEnable(true)) {
      $0.isEnableContentBlocker = true
    }
  }
  
  // 進入畫面_contentBlocker權限已開啟
  func test_scenceDidActive_contentBlockerEnabled() async throws {
    let testStore = TestStore(initialState: HomeFeature.State(),
                              reducer: { HomeFeature() }) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in true}
    }
    
    await testStore.send(.scenceDidActive)
    await testStore.receive(.checkContentBlockerEnable)
    await testStore.receive(.isContentBlockerEnable(true)) {
      $0.isEnableContentBlocker = true
    }
  }
}
