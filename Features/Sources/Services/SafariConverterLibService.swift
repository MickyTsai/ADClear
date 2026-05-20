//
//  SafariConverterLibService.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/11.
//

import ContentBlockerConverter
import Dependencies
import Foundation

public struct SafariConverterLibService: Sendable {
  /// 抓取新規則，回傳規則數量來確認是否抓取成功
  public var fetchRules: @Sendable (_ from: URL) async throws -> Int // 回傳規則數量
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
      let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!
      let fileURL = containerURL.appendingPathComponent("blockerList.json")
      try result.safariRulesJSON.write(to: fileURL, atomically: true, encoding: .utf8)
      
      return result.safariRulesCount
    }
  )
}

extension SafariConverterLibService: TestDependencyKey {
  public static let testValue = Self(
    fetchRules: unimplemented("updateRules", placeholder: 0)
  )
}

extension DependencyValues {
  public var safariConverterLibService: SafariConverterLibService {
    get { self[SafariConverterLibService.self] }
    set { self[SafariConverterLibService.self] = newValue }
  }
}
