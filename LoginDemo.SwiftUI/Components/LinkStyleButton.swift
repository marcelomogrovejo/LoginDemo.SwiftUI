//
//  LinkStyleButton.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 04/05/2025.
//

import SwiftUI

struct LinkStyleButton: View {

    var title: String = "button title"
//    var action: TODO:

    var body: some View {
        VStack(spacing: 2) {
            Button {
                // TODO: Action
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

        }
    }
}

#Preview {
    LinkStyleButton()
}
