import ComposableArchitecture
import XCTest

@testable import Features

@MainActor
final class AppFeaturesTests: XCTestCase {
  
  func test_appLunch() async throws {
    let testStore = TestStore(initialState: AppFeature.State(), reducer: { AppFeature() })
    
    await testStore.send(.scenceDidActive)
    await testStore.receive(.checkContentBlockerEnable)
    await testStore.receive(.isContentBlockerEnable(false))
  }
}
