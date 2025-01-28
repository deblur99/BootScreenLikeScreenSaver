//
//  NotificationName.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/28/25.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Notification.Name {
    static let isMouseOnTop = Notification.Name("isMouseOnTop")
    static let isMouseOutOfTop = Notification.Name("isMouseOutOfTop")
}
