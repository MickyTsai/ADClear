//
//  BlockerListView.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//

import ComposableArchitecture
import Models
import SwiftUI

struct BlockerListView: View {
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize

  var store: StoreOf<BlockerListFeature>

  var body: some View {
    ScrollView {
      GlassEffectContainer(spacing: 22) {
        contentView
      }
    }
    .scrollIndicators(.hidden)
    .navigationTitle("已封鎖的蓋版廣告網站")
    .navigationBarTitleDisplayMode(.inline)
    .tint(.primary)
    .task {
      await store.send(.loadRules).finish()
    }
  }

  @MainActor
  @ViewBuilder
  private var contentView: some View {
    VStack(alignment: .leading, spacing: 22) {
      rulesCountView
      rulesListView
      Spacer(minLength: 16)
    }
    .padding(.horizontal, 20)
    .padding(.top, 18)
    .padding(.bottom, 28)
  }

  @MainActor
  @ViewBuilder
  private var rulesCountView: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .top, spacing: 12) {
        Image(systemName: "list.bullet.rectangle.portrait.fill")
          .font(.system(size: 30, weight: .semibold))
          .foregroundStyle(.green)
          .frame(width: 56, height: 56)
          .glassEffect(.regular.tint(.green.opacity(0.18)), in: .rect(cornerRadius: 20))

        VStack(alignment: .leading, spacing: 4) {
          Text("封鎖清單")
            .font(.title2.bold())
          Text("目前 Content Blocker 已套用的蓋版廣告網域與選擇器。")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
        }
        .layoutPriority(1)

        Spacer(minLength: 0)
      }

      if dynamicTypeSize.isAccessibilitySize {
        VStack(spacing: 12) {
          domainCountView
          selectorCountView
        }
      } else {
        HStack(spacing: 12) {
          domainCountView
          selectorCountView
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
  private var rulesListView: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("規則")
        .font(.headline)
        .foregroundStyle(.secondary)

      if store.ruleItems.isEmpty {
        EmptyRuleListView()
      } else {
        LazyVStack(spacing: 14) {
          ForEach(store.ruleItems) { ruleItem in
            RuleItemView(ruleItem: ruleItem)
          }
        }
      }
    }
  }

  @MainActor
  @ViewBuilder
  private var domainCountView: some View {
    countStyleView(
      title: "網域",
      value: "\(store.ruleItems.count)",
      systemImage: "network"
    )
  }

  @MainActor
  @ViewBuilder
  private var selectorCountView: some View {
    countStyleView(
      title: "選擇器",
      value: "\(selectorCount)",
      systemImage: "scope"
    )
  }

  private var selectorCount: Int {
    store.ruleItems.reduce(0) { total, item in
      total + item.selectors.count
    }
  }
}

private struct countStyleView: View {
  let title: String
  let value: String
  let systemImage: String

  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: systemImage)
        .font(.caption.weight(.semibold))
        .foregroundStyle(.green)
        .frame(width: 28, height: 28)
        .glassEffect(.regular.tint(.green.opacity(0.14)), in: .rect(cornerRadius: 10))

      VStack(alignment: .leading, spacing: 1) {
        Text(value)
          .font(.headline.weight(.bold))
          .contentTransition(.numericText())
          .fixedSize(horizontal: false, vertical: true)
        Text(title)
          .font(.caption2)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
      .layoutPriority(1)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .frame(maxWidth: .infinity, alignment: .leading)
    .glassEffect(
      .regular.tint(.primary.opacity(0.05)),
      in: .rect(cornerRadius: 18))
  }
}

private struct RuleItemView: View {
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize

  let ruleItem: RuleItem

  var body: some View {
    Group {
      if dynamicTypeSize.isAccessibilitySize {
        ruleItemViewAccessibilityLayout
      } else {
        ruleItemViewStandardLayout
      }
    }
    .padding(14)
    .frame(maxWidth: .infinity, alignment: .leading)
    .glassEffect(
      .regular.tint(.primary.opacity(0.05)),
      in: .rect(cornerRadius: 20)
    )
    .accessibilityElement(children: .combine)
  }

  // 一般字型排版
  @MainActor
  @ViewBuilder
  private var ruleItemViewStandardLayout: some View {
    HStack(alignment: .top, spacing: 12) {
      ruleIconImage
      ruleContentView
      Spacer(minLength: 0)
    }
  }

  // 無障礙字型排版
  @MainActor
  @ViewBuilder
  private var ruleItemViewAccessibilityLayout: some View {
    VStack(alignment: .leading, spacing: 12) {
      ruleIconImage
      ruleContentView
    }
  }

  @MainActor
  @ViewBuilder
  private var ruleIconImage: some View {
    Image(systemName: "shield.checkered")
      .font(.body.weight(.semibold))
      .foregroundStyle(.green)
      .frame(width: 40, height: 40)
      .glassEffect(.regular.tint(.green.opacity(0.18)), in: .rect(cornerRadius: 14))
  }

  @MainActor
  @ViewBuilder
  private var ruleContentView: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text(ruleItem.domain)
        .font(.subheadline.weight(.semibold))
        .fixedSize(horizontal: false, vertical: true)
        .textSelection(.enabled)

      Text(ruleItem.selectors.joined(separator: ", "))
        .font(.caption)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
        .textSelection(.enabled)
    }
    .layoutPriority(1)
  }
}

private struct EmptyRuleListView: View {

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Image(systemName: "tray")
        .font(.title3.weight(.semibold))
        .foregroundStyle(.secondary)
        .frame(width: 42, height: 42)
        .glassEffect(.regular.tint(.white.opacity(0.08)), in: .rect(cornerRadius: 15))

      VStack(alignment: .leading, spacing: 4) {
        Text("尚未載入規則")
          .font(.subheadline.weight(.semibold))
        Text("返回首頁更新規則後，這裡會顯示已套用的網域與選擇器。")
          .font(.caption)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .glassEffect(
      .regular.tint(.primary.opacity(0.05)),
      in: .rect(cornerRadius: 20))
  }
}

#Preview {
  NavigationStack {
    BlockerListView(
      store: .init(
        initialState: BlockerListFeature.State(
          ruleItems: [
            .init(domain: "example.com", selectors: [".ad-container", "#overlay", ".modal-ad"]),
            .init(domain: "news.example.tw", selectors: [".sponsor-cover", ".popup-banner"]),
          ]
        ),
        reducer: { BlockerListFeature() }))
  }
}
