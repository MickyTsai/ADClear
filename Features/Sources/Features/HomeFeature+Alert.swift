//
//  HomeFeature+Alert.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/9.
//
import ComposableArchitecture

extension AlertState<HomeFeature.Action.Alert> {
  /// 未開啟 contentBlocker 提示
  static var disableContentBlockerAlert: Self {
    AlertState {
      TextState("請開啟延伸功能")
    } actions: {
      ButtonState(action: .alreadyEnableContentBlocker,
                  label: {TextState("已啟用")})
      
      ButtonState(role: .cancel,
                  label: {TextState("取消")} )
    } message: {
      TextState("請先「啟用 延伸功能」:設定 > App > 瀏覽器 > 延伸功能 中開啟"
      )
    }
  }
}
