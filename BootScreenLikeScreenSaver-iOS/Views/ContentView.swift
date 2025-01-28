//
//  ContentView.swift
//  BootScreenLikeScreenSaver-iOS
//
//  Created by 한현민 on 1/28/25.
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
                            isShowingSettingsRightSidebar = false
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
            
            // environmentObject
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
