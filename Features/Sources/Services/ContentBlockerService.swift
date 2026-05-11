//
//  ContentBlockerService.swift
//  Features
//
//  Created by Micky on 2026/5/8.
//
import Dependencies
import SafariServices

// Safari 擴充功能 ContentBlocker
public struct ContentBlockerService: Sendable {
  /// 取得  ContentBlocker 擴充功能是否開啟
  public var getStateOfContentBlocker: @Sendable (String) async -> Bool
  
}

extension ContentBlockerService: DependencyKey {
  public static let liveValue = ContentBlockerService(
    getStateOfContentBlocker: { contentBlockerID in
      await withCheckedContinuation { continuation in
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerID) { state, _ in
          guard let state else {
            continuation.resume(returning: false)
            return
          }
          continuation.resume(returning: state.isEnabled)
        }
      }
    }
  )
}

extension ContentBlockerService: TestDependencyKey {
  public static let testValue = ContentBlockerService(
    getStateOfContentBlocker: unimplemented("getStateOfContentBlocker", placeholder: false)
  )
}

extension DependencyValues {
  public var contentBlockerService: ContentBlockerService {
    get { self[ContentBlockerService.self] }
    set { self[ContentBlockerService.self] = newValue }
  }
}
