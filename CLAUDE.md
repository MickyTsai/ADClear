## 專案目標

ADClear 是準備上架 App Store 的 iOS Safari 廣告阻擋 App。

App 使用 WebKit Content Blocker 機制，下載 EasyList 規則，透過
SafariConverterLib 轉換後提供給 Safari Content Blocker extension。

## 專案結構

- `ADClear/`
  - 主 App target 與 entitlements。
- `ContentBlocker/`
  - Safari Content Blocker extension。
  - 從 App Group 讀取 `blockerList.json`，不存在時使用 bundle 內建規則。
- `Features/Sources/Features/`
  - SwiftUI Views、TCA Reducers、navigation 與 alert。
- `Features/Sources/Services/`
  - 外部系統與副作用封裝，例如 Safari Content Blocker、規則下載與轉換。
- `Features/Sources/Models/`
  - 跨 feature/service 使用的資料模型。
- `Features/Tests/FeaturesTests/`
  - TCA reducer 單元測試。
- `ADClearTests/`、`ADClearUITests/`
  - App target 與 UI 測試。

## 架構規則

- 新增或修改畫面狀態與行為時，遵循現有 TCA 架構：
  - 狀態放在 Feature 的 `State`。
  - 使用者與系統事件定義為 `Action`。
  - 狀態轉換與副作用由 Reducer 處理。
  - View 僅負責顯示狀態與送出 Action。
- 網路、檔案、SafariServices 等副作用應封裝於 `Services` target。
- Service 必須透過 `swift-dependencies` 注入，並提供可測試的 dependency value。
- 跨模組資料型別放在 `Models` target。
- 導航沿用 `HomeFeature.Path` 與 TCA `StackState` 模式。
- 不要在非相關任務中重新命名既有識別字，即使名稱包含拼字錯誤。

## Content Blocker 注意事項

- 主 App 與 extension 共用 App Group：
  `group.com.mickytsai.ADBlocker`
- Content Blocker bundle identifier：
  `com.mickytsai.ADClear.ContentBlocker`
- 規則檔名為 `blockerList.json`。
- 修改上述常數、entitlements 或檔案流程時，必須同步檢查主 App、Service、extension 與 Xcode project 設定。
- 不可移除 bundle 內建規則的 fallback 行為，除非任務明確要求。

## 程式碼風格

- 遵循根目錄 `.swift-format`。
- 使用兩格縮排，單行原則上不超過 100 字元。
- 保持既有 SwiftUI、TCA 與 dependency injection 寫法。
- 避免不必要的 force unwrap；若必須使用，需能證明該值一定存在。
- 只修改任務需要的檔案，避免順便進行無關重構或大量格式化。

## 測試政策

- 本專案採 iOS-only 驗證路線。
- 不要把 `swift test` 當作主要驗證方式，也不要為了支援 macOS host 上的
  Swift Package 測試而加入額外的相容性分支或包裝程式碼。
- 修改後優先使用 Xcode 的 iOS Simulator 測試或 iOS build 驗證，例如
  `xcodebuild test -project ADClear.xcodeproj -scheme ADClear -destination 'platform=iOS Simulator,...'`。
- 若只需要確認可編譯，可使用
  `xcodebuild build -project ADClear.xcodeproj -scheme ADClear -destination generic/platform=iOS CODE_SIGNING_ALLOWED=NO`。


## Commit 規則

- 每個 commit 以功能類別拆分，不同功能（Service、Feature reducer、UI、Tests）分開 commit。
- 加上或調整程式碼註解不需在 commit message 說明，也不單獨建立 commit，直接併入相關功能的 commit。
