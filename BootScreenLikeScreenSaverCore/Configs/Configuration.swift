//
//  Configuration.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/27/25.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

class ConfigurationManager: ObservableObject {
    static let initialDuration: Double = 3.0
    static let durationTimerBarRange: ClosedRange<Double> = 1 ... 200
    static let initialMouseHidingTimeout: Double = 1.0
    static let mouseHidingTimerBarRange: ClosedRange<Double> = 1 ... 5
    
    // SettingView에서 변경되는 속성값
    @Published var duration: Double = initialDuration
    @Published var mouseHidingTimeout: Double = initialMouseHidingTimeout
    @Published var actionWhenFinish: ActionWhenFinish = .repeat
    @Published var usingCircularProgressView: Bool = true
    
    // 타이머 관련 속성
    @Published var timer: Timer?
    @Published var remainingTime: Double = 0
    @Published var elapsedTime: Double = 0
    
    private var durationInSeconds: TimeInterval {
        return TimeInterval(Int(duration) * 60)
    }
    
    var widthOfProgressBarPerSecond: CGFloat {
        guard durationInSeconds > 0, elapsedTime > 0 else {
            return 0.0
        }
        let unit = ConfigurationManager.durationTimerBarRange.upperBound / durationInSeconds
        return elapsedTime * unit
    }
    
    // 타이머 시작
    func startTimer() {
        if timer != nil {
            return
        }
        remainingTime = durationInSeconds
        elapsedTime = 0
        // 1초마다 반복하여 handleTimerFire() 호출
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleWhenTimerFires), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    // 타이머 강제 종료 및 관련 변수 리셋
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        remainingTime = 0.0
        elapsedTime = 0.0
    }
    
    // 매 초마다 호출되는 메서드
    @objc func handleWhenTimerFires() {
        print(#function, "durationInSeconds:", durationInSeconds, "remainingTime:", remainingTime, "elapsedTime:", elapsedTime)
        remainingTime -= 1
        elapsedTime += 1
        if remainingTime <= 0 {
            handleWhenTimerEnds()
        }
    }
    
    /*
      타이머 처리 방식
      1) 타이머 계속 반복: elapsedTime만 초기화하고 타이머 중지 X
      2) 타이머 중지한 상태로 있기: 타이머만 중지
      3) 종료하기: 모두 초기화
    */
    // 타이머 종료 시 호출되는 메서드
    private func handleWhenTimerEnds() {
        switch actionWhenFinish {
        case .repeat:
            remainingTime = durationInSeconds
            elapsedTime = 0
        case .stop:
            timer?.invalidate()
            timer = nil
        case .exit:
            resetTimer()
            #if os(macOS)
            NSApplication.shared.windows.first?.toggleFullScreen(nil)
            #endif
        }
    }
    
    enum ActionWhenFinish: String, CaseIterable {
        case `repeat` = "타이머 계속 반복하기"
        case stop = "켜져 있는 상태로 두기"
        case exit = "전체 화면 종료하기"
    }
}
