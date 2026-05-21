//
//  ContentBlockerRequestHandler.swift
//  ContentBlocker
//
//  Created by Micky on 2026/5/7.
//

import MobileCoreServices
import UIKit

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
  private let fileName = "blockerList.json"

  func beginRequest(with context: NSExtensionContext) {
    // 優先從 App Group 讀取（來源：SafariConverterLibService）
    let appGroupID = "group.com.mickytsai.ADBlocker"
    let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)!
    let fileURL = containerURL.appendingPathComponent(fileName)
    if FileManager.default.fileExists(atPath: fileURL.path),
      let attachment = NSItemProvider(contentsOf: fileURL)
    {
      let item = NSExtensionItem()
      item.attachments = [attachment]
      context.completeRequest(returningItems: [item], completionHandler: nil)
      return
    }

    // 備用：從 Bundle 讀取內建規則
    if let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json"),
      let attachment = NSItemProvider(contentsOf: fileURL)
    {
      let item = NSExtensionItem()
      item.attachments = [attachment]
      context.completeRequest(returningItems: [item], completionHandler: nil)
      return
    }
  }
}
