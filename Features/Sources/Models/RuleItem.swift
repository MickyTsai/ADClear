//
//  RuleItem.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/30.
//

import Foundation

/// 用來顯示規則檔案格式
public struct RuleItem: Identifiable, Equatable {
  public let id = UUID()
  
  public var title: String
  public var discription: String
  
  public init(title: String, discription: String) {
    self.title = title
    self.discription = discription
  }
}
