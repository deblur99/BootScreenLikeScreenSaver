//
//  MouseTrackerView.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/28/25.
//

import SwiftUI

// NSTrackingArea를 NSViewRepresentable로 감싸서 마우스 좌표 추적하기
struct MouseTrackerView: NSViewRepresentable {
    static var detectionHeight: Double = 100
    
    // 마우스 커서 인식 높이의 기본값은 100인데 밖에서 바꿀 수 있음
    func setDetectionHeight(_ height: Double) -> MouseTrackerView {
        Self.detectionHeight = height
        return self
    }

    class Coordinator: NSObject {
        var parent: NSView?

        let detectionThrottleInterval: TimeInterval = 0.1
        var canDetectMouse: Bool = true

        override init() {
            super.init()
            NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
                guard let self, self.canDetectMouse else { return event }

                // 앱 내부에서만 마우스 추적
                // - 앱 외부 화면에서의 마우스 좌표는 처리하지 않는다.
                guard let location = event.window?.contentView?.convert(event.locationInWindow, from: nil) else {
                    return event
                }
                let screenHeight = NSScreen.main?.frame.height ?? 0

                // 마우스 y축 좌표가 100 이내일 때 "isMouseOnTop" 메시지 전송
                if location.y <= detectionHeight {
                    NotificationCenter.default.post(name: .isMouseOnTop, object: nil)
                } else {
                    NotificationCenter.default.post(name: .isMouseOutOfTop, object: nil)
                }
                self.canDetectMouse = false

                DispatchQueue.main.asyncAfter(deadline: .now() + self.detectionThrottleInterval) {
                    self.canDetectMouse = true
                }

                return event
            }
        }

        func trackingArea(
            mouseEnteredOrMovedInsideTrackingArea trackingArea: NSTrackingArea
        ) {
            print("mouse entered or moved inside tracking area")
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        context.coordinator.parent = view
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
