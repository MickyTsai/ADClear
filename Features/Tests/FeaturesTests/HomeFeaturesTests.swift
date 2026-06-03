import ComposableArchitecture
import XCTest

@testable import Features

@MainActor
final class HomeFeaturesTests: XCTestCase {

  // 進入畫面_contentBlocker權限尚未開啟
  func testScenceDidActive_contentBlockerDisable() async throws {
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
    
    // 點擊 alert 的確定但實際還是沒開
    await testStore.send(\.alert.presented.alreadyEnableContentBlocker) {
      $0.alert = nil
    }
    await testStore.receive(.isContentBlockerEnable(false)) {
      $0.alert = .disableContentBlockerAlert
    }
  }

  // 進入畫面_contentBlocker權限尚未開啟_後續使用者開啟
  func testScenceDidActive_contentBlockerDisable_userEnabled() async throws {
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
  func testScenceDidActive_contentBlockerEnabled() async throws {
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
  
  // 點擊刷新按鈕_contentBlocker權限尚未開啟
  func testTapRefreshBtn_contentBlockerDisable() async throws {
    let testStore = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in false }
    }
    
    await testStore.send(.tapRefreshBtn) {
      $0.isRefreshingContentBlocker = .check
    }
    await testStore.receive(.isContentBlockerEnable(false)) {
      $0.alert = .disableContentBlockerAlert
      $0.isRefreshingContentBlocker = .none
    }
  }
  
  // 點擊刷新按鈕_contentBlocker權限已開啟_刷新規則成功
  func testTapRefreshBtn_contentBlockerEnabled_fetchRulesSusscess() async throws {
    let testStore = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in true }
      $0.contentBlockerService.reloadContentBlocker = { _ in }
      $0.safariConverterLibService.fetchRules = { _ in 10 } // 模擬取得10個規則
    }
    
    await testStore.send(.tapRefreshBtn) {
      $0.isRefreshingContentBlocker = .check
    }
    await testStore.receive(.isContentBlockerEnable(true)) {
      $0.isEnableContentBlocker = true
    }
    await testStore.receive(.startFetchRules) {
      $0.isRefreshingContentBlocker = .download
    }
    await testStore.receive(.endFetchRules) {
      $0.isRefreshingContentBlocker = .reload
    }
    await testStore.receive(.reloadContentBlocker) {
      $0.isRefreshingContentBlocker = .none
    }
  }
  
  // 點擊刷新按鈕_contentBlocker權限已開啟_刷新規則失敗
  func testTapRefreshBtn_contentBlockerEnabled_fetchRulesFaild() async throws {
    let testStore = TestStore(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ) {
      $0.contentBlockerService.getStateOfContentBlocker = { _ in true }
      $0.contentBlockerService.reloadContentBlocker = { _ in }
      $0.safariConverterLibService.fetchRules = { _ in throw URLError(.unknown) }
    }
    
    await testStore.send(.tapRefreshBtn) {
      $0.isRefreshingContentBlocker = .check
    }
    await testStore.receive(.isContentBlockerEnable(true)) {
      $0.isEnableContentBlocker = true
    }
    await testStore.receive(.startFetchRules) {
      $0.isRefreshingContentBlocker = .download
    }
    await testStore.receive(.refreshFail) {
      $0.isRefreshingContentBlocker = .none
    }
  }

  // 點擊bottomView_點擊開啟網址
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
