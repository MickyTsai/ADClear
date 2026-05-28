//
//  AboutFeature+Alert.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/28.
//

import ComposableArchitecture

extension AlertState<AboutFeature.Action.Alert> {
  /// 未開啟 iOSMail 功能提示
  static var pleaseEnableMail: Self {
    AlertState {
      TextState("請開啟 iOSMail 功能")
    } actions: {
      ButtonState(action: .cancel,
                  label: {TextState("好")})
    } message: {
      TextState("請先至 iOS 郵件 app 登入信箱"
      )
    }
  }
}
