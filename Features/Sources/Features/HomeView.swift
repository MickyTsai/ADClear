//
//  HomeView.swift
//  Features
//
//  Created by Micky on 2026/5/8.
//

import ComposableArchitecture
import SwiftUI

// 更新流程進度條狀態
private enum PipelineRowStatus {
  case idle
  case active
  case completed
  case failed
}

struct HomeView: View {
  @Environment(\.scenePhase) private var scenePhase

  @Bindable var store: StoreOf<HomeFeature>

  var body: some View {
    NavigationStack(
      path: $store.scope(\.path, action: \.path)
    ) {
      ScrollView {
        dashboardContent
      }
      .scrollIndicators(.hidden)
      .navigationTitle("ADClear")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar(content: {
        ToolbarItem(placement: .topBarTrailing) {
          aboutButton
        }
      })
      .onChange(of: scenePhase) { _, newPhase in
        switch newPhase {

        case .background, .inactive:
          break
        case .active:
          store.send(.scenceDidActive)
        @unknown default:
          break
        }
      }
    } destination: { store in
      switch store.case {
      case .about(let store):
        AboutView(store: store)
      case .blockerList(let store):
        BlockerListView(store: store)
      }
    }
    .alert($store.scope(\.alert, action: \.alert))
    .tint(.primary)
  }

  @MainActor
  @ViewBuilder
  private var dashboardContent: some View {
    GlassEffectContainer(spacing: 22) {
      VStack(alignment: .leading, spacing: 22) {
        homeDescriptionView
        statusView
        quickActionsView
        updatePipelineView
        Spacer(minLength: 16)
      }
      .padding(.horizontal, 20)
      .padding(.top, 18)
      .padding(.bottom, 28)
    }
  }

  @MainActor
  @ViewBuilder
  private var homeDescriptionView: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(spacing: 12) {
        Image(systemName: "shield.lefthalf.filled")
          .font(.system(size: 30, weight: .semibold))
          .foregroundStyle(.green)
          .frame(width: 56, height: 56)
          .glassEffect(.regular.tint(.green.opacity(0.18)), in: .rect(cornerRadius: 20))

        VStack(alignment: .leading, spacing: 4) {
          Text("防護中樞")
            .font(.title2.bold())
          Text("集中管理延伸功能狀態、規則更新與封鎖清單。")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .glassEffect(.regular.tint(.white.opacity(0.08)), in: .rect(cornerRadius: 28))
  }

  @MainActor
  @ViewBuilder
  private var statusView: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 8) {
          Text("目前狀態")
            .font(.headline)
            .foregroundStyle(.secondary)
          Text(store.isEnableContentBlocker ? "已啟用" : "尚未啟用")
            .font(.system(size: 40, weight: .bold, design: .rounded))
            .contentTransition(.numericText())

        }

        Spacer()

