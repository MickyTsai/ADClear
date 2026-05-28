//
//  MFMailComposeService.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/28.
//

import Dependencies
import MessageUI

public struct MFMailComposeService: Sendable {
  public var canSendMail: @Sendable () async -> Bool
}

extension MFMailComposeService: DependencyKey {
  public static let liveValue = Self(
    canSendMail: {
      return await MFMailComposeViewController.canSendMail()
    }
  )
}

extension MFMailComposeService: TestDependencyKey {
  public static let testValue = Self(
    canSendMail: unimplemented("canSendMail", placeholder: false)
  )
}

extension DependencyValues {
  public var mailComposeService: MFMailComposeService {
    get { self[MFMailComposeService.self] }
    set { self[MFMailComposeService.self] = newValue }
  }
}
