# ADclear 🚫

![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![Swift](https://img.shields.io/badge/swift-6.0-orange)
![License](https://img.shields.io/github/license/mickyt/ADclear)

ADclear is a Safari content blocker for iOS that removes ads and trackers using industry-standard filter lists — with zero privacy compromise.

---

ADclear 是一款 iOS Safari 廣告封鎖器，採用業界主流封鎖清單，在完全不侵犯隱私的前提下，為你過濾廣告與追蹤器。

## Features

- 🚫 **廣告與追蹤器封鎖** — 使用 EasyList 等主流封鎖清單，涵蓋主要廣告網路與追蹤腳本
- 🔄 **一鍵更新規則** — 手動觸發下載最新封鎖清單，隨時保持更新
- 📊 **封鎖統計** — 顯示已封鎖的網站與請求數量
- 🔒 **隱私優先** — App 本身完全無法讀取你的瀏覽紀錄（詳見下方說明）
- 🔜 **即將推出：白名單** — 可手動排除特定網站不受封鎖

---

## 廣告阻擋原理與隱私說明

部分廣告阻擋器是透過建立本機 VPN 的方式攔截流量，這代表它們能完整記錄你所有的網路行為，對隱私存在極大風險。

ADclear 採用 Apple 在 iOS 9 提供的 **WebKit Content Blocker API**。運作方式是：Safari 向 ADclear 詢問封鎖規則，ADclear 回傳一份 JSON 規則清單。在整個過程中，ADclear **完全不知道你瀏覽了哪些網站**，隱私獲得完整保護。

原始碼公開於此 GitHub，歡迎自行檢視。

---

## Requirements

- iOS 16.0+
- Safari

---

## Installation

1. 從 App Store 下載 ADclear（即將上架）
2. 開啟 ADclear，點擊「更新規則」完成初始化
3. 前往「**設定 > Safari > 內容阻擋器**」，啟用 ADclear

---

## How It Works

ADclear 在啟動或手動更新時，從遠端下載 [EasyList](https://easylist.to) 封鎖清單，並透過 [SafariConverterLib](https://github.com/AdguardTeam/SafariConverterLib) 將其轉換為 Safari 原生 JSON 格式，再交由系統套用至 Safari。

整個轉換與套用流程皆在本機完成，不經過任何第三方伺服器。

---

## Architecture

ADclear 採用現代 iOS 開發架構：

- **SwiftUI** — 介面框架
- **TCA (The Composable Architecture)** — 狀態管理，by [Point-Free](https://github.com/pointfreeco/swift-composable-architecture)
- **swift-dependencies** — 依賴注入，by [Point-Free](https://github.com/pointfreeco/swift-dependencies)
- **SafariConverterLib** — EasyList → Safari JSON 規則轉換，by [AdGuard](https://github.com/AdguardTeam/SafariConverterLib)

---

## Open Source

ADclear 為開源專案。

- 具備 Apple 開發者帳號者，可自行 clone 並安裝至裝置
- 歡迎提交 Issue 回報問題或建議功能
- 封鎖規則來自 [EasyList](https://easylist.to) 開源社群維護，可在不更新 App 的情況下自動更新

---

## Related Projects

- [Blahker 巴拉剋](https://github.com/ethanhuang13/blahker) — 針對台灣網站蓋版廣告的 Safari 封鎖器，本專案的靈感來源
- [1Blocker](https://1blocker.com) — 功能完整的商業廣告封鎖器，適合進階需求
- [SafariConverterLib](https://github.com/AdguardTeam/SafariConverterLib) — ADclear 使用的規則轉換函式庫
- [EasyList](https://easylist.to) — 全球廣泛使用的開源封鎖清單

---

## License

MIT License. See [LICENSE](./LICENSE) for details.