        Image(
          systemName: store.isEnableContentBlocker
            ? "checkmark.shield.fill" : "exclamationmark.shield.fill"
        )
        .font(.system(size: 34, weight: .semibold))
        .foregroundStyle(store.isEnableContentBlocker ? .green : .orange)
        .frame(width: 64, height: 64)
        .glassEffect(
          .regular.tint(store.isEnableContentBlocker ? .green.opacity(0.2) : .orange.opacity(0.2)),
          in: .rect(cornerRadius: 22)
        )

      }
      Text(statusMessage)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(20)
    .frame(maxWidth: .infinity, alignment: .leading)
    .glassEffect(.regular.tint(.white.opacity(0.1)), in: .rect(cornerRadius: 30))
  }

  @MainActor
  @ViewBuilder
  private var aboutButton: some View {
    Button {
      store.send(.tapAboutBtn)
    } label: {
      Image(systemName: "gearshape.fill")
    }
    .buttonStyle(.glass)
  }

  @MainActor
  @ViewBuilder
  private var quickActionsView: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("快速操作")
        .font(.headline)
        .foregroundStyle(.secondary)

      LazyVGrid(columns: [.init(.flexible(), spacing: 20), .init(.flexible())], spacing: 20) {
        DashboardActionButton(
          title: "更新規則",
          subtitle: "下載並重新載入",
          systemImage: "arrow.triangle.2.circlepath"
        ) {
          store.send(.tapRefreshBtn)
        }
        .disabled(store.isRefreshingContentBlocker != .none)

        DashboardActionButton(
          title: "封鎖清單",
          subtitle: "查看已套用項目",
          systemImage: "list.bullet.rectangle.portrait"
        ) {
          store.send(.tapBlockerListBtn)
        }
      }
    }
  }

  @MainActor
  @ViewBuilder
  private var updatePipelineView: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text("更新流程")
        .font(.headline)
        .foregroundStyle(.secondary)

      VStack(spacing: 16) {
        PipelineRow(
          title: "檢查延伸功能",
          detail: "確認 Safari Content Blocker 是否啟用",
          systemImage: "magnifyingglass",
          status: pipelineStatus(for: .check)
        )
        PipelineRow(
          title: "下載 EasyList",
          detail: "取得最新規則來源",
          systemImage: "square.and.arrow.down",
          status: pipelineStatus(for: .download)
        )
        PipelineRow(
          title: "重新載入規則",
          detail: "讓 Content Blocker 套用更新",
          systemImage: "bolt.shield",
          status: pipelineStatus(for: .reload)
        )
      }
    }
  }

  // 更新流程進度條狀態
  private func pipelineStatus(for step: HomeFeature.RefrashState) -> PipelineRowStatus {
    if store.failedRefreshStep == step {
      return .failed
    }

    if store.completedRefreshSteps.contains(step) {
      return .completed
    }

    if step == store.isRefreshingContentBlocker {
      return .active
    }

    return .idle
  }

  private var statusMessage: String {
    if store.isRefreshingContentBlocker != .none {
      return "正在更新防護規則，完成後會自動套用。"
    }
    return store.isEnableContentBlocker
      ? "Content Blocker 已可為 Safari 套用攔截規則。"
      : "請先在 Safari 延伸功能設定中啟用 ADClear。"
  }
}

private struct DashboardActionButton: View {
  let title: String
  let subtitle: String
  let systemImage: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 12) {
        Image(systemName: systemImage)
          .font(.title3.weight(.semibold))
          .frame(width: 36, height: 36)
          .glassEffect(.regular.tint(.white.opacity(0.12)), in: .rect(cornerRadius: 14))

        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.headline)
          Text(subtitle)
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
      .padding(16)
      .frame(maxWidth: .infinity, minHeight: 146, alignment: .leading)
      .contentShape(.rect(cornerRadius: 22))
      .glassEffect(.regular.tint(.white.opacity(0.08)).interactive(), in: .rect(cornerRadius: 22))
    }
    .buttonStyle(.plain)
  }
}

private struct PipelineRow: View {
  let title: String
  let detail: String
  let systemImage: String
  let status: PipelineRowStatus

  private var isActive: Bool {
    status == .active
  }

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: systemImage)
        .font(.body.weight(.semibold))
        .foregroundStyle(isActive ? .cyan : .secondary)
        .frame(width: 36, height: 36)
        .glassEffect(
          .regular.tint(isActive ? .cyan.opacity(0.18) : .white.opacity(0.08)),
          in: .rect(cornerRadius: 14)
        )

      VStack(alignment: .leading, spacing: 3) {
        Text(title)
          .font(.subheadline.weight(.semibold))
        Text(detail)
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Spacer()

      statusView
    }
    .padding(14)
    .frame(maxWidth: .infinity, alignment: .leading)
    .glassEffect(
      .regular.tint(isActive ? .cyan.opacity(0.12) : .white.opacity(0.06)),
      in: .rect(cornerRadius: 20)
    )
  }

  @MainActor
  @ViewBuilder
  private var statusView: some View {
    ZStack {
      switch status {
      case .idle:
        Color.clear
      case .active:
        ProgressView()
          .controlSize(.small)
      case .completed:
        Image(systemName: "checkmark")
          .font(.caption.weight(.bold))
          .foregroundStyle(.green)
          .frame(width: 26, height: 26)
          .glassEffect(.regular.tint(.green.opacity(0.18)), in: .rect(cornerRadius: 10))
      case .failed:
        Image(systemName: "xmark")
          .font(.caption.weight(.bold))
          .foregroundStyle(.red)
          .frame(width: 26, height: 26)
          .glassEffect(.regular.tint(.red.opacity(0.18)), in: .rect(cornerRadius: 10))
      }
    }
    .frame(width: 28, height: 28)
  }
}

#Preview {
  HomeView(
    store: .init(
      initialState: HomeFeature.State(),
      reducer: { HomeFeature() }
    ))
}
