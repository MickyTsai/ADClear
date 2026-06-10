//
//  SafariConverterLibService.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/11.
//

import ContentBlockerConverter
import Dependencies
import Foundation
import Models

private enum SafariConverterLibServiceError: Error {
  case missingAppGroupContainer(String)
}

public struct SafariConverterLibService: Sendable {
  /// 抓取新規則，回傳規則數量來確認是否抓取成功
  /// 若結果為空，Library 會回傳一個只有一條 dummy rule 的 JSON，因為 Safari 要求至少要有一條規則。
  /// https://github.com/AdguardTeam/SafariConverterLib/blob/master/Sources/ContentBlockerConverter/ConversionResult.swift
  public var fetchRules: @Sendable (_ url: URL) async throws -> Int

  /// 取得已下載好的規則
  public var getRules: @Sendable () async throws -> [RuleItem]
}

extension SafariConverterLibService: DependencyKey {
  public static let liveValue = Self(
    fetchRules: { url in
      // 1. download
      let (data, response) = try await URLSession.shared.data(from: url)
      guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
        throw URLError(.badServerResponse)
      }

      // 2. convert
      guard let rawText = String(data: data, encoding: .utf8) else {
        throw URLError(.cannotDecodeContentData)
      }
      var contiguousUTF8Text = rawText
      contiguousUTF8Text.makeContiguousUTF8()
      let splitText = contiguousUTF8Text.split(separator: "\n").map(String.init)
      let result = ContentBlockerConverter().convertArray(
        rules: splitText,
        safariVersion: SafariVersion.autodetect(),
        advancedBlocking: false
      )

      // 3. save to app group
      let appGroupID = "group.com.mickytsai.ADBlocker"
      let fileName = "blockerList.json"
      guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
        throw SafariConverterLibServiceError.missingAppGroupContainer(appGroupID)
      }
      let fileURL = containerURL.appendingPathComponent(fileName)
      try result.safariRulesJSON.write(to: fileURL, atomically: true, encoding: .utf8)

      return result.safariRulesCount
    },
    getRules: {
      let appGroupID = "group.com.mickytsai.ADBlocker"
      let fileName = "blockerList.json"
      guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
        return []
      }
      let fileURL = containerURL.appendingPathComponent(fileName)
      let data = try Data(contentsOf: fileURL)
      let rules = try JSONDecoder().decode([BlockerListRule].self, from: data)
      
      var rulesDict = [String: [String]]()

      for rule in rules {
        if let domains = rule.trigger.ifDomain,
          let selector = rule.action.selector
        {
          for domain in domains {
            var selectors = rulesDict[domain] ?? []
            selectors.append(selector)
            rulesDict[domain] = selectors
          }
        } else if let selector = rule.action.selector {
          var selectors = rulesDict["Any"] ?? []
          selectors.append(selector)
          rulesDict["Any"] = selectors
        }
      }

      var ruleItems = [RuleItem]()
      for (domain, selectors) in rulesDict {
        let ruleItem = RuleItem(domain: domain, selectors: selectors)
        ruleItems.append(ruleItem)
      }
      
      return ruleItems
        .sorted(using: [KeyPathComparator(\.domain)])
    }
  )
}

extension SafariConverterLibService: TestDependencyKey {
  public static let testValue = Self(
    fetchRules: unimplemented("updateRules", placeholder: 0),
    getRules: unimplemented("getRules", placeholder: [])
  )
}

extension DependencyValues {
  public var safariConverterLibService: SafariConverterLibService {
    get { self[SafariConverterLibService.self] }
    set { self[SafariConverterLibService.self] = newValue }
  }
}
