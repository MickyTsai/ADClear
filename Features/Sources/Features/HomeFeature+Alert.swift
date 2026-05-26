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
  
  /// 點擊 BottomView 顯示的提示
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
  
  /// 更新規則數量提示
  static func fetchRulesCountAlert(count: Int) -> Self {
    var title = TextState("更新成功")
    var message = TextState("成功更新 \(count) 條規則")
    let actionBtn = ButtonState<HomeFeature.Action.Alert>(role: .cancel,
                                                          label: {TextState("好")} )
    if count == 0 {
      title = TextState("更新失敗")
      message = TextState("請稍後再試")
    }
    
    return AlertState(title: { title },
                      actions: { actionBtn },
                      message: { message })
    
  }
}
