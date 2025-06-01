//
//  String+AccessibilityIdentifier.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 26/5/2025.
//

import Foundation

extension String {

    /// Returns an identifier based on value and type
    /// - Parameter type: AccessibilityIdentifierType
    /// - Returns: a unique identifier id
    func getAccessibilityIdentifier(type: AccessibilityIdentifierType) -> String {
        String(self.lowercased().replacingOccurrences(of: " ", with: "-") + "-" + type.rawValue + "-id")
    }
}
