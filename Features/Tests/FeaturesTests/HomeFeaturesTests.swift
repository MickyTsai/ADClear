import ComposableArchitecture
import XCTest

@testable import Features

@MainActor
final class HomeFeaturesTests: XCTestCase {

  // 進入畫面_contentBlocker權限未開啟
  func test_scenceDidActive_contentBlockerDisable() async throws {
    let testStore = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in false }
    }

    await testStore.send(.scenceDidActive)
    await testStore.receive(.isContentBlockerEnable(false)) {
      $0.alert = .disableContentBlockerAlert
    }
  }

  // 進入畫面_contentBlocker權限未開啟_後續使用者開啟
  func test_scenceDidActive_contentBlockerDisable_userEnabled() async throws {
    let testStore = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in false }
    }

    await testStore.send(.scenceDidActive)
    await testStore.receive(.isContentBlockerEnable(false)) {
      $0.alert = .disableContentBlockerAlert
    }

    // 模擬使用者後續已開啟
    testStore.dependencies.contentBlockerService.getStateOfContentBlocker = { _ in true }
    await testStore.send(.scenceDidActive)
    await testStore.receive(.isContentBlockerEnable(true)) {
      $0.isEnableContentBlocker = true
    }
  }

  // 進入畫面_contentBlocker權限已開啟
  func test_scenceDidActive_contentBlockerEnabled() async throws {
    let testStore = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in true }
    }

    await testStore.send(.scenceDidActive)
    await testStore.receive(.isContentBlockerEnable(true)) {
      $0.isEnableContentBlocker = true
    }
  }

  func testAlert_bottomViewAlert_openURL() async throws {
    let openURLExp = XCTestExpectation(description: "openURL")

    let testStore = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.openURL = .init(handler: { url in
        XCTAssertEqual(url, URL(string: "https://github.com/pointfreeco/swift-composable-architecture/tree/7517cc32aa083773f096dc4724a0b83215bf3c55")!)
        openURLExp.fulfill()
        return true
      })
    }

    await testStore.send(.tapBottomView) {
      $0.alert = .tapBottomViewAlert
    }
    await testStore.send(.alert(.presented(.openURL))) {
      $0.alert = nil
    }
    await fulfillment(of: [openURLExp])
  }
}
