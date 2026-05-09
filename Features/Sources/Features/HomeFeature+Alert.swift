//
//  HomeFeature+Alert.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/9.
//
import ComposableArchitecture

extension AlertState<HomeFeature.Action.Alert> {
  /// 未開啟 contentBlocker 警告
  static var disableContentBlockerAlert: Self {
    AlertState {
      TextState("disableContentBlockerAlert")
    } actions: {
      ButtonState(role: .cancel,
                  label: {TextState("cancel")} )
      ButtonState(action: .alreadyEnableContentBlocker,
                  label: {TextState("Enabled")})
      
    } message: {
      TextState("""
「前往啟用 Safari 延伸功能」
設定 > App > Safari > 延伸功能
""")
      
    }
  }
}
