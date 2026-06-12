//
//  AboutView.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture
import SwiftUI

struct AboutView: View {
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize

  @Bindable var store: StoreOf<AboutFeature>

  var body: some View {
    ScrollView {
      GlassEffectContainer(spacing: 22) {
        contentStack
      }
    }
    .scrollIndicators(.hidden)
    .navigationTitle("關於")
    .navigationBarTitleDisplayMode(.inline)
    .tint(.primary)
  }

  @MainActor
  @ViewBuilder
  private var contentStack: some View {
    VStack(alignment: .leading, spacing: 22) {
      aboutDescriptionView
      actionSection
      Spacer(minLength: 16)
    }
    .padding(.horizontal, 20)
    .padding(.top, 18)
    .padding(.bottom, 28)
  }

  @MainActor
  @ViewBuilder
  private var aboutDescriptionView: some View {
    Group {
      if dynamicTypeSize.isAccessibilitySize {
        VStack(alignment: .leading, spacing: 14) {
          aboutIconView
          aboutTextView
        }
      } else {
        HStack(spacing: 12) {
          aboutIconView
          aboutTextView
        }
      }
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .glassEffect(
      .regular.tint(.primary.opacity(0.05)),
      in: .rect(cornerRadius: 28))
  }

  @MainActor
  @ViewBuilder
  private var aboutIconView: some View {
    Image(systemName: "gearshape.2.fill")
      .font(.system(size: 30, weight: .semibold))
      .foregroundStyle(.cyan)
      .frame(width: 56, height: 56)
      .glassEffect(.regular.tint(.cyan.opacity(0.18)), in: .rect(cornerRadius: 20))
  }

  @MainActor
  @ViewBuilder
  private var aboutTextView: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("偏好與支援")
        .font(.title2.bold())
      Text("回報問題並查看 ADClear 專案資訊。")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .layoutPriority(1)
  }

  @MainActor
  @ViewBuilder
  private var actionSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("支援")
        .font(.headline)
        .foregroundStyle(.secondary)

      VStack(spacing: 14) {
        SettingsActionRow(
          title: "回報問題",
          subtitle: "附上截圖以利判斷",
          systemImage: "envelope.badge.shield.half.filled",
          tint: .orange
        ) {
          store.send(.tapReportCell)
        }

        SettingsActionRow(
          title: "關於",
          subtitle: "前往 GitHub 查看原始碼與版本紀錄",
          systemImage: "curlybraces.square",
          tint: .cyan
        ) {
          store.send(.tapAboutCell)
        }
      }
    }
  }
}

private struct SettingsActionRow: View {
  let title: String
  let subtitle: String
  let systemImage: String
  let tint: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      SettingsRowContent(
        title: title,
        subtitle: subtitle,
        systemImage: systemImage,
        tint: tint
      )
    }
    .buttonStyle(.plain)
  }
}

private struct SettingsRowContent: View {
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize

  let title: String
  let subtitle: String
  let systemImage: String
  let tint: Color

  var body: some View {
    Group {
      if dynamicTypeSize.isAccessibilitySize {
        settingsRowAccessibilityLayout
      } else {
        settingsRowStandardLayout
      }
    }
    .padding(14)
    .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
    .contentShape(.rect(cornerRadius: 20))
    .glassEffect(
      .regular.tint(.primary.opacity(0.05)).interactive(),
      in: .rect(cornerRadius: 20)
    )
    .accessibilityElement(children: .combine)
  }

  // 一般字型排版
  @MainActor
  @ViewBuilder
  private var settingsRowStandardLayout: some View {
    HStack(alignment: .center, spacing: 12) {
      Image(systemName: systemImage)
        .settingsIconStyle(tint: tint)

      textStack
      Spacer(minLength: 12)
      chevronImage
    }
  }

  // 無障礙字型排版
  @MainActor
  @ViewBuilder
  private var settingsRowAccessibilityLayout: some View {
    VStack(alignment: .leading, spacing: 12) {
      Image(systemName: systemImage)
        .settingsIconStyle(tint: tint)

      HStack(alignment: .top, spacing: 12) {
        textStack
        Spacer(minLength: 8)
        chevronImage
      }
    }
  }

  @MainActor
  @ViewBuilder
  private var textStack: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title)
        .font(.subheadline.weight(.semibold))
      Text(subtitle)
        .font(.caption)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .layoutPriority(1)
  }

  @MainActor
  @ViewBuilder
  private var chevronImage: some View {
    Image(systemName: "chevron.right")
      .font(.caption.weight(.bold))
      .foregroundStyle(.secondary)
      .accessibilityHidden(true)
  }
}

extension Image {
  fileprivate func settingsIconStyle(tint: Color) -> some View {
    self
      .font(.body.weight(.semibold))
      .foregroundStyle(tint)
      .frame(width: 40, height: 40)
      .glassEffect(.regular.tint(tint.opacity(0.18)), in: .rect(cornerRadius: 14))
  }
}

#Preview {
  NavigationStack {
    AboutView(
      store: .init(
        initialState: AboutFeature.State(),
        reducer: { AboutFeature() }))
  }
}
