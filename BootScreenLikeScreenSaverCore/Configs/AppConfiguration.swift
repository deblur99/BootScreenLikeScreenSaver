//
//  AppConfiguration.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/27/25.
//

import Foundation

enum AppConfiguration {
    // MARK: - out ContentView
    static let title = "화면 보호기"
    static let defaultWindowSize = CGSize(width: 800, height: 600)
    
    // MARK: - in ContentView
    // 우측 SettingsView가 표시될 때, 해당 뷰의 너비만큼 ScreenSaverView가 좌측으로 밀린다.
    static let widthOfSettingView: CGFloat = 300
    static let durationOfFading: Double = 0.3
}
