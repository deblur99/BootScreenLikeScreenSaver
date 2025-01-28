//
//  ScreenShareView.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/27/25.
//

import SwiftUI

struct ScreenSaverView: View {
    @EnvironmentObject var configurationManager: ConfigurationManager

    @Binding var isFullScreen: Bool

    @State var isMouseOnTop: Bool = false // 전체화면일 때만 사용
    @State var dismissButtonOffsetY: CGFloat = 0

    private let dismissButtonDestinationY: CGFloat = 50

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                #if os(macOS)
                // 전체화면일 때만 마우스 좌표 추적
                if isFullScreen {
                    ZStack {
                        // 마우스 커서가 상단에 위치할 시 풀스크린에 종료 바 표시
                        MouseTrackerView()
                            .frame(minWidth: geometry.size.width * 2)
                            .position(x: 0, y: 0)

                        if isMouseOnTop {
                            Button("화면 보호기 종료하기") {
                                isMouseOnTop = false
                                NSApplication.shared.windows.first?.toggleFullScreen(nil)
                                configurationManager.resetTimer()   // 타이머 종료
                            }
                            .position(x: geometry.size.width / 2, y: dismissButtonOffsetY)
                        }
                    }
                }
                #endif

                Image(systemName: "applelogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2 - 40
                    )
                    .foregroundStyle(Color(white: 1.0))

                // 설정화면에서 프로그레스 뷰 활성화 체크하면 나오는 부분
                if configurationManager.usingCircularProgressView {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.5)
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2 + 40
                        )
                }

                // 타이머 경과에 따라 마지막 Capsule의 width가 변동됨
                // width 크기는 0..200으로
                ZStack(alignment: .leading) {
                    Capsule()
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: ConfigurationManager.timerBarRange.upperBound)
                        .foregroundStyle(.gray)

                    Capsule()
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: configurationManager.widthOfProgressBarPerSecond)
                        .foregroundStyle(.white)
                }
                .frame(height: 1)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height - 120
                )
                .scaleEffect(y: 0.5)
            }
            .background(Color(white: 0.0))
        }
        
        // 마우스 커서가 전체화면 상단에 있으면 종료 버튼 표시
        .onReceive(NotificationCenter.default.publisher(for: .isMouseOnTop)) { _ in
            if !isMouseOnTop {
                isMouseOnTop = true
                dismissButtonOffsetY = dismissButtonDestinationY
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .isMouseOutOfTop)) { _ in
            isMouseOnTop = false
            dismissButtonOffsetY = 0.0
        }
    }
}



#Preview {
    ScreenSaverView(isFullScreen: .constant(false))
        .environmentObject(ConfigurationManager())
}
