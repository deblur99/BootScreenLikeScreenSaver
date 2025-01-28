//
//  BootScreenLikeScreenSaverApp.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/22/25.
//

import SwiftUI

// MARK: - NotificationCenter 네임스페이스

extension NSNotification.Name {
    static let openSettings = Notification.Name("openSettings")
    static let toggleFullScreen = Notification.Name("toggleFullScreen")
}

@main
struct BootScreenLikeScreenSaverApp: App {
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: AppConfiguration.defaultWindowSize.width,
                    minHeight: AppConfiguration.defaultWindowSize.height
                )
                .onAppear {
                    DispatchQueue.main.async {
                        NSApplication.shared.windows.first?.center()
                    }
                }
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button(AppConfiguration.aboutTitle) {
                    self.openWindow(id: "about")
                }
            }

            CommandGroup(after: .appSettings) {
                self.getCommandButton(from: .openSettings)
                self.getCommandButton(from: .toggleFullScreen)
            }
        }

        Window(AppConfiguration.aboutTitle, id: "about") {
            AboutView()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 콘텐츠 크기 설정
                .onAppear {
                    DispatchQueue.main.async {
                        if let aboutWindow = NSApplication.shared.windows.last {
                            aboutWindow.setContentSize(NSSize(width: 400, height: 250)) // 초기 크기
                            aboutWindow.styleMask.remove(.resizable) // 크기 조정 방지
                            aboutWindow.standardWindowButton(.zoomButton)?.isHidden = true // 최대화 버튼 비활성화
                            aboutWindow.isMovableByWindowBackground = true // 창 제목을 제외한 배경으로 이동 가능
                        }
                    }
                }
        }
        .defaultSize(width: 400, height: 250)
    }

    private func getCommandButton(from notificationName: NSNotification.Name) -> some View {
        let label: LocalizedStringKey = switch notificationName {
        case .openSettings: "설정"
        case .toggleFullScreen: "전체 화면 토글"
        default: "레이블 텍스트 없음"
        }

        let shortcut: KeyEquivalent? = switch notificationName {
        case .openSettings: ","
        case .toggleFullScreen: "f"
        default: nil
        }

        let modifiers: EventModifiers? = switch notificationName {
        case .openSettings: .command
        case .toggleFullScreen: [.control, .command]
        default: nil
        }

        return Button(label) {
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
        .applyShortcut(shortcut, modifiers: modifiers)
    }
}

// MARK: - Commands, 키보드 단축키 지정 View modifier

extension Button {
    @ViewBuilder
    func applyShortcut(_ shortcut: KeyEquivalent?, modifiers: EventModifiers? = nil) -> some View {
        if let shortcut {
            if let modifiers {
                self.keyboardShortcut(shortcut, modifiers: modifiers)
            } else {
                self.keyboardShortcut(shortcut)
            }
        } else {
            self
        }
    }
}
