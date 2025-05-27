//
//  XCTestCase+Screenshot.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 27/5/2025.
//

import XCTest

extension XCTestCase {

    func captureScreenshot(name: String, lifetime: XCTAttachment.Lifetime = .deleteOnSuccess) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = lifetime
        add(attachment)
    }
}
