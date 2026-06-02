//
//  BlockerListRule.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/30.
//

/// ContentBlocker 規則檔案格式（blockerList.json）
public struct BlockerListRule: Codable, Equatable {
  public let trigger: Trigger
  public let action: Action

  public struct Trigger: Codable, Equatable {
    public let urlFilter: String
    public let urlFilterIsCaseSenstive: Bool?
    public let ifDomain: [String]?
    public let unlessDomain: [String]?
    public let resourceType: [ResourceType]?
    public let loadType: [LoadType]?
    public let ifTopURL: [String]?
    public let unlessTopURL: [String]?

    public enum CodingKeys: String, CodingKey {
      case urlFilter = "url-filter"
      case urlFilterIsCaseSenstive = "url-filter-is-case-sensitive"
      case ifDomain = "if-domain"
      case unlessDomain = "unless-domain"
      case resourceType = "resource-type"
      case loadType = "load-type"
      case ifTopURL = "if-top-url"
      case unlessTopURL = "unless-top-url"
    }

    public enum ResourceType: String, Codable, Equatable {
      case document
      case image
      case styleSheet = "style-sheet"
      case script
      case font
      case raw
      case svg = "svg-document"
      case media
      case popup
      case fetch
      case other
      case websocket
      case ping
      case unknown
      
      public init(from decoder: any Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = ResourceType(rawValue: value) ?? .unknown
      }
    }

    public enum LoadType: String, Codable, Equatable {
      case firstParty = "first-party"
      case thirdParty = "third-party"
      case unknown
      
      public init(from decoder: any Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = LoadType(rawValue: value) ?? .unknown
      }
    }
  }

  public struct Action: Codable, Equatable {
    public let type: ActionType
    public let selector: String?

    public enum ActionType: String, Codable {
      case block
      case blockCookies = "block-cookies"
      case cssDisplayNone = "css-display-none"
      case ignorePreviousRules = "ignore-previous-rules"
      case makeHttps = "make-https"
      case unknown
      
      public init(from decoder: any Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        self = ActionType(rawValue: value) ?? .unknown
      }
    }
  }
}
