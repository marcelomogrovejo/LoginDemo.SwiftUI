//
//  AccessibilityIdentifierType.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 31/5/2025.
//

import Foundation

enum AccessibilityIdentifierType: String {
    case button
    case buttonTitle = "button-title"
    case plainTextField = "plain-text-field"
    case secureField = "secure-text-field"
    case separatorLine = "separator-line"
    case errorTextMessage = "error-text-message"
    case image
    case text
}
