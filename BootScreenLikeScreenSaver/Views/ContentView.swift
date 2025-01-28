//
//  ContentView.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/22/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var configurationManager = ConfigurationManager()

    @State private var isShowingSettingsRightSidebar = true
    @State private var isFullScreen = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                HStack(spacing: 0.0) {
                    ScreenSaverView(isFullScreen: $isFullScreen)
                        .frame(width: isShowingSettingsRightSidebar
                            ? geometry.size.width - AppConfiguration.widthOfSettingView
                            : geometry.size.width)

                    if isShowingSettingsRightSidebar {
                        SettingView()
                            .frame(width: isShowingSettingsRightSidebar
                                ? AppConfiguration.widthOfSettingView
                                : 0)
                    }
                }
            }
            .navigationTitle(AppConfiguration.title)

            .toolbar {
                if !isFullScreen {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            NSApplication.shared.windows.first?.toggleFullScreen(nil)
                            isShowingSettingsRightSidebar = false
                            configurationManager.startTimer() // 타이머 시작
                        } label: {
                            Image(systemName: "play.fill")
                        }
                        .help("화면 보호기를 시작하려면 클릭하세요")
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            toggleRightSidebar()
                        } label: {
                            Image(systemName: "gear")
                        }
                        .help("화면 보호기 관련 설정을 변경하려면 클릭하세요")
                    }
                }
            }
            
            // 전체화면 on/off 옵저버
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didEnterFullScreenNotification)) { _ in
                isFullScreen = true
                isShowingSettingsRightSidebar = false
            }
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didExitFullScreenNotification)) { _ in
                isFullScreen = false
                isShowingSettingsRightSidebar = true
                configurationManager.resetTimer()
            }
            // ctrl + cmd + f 단축키 이벤트 처리
            .onReceive(NotificationCenter.default.publisher(for: .toggleFullScreen)) { _ in
                DispatchQueue.main.async {
                    NSApplication.shared.windows.first?.toggleFullScreen(nil)
                }
            }
            // cmd + , 단축키 이벤트 처리
            .onReceive(NotificationCenter.default.publisher(for: .openSettings)) { _ in
                if !isFullScreen {
                    toggleRightSidebar()
                }
            }

            // environmentObject
            // TODO: 전체화면 중 마우스로 툴바 영역 가리킬 시 툴바 표시하기
            .environmentObject(configurationManager)
        }
    }

    private func toggleRightSidebar() {
        withAnimation(.spring(duration: AppConfiguration.durationOfFading)) {
            isShowingSettingsRightSidebar.toggle()
        }
    }
}

#Preview {
    ContentView()
}
