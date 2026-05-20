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
      TextState("請開啟 Safari 延伸功能")
    } actions: {
      ButtonState(action: .alreadyEnableContentBlocker,
                  label: {TextState("好")})
      
      ButtonState(role: .cancel,
                  label: {TextState("取消")} )
    } message: {
      TextState("「前往啟用 Safari 延伸功能」設定 > App > Safari > 延伸功能"
      )
    }
  }
  
  static var tapBottomViewAlert: Self {
    AlertState {
      TextState("tapBottomViewAlert")
    } actions: {
      ButtonState(action: .openURL,
                  label: {TextState("openURL")})
    } message: {
      TextState("openURL")
    }
  }
}
