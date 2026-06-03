//
//  RuleItem.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/30.
//

import Foundation

/// 用來顯示規則檔案格式
public struct RuleItem: Identifiable, Equatable, Sendable {
  public let id = UUID()
  
  public var domain: String
  public var selectors: [String]
  
  public init(domain: String, selectors: [String]) {
    self.domain = domain
    self.selectors = selectors
  }
}
