# ADClear 🚫
ADClear is a Safari content blocker for iOS that removes ads and trackers using industry-standard filter lists — with zero privacy compromise.
---
ADClear 是一款 iOS Safari 廣告封鎖器，採用業界主流封鎖清單，在完全不侵犯隱私的前提下，為你過濾廣告與追蹤器。

## Features

- 🚫 **廣告與追蹤器封鎖** — 使用 EasyList 等主流封鎖清單，涵蓋主要廣告網路與追蹤腳本
- 🔄 **一鍵更新規則** — 手動觸發下載最新封鎖清單，隨時保持更新
- 📊 **封鎖統計** — 顯示已封鎖的網站數量
- 🔒 **隱私優先** — App 本身完全無法讀取你的瀏覽紀錄（詳見下方說明）
---

## 廣告阻擋原理與隱私說明

ADClear 採用 Apple 在 iOS 9 提供的 **WebKit Content Blocker API**。運作方式是：Safari 向 ADClear 詢問封鎖規則，ADClear 回傳一份 JSON 規則清單。在整個過程中，ADClear **完全不知道你瀏覽了哪些網站**，隱私獲得完整保護。

---

## Requirements

- iOS 26.0+
- Safari

---

## Installation

1. 從 App Store 下載 ADClear
2. 前往「**APP \> Safari \> 延伸功能**」，啟用 ADClear
3. 開啟 ADclear，點擊「更新規則」完成初始化

---

## How It Works

ADClear 在點擊「更新規則」更新時，從遠端下載 [EasyList][1] 封鎖清單，並透過 [SafariConverterLib][2] 將其轉換為 Safari 原生 JSON 格式，再交由系統套用至 Safari。

整個轉換與套用流程皆在本機完成，不經過任何第三方伺服器。

---

## Architecture

ADClear 採用現代 iOS 開發架構：

- **SwiftUI** — 介面框架
- **TCA (The Composable Architecture)** — 狀態管理，by [Point-Free][3]
- **swift-dependencies** — 依賴注入，by [Point-Free][4]
- **SafariConverterLib** — EasyList → Safari JSON 規則轉換，by [AdGuard][5]

---

## Related Projects

- [Blahker 巴拉剋][6] — 針對台灣網站蓋版廣告的 Safari 封鎖器，本專案的靈感來源
- [1Blocker][7] — 功能完整的商業廣告封鎖器，適合進階需求
- [SafariConverterLib][8] — ADClear 使用的規則轉換函式庫
- [EasyList][9] — 全球廣泛使用的開源封鎖清單


[1]:	https://easylist.to
[2]:	https://github.com/AdguardTeam/SafariConverterLib
[3]:	https://github.com/pointfreeco/swift-composable-architecture
[4]:	https://github.com/pointfreeco/swift-dependencies
[5]:	https://github.com/AdguardTeam/SafariConverterLib
[6]:	https://github.com/ethanhuang13/blahker
[7]:	https://1blocker.com
[8]:	https://github.com/AdguardTeam/SafariConverterLib
[9]:	https://easylist.to