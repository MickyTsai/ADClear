//
//  HomeFeature+Path.swift
//  Features
//
//  Created by Micky的mac mini  on 2026/5/26.
//
import ComposableArchitecture


extension HomeFeature {
  @Reducer
  enum Path {
    case about(AboutFeature)
    case blockerList(BlockerListFeature)
  }
}

extension HomeFeature.Path.State: Equatable {}
extension HomeFeature.Path.Action: Equatable {}
