//
//  SettingsView.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/27/25.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var configurationManager: ConfigurationManager
    
    // Stepper 이전 값 저장을 위한 변수
    @State private var currentDuration: Double = ConfigurationManager.initialDuration
    @State private var currentMouseHidingTimeout: Double = ConfigurationManager.initialMouseHidingTimeout

    var durationString: String {
        "\(String(lroundl(configurationManager.duration)))분"
    }
    var mouseHidingTimeoutString: String {
        "\(String(lroundl(configurationManager.mouseHidingTimeout)))초"
    }

    var body: some View {
        List {
            Section("타이머 설정") {
                VStack(alignment: .leading, spacing: 20.0) {
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text("몇 분 동안 화면 보호기를 켜둘지 결정합니다.")
                        
                        Text("화면 보호기가 켜져 있는 동안, 마우스 커서를 화면 상단으로 옮기면 종료 버튼이 나타납니다.")
                            .lineLimit(nil)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    
                    HStack {
                        Text(durationString)
                            .frame(maxWidth: 50)

                        Slider(value: $configurationManager.duration, in: ConfigurationManager.durationTimerBarRange)
                        
                        Stepper("", value: $configurationManager.duration)
                            .onChange(of: configurationManager.duration) { newValue in
                                guard ConfigurationManager.durationTimerBarRange ~= newValue else {
                                    configurationManager.duration = self.currentDuration
                                    return
                                }
                                self.currentDuration = newValue
                            }
                            .frame(maxWidth: 20)
                    }

                    HStack {
                        Spacer()
                        
                        VStack(alignment: .center) {
                            HStack {
                                Button("짧게") {
                                    configurationManager.duration = 3.0
                                }

                                Button("적당히") {
                                    configurationManager.duration = 10.0
                                }

                                Button("길게") {
                                    configurationManager.duration = 30.0
                                }
                            }

                            HStack {
                                Button("더 길게") {
                                    configurationManager.duration = 60.0
                                }

                                Button("더 많이 길게") {
                                    configurationManager.duration = 120.0
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 32)
            }

            Section("종료 후 동작 설정") {
                VStack(alignment: .leading) {
                    Text("타이머가 종료되면 어떤 동작을 할지 결정합니다.")

                    Picker("", selection: $configurationManager.actionWhenFinish) {
                        ForEach(ConfigurationManager.ActionWhenFinish.allCases, id: \.self) { action in
                            Text(action.rawValue)
                                .tag(action)
                        }
                    }
                    #if os(macOS)
                    .pickerStyle(.radioGroup)
                    #else
                    .pickerStyle(.inline)
                    #endif
                    .listRowSeparator(.hidden)
                }
                .padding(.bottom, 32)
            }
            
            Section("화면 보호기 중 마우스 커서 숨김 시간") {
                VStack(alignment: .leading, spacing: 20.0) {
                    Text("화면 보호기가 켜져 있는 동안, 몇 초 동안 마우스 커서의 움직임이 없으면 숨길지 결정합니다.")
                        .lineLimit(nil)
                    
                    HStack {
                        Text(mouseHidingTimeoutString)
                            .frame(maxWidth: 50)
                        
                        Slider(value: $configurationManager.mouseHidingTimeout, in: ConfigurationManager.mouseHidingTimerBarRange)
                        
                        Stepper("", value: $configurationManager.mouseHidingTimeout)
                            .onChange(of: configurationManager.mouseHidingTimeout) { newValue in
                                guard ConfigurationManager.mouseHidingTimerBarRange ~= newValue else {
                                    configurationManager.mouseHidingTimeout = self.currentMouseHidingTimeout
                                    return
                                }
                                self.currentMouseHidingTimeout = newValue
                            }
                            .frame(maxWidth: 20)
                    }
                    .listRowSeparator(.hidden)
                }
                .padding(.bottom, 32)
            }
            
            Section("추가 설정") {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text("프로그레스 뷰 활성화")
                            
                            Text("활성화하면 타이머가 돌아가는 동안 애플 로고 하단에 프로그레스 뷰가 추가됩니다.")
                                .lineLimit(nil)
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $configurationManager.usingCircularProgressView)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    SettingView()
        .environmentObject(ConfigurationManager())
}
