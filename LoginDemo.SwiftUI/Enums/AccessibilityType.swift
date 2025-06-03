//
//  AccessibilityType.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 31/5/2025.
//

import Foundation

enum AccessibilityIdentifierType: String {
    case button
    case buttonTitle = "button-title"
    case plainTextField = "plain-text-field"
    case secureTextField = "secure-text-field"
    case separatorLine = "separator-line"
    case errorTextMessage = "error-text-message"
    case image
    case text
}

enum AccessibilityLabelType: String {
    case signIn = "sign-in-view"
    case button = "button"
    case text = "text"
}
