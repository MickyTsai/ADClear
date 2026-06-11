//
//  HomeFeature.swift
//  Features
//
//  Created by Micky on 2026/5/8.
//

import ComposableArchitecture
import Foundation
import OSLog
import Services

@Reducer
struct HomeFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var alert: AlertState<Action.Alert>?
    var path = StackState<Path.State>()
    var isEnableContentBlocker = false
    var isRefreshingContentBlocker: RefrashState = .none
    var completedRefreshSteps: Set<RefrashState> = []
    var failedRefreshStep: RefrashState?
  }

  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case path(StackActionOf<Path>)
    case scenceDidActive
    case isContentBlockerEnable(Bool)
    case tapRefreshBtn
    case tapBlockerListBtn
    case refreshFail(RefrashState)
    case startFetchRules
    case endFetchRules
    case reloadContentBlocker
    case tapAboutBtn

    @CasePathable
    enum Alert {
      case cancel
      case alreadyEnableContentBlocker
    }
  }

  enum RefrashState: String, Equatable, Hashable {
    case check = "檢查延伸功能狀態"
    case download = "下載中"
    case rules = "取得規則"
    case reload = "載入新規則"
    case none = ""
  }

  private let logger = Logger(subsystem: "Featuers", category: "HomeFeature")

  var body: some ReducerOf<Self> {
    Reduce(core)
      .ifLet(\.$alert, action: \.alert)
      .forEach(\.path, action: \.path)
  }

  func core(into state: inout State, action: Action) -> Effect<Action> {

    enum CancelID {
      case getStateOfContentBlocker
      case fetchRules
      case reloadContentBlocker
    }

    /// 取得 ContentBlocker 狀態
    func getStateOfContentBlocker(manually: Bool = false) -> Effect<Action> {
      .run { send in
        @Dependency(\.contentBlockerService) var contentBlockerService
        let contentBlockerID = "com.mickytsai.ADClear.ContentBlocker"
        let isEnable = await contentBlockerService.getStateOfContentBlocker(contentBlockerID)
        await send(.isContentBlockerEnable(isEnable))
        if isEnable, manually {
          await send(.startFetchRules)
        }
      }
      .cancellable(id: CancelID.getStateOfContentBlocker, cancelInFlight: true)
    }

    /// 抓取新規則
    func fetchRules() -> Effect<Action> {
      .run { send in
        // 從 easylist 抓取新規則
        @Dependency(\.safariConverterLibService) var safariConverterLibService
        let _ = try await safariConverterLibService.fetchRules(URL.easylist)
        await send(.endFetchRules)
      }
      catch: { error, send in
        await send(.refreshFail(.download))
        logger.log("從 easylist 抓取新規則 失敗")
      }
      .cancellable(id: CancelID.fetchRules, cancelInFlight: true)
    }

    /// 重載 ContentBlocker
    func reloadContentBlocker() -> Effect<Action> {
      .run { send in
        @Dependency(\.contentBlockerService) var contentBlockerService
        let contentBlockerID = "com.mickytsai.ADClear.ContentBlocker"
        try await contentBlockerService.reloadContentBlocker(contentBlockerID)
        await send(.reloadContentBlocker)
      }
      catch: { error, send in
        await send(.refreshFail(.reload))
        logger.log("重載 ContentBlocker 失敗")
      }
      .cancellable(id: CancelID.reloadContentBlocker, cancelInFlight: true)
    }

    switch action {

    case .alert(.presented(.alreadyEnableContentBlocker)):
      return getStateOfContentBlocker()

    case .alert:
      return .none

    case .path(.element(id: _, action: .about(.tapBlockerListcell))):
      state.path.append(.blockerList(.init()))
      return .none

    case .path:
      return .none

    // APP畫面進入前景
    case .scenceDidActive:
      return getStateOfContentBlocker()

    // ContentBlocker 狀態
    case .isContentBlockerEnable(let isEnable):
      state.isEnableContentBlocker = isEnable
      if !isEnable {
        state.alert = .disableContentBlockerAlert
        state.isRefreshingContentBlocker = .none
        state.completedRefreshSteps = []
        state.failedRefreshStep = nil
      }
      return .none

    // 點擊左上的刷新按鈕
    case .tapRefreshBtn:
      state.isRefreshingContentBlocker = .check
      state.completedRefreshSteps = []
      state.failedRefreshStep = nil
      return getStateOfContentBlocker(manually: true)

    case .tapBlockerListBtn:
      state.path.append(.blockerList(.init()))
      return .none

    case .refreshFail(let step):
      state.isRefreshingContentBlocker = .none
      state.failedRefreshStep = step
      return .none

    case .startFetchRules:
      state.completedRefreshSteps = state.completedRefreshSteps.union([.check])
      state.isRefreshingContentBlocker = .download
      return fetchRules()

    case .endFetchRules:
      state.completedRefreshSteps = state.completedRefreshSteps.union([.download])
      state.isRefreshingContentBlocker = .reload
      return reloadContentBlocker()

    case .reloadContentBlocker:
      state.isRefreshingContentBlocker = .none
      state.completedRefreshSteps = state.completedRefreshSteps.union([.reload])
      return .none

    // 點擊右上的關於我按鈕
    case .tapAboutBtn:
      state.path.append(.about(.init()))
      return .none
    }
  }
}
