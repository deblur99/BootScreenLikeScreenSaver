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
    
    @State private var mouseTimer: Timer?

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
                startMouseHiding()  // 전체화면 시 마우스 숨김
            }
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didExitFullScreenNotification)) { _ in
                isFullScreen = false
                isShowingSettingsRightSidebar = true
                configurationManager.resetTimer()
                stopMouseHiding()  // 전체화면 시 마우스 보임
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
            .environmentObject(configurationManager)
        }
    }

    private func toggleRightSidebar() {
        withAnimation(.spring(duration: AppConfiguration.durationOfFading)) {
            isShowingSettingsRightSidebar.toggle()
        }
    }
    
    // MARK: - 마우스 커서 숨기기 메서드
    
    // 마우스를 움직이면 마우스 커서를 보이고, 일정 시간 동안 움직임이 없으면 마우스 커서를 다시 숨김
    private func startMouseHiding() {
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
            self.resetMouseHidingTimer()
            return event
        }
        
        resetMouseHidingTimer() // 타이머 시작
    }
    
    // 기존 타이머 해제 -> 2초 타이머 새로 걺 -> 커서 표시
    private func resetMouseHidingTimer() {
        mouseTimer?.invalidate()
        
        // 2초 동안 움직임이 없으면 마우스 커서 숨김
        mouseTimer = Timer.scheduledTimer(withTimeInterval: configurationManager.mouseHidingTimeout, repeats: false) { _ in
            NSCursor.hide()
        }
        
        // 즉시 커서 표시
        NSCursor.unhide()
    }
    
    // 뷰 사라지면 타이머 정리하고 커서도 표시함
    private func stopMouseHiding() {
        mouseTimer?.invalidate()
        NSCursor.unhide()
    }
}

#Preview {
    ContentView()
}
