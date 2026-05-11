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
  public var updateRules: @Sendable (_ from: URL) async throws -> Void
}

extension SafariConverterLibService: DependencyKey {
  public static let liveValue = Self(
    updateRules: { url in
      let (data, _) = try await URLSession.shared.data(from: url)
      guard let rawText = String(data: data, encoding: .utf8) else {
        throw URLError(.cannotDecodeContentData)
      }

      var contiguousUTF8Text = rawText
      contiguousUTF8Text.makeContiguousUTF8()
      let splitText = contiguousUTF8Text.split(separator: "\n").map(String.init)
      let json = ContentBlockerConverter().convertArray(
        rules: splitText,
        safariVersion: SafariVersion.autodetect(),
        advancedBlocking: false
      )
      .safariRulesJSON

      let appGroupID = "group.com.mickytsai.ADBlocker"
      guard
        let containerURL = FileManager.default.containerURL(
          forSecurityApplicationGroupIdentifier: appGroupID)
      else { return }
      let fileURL = containerURL.appendingPathComponent("blockerList.json")
      try json.write(to: fileURL, atomically: true, encoding: .utf8)
    }
  )
}

extension SafariConverterLibService: TestDependencyKey {
  public static let testValue = Self(
    updateRules: unimplemented("updateRules")
  )
}

extension DependencyValues {
  public var safariConverterLibService: SafariConverterLibService {
    get { self[SafariConverterLibService.self] }
    set { self[SafariConverterLibService.self] = newValue }
  }
}
