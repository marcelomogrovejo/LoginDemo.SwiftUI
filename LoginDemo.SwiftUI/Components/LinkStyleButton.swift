//
//  LinkStyleButton.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 04/05/2025.
//

import SwiftUI

struct LinkStyleButton: View {

    struct Constants {
        static let defaultButtonTitle = LocalizedStringKey("link-style-button-title")
        static let defaultAccessibilityLabel: LocalizedStringKey = "link-style-button"
        static let defaultAccessibilityIdentifier: String = "link-style".getAccessibilityIdentifier(type: .button)
    }

    var title: LocalizedStringKey = Constants.defaultButtonTitle
    var accessibilityLabelValue: LocalizedStringKey?
    var accessibilityId: String?
    var action: () -> Void = {}

    var body: some View {
        VStack(spacing: 2) {
            Button {
                action()
            } label: {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.AppPalette.Button.enabled)
            }
            .overlay {
                Rectangle()
                    .offset(y: 13)
                    .fill(Color.AppPalette.Button.enabled)
                    .frame(height: 1)
            }
            .accessibilityLabel(accessibilityLabelValue ?? Constants.defaultAccessibilityLabel)
            .accessibilityIdentifier(accessibilityId ?? Constants.defaultAccessibilityIdentifier)
        }
    }
}

#Preview {
    LinkStyleButton()
}
