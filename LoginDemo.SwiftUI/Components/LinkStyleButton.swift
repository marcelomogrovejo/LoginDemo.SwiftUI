//
//  LinkStyleButton.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 04/05/2025.
//

import SwiftUI

struct LinkStyleButton: View {

    // TODO: Warning !!
    // Using title to get the accessibilityIdentifier is not a good idea because for instance
    // "Forgot Password?" will become in "forgot-password?-button-id" with the "?" character
    // in the middle. Or worse, there can be an emoji or whatever symbol.
    var title: String = "button title"
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
            .accessibilityLabel(title)
            .accessibilityIdentifier("\(title.getAccessibiltiyId(suffix: "button"))")
        }
    }
}

#Preview {
    LinkStyleButton()
}
