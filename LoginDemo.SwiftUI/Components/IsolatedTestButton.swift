//
//  IsolatedTestButton.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 29/5/2025.
//

import SwiftUI

struct IsolatedTestButton: View {

    struct Constants {
        static let visibleImageName: String = "eye.slash.fill"
        static let visibleImageId: String = "show"
        static let hiddenImageName: String = "eye.fill"
        static let hiddenImageId: String = "hide"
        static let imageBottonPadding: CGFloat = 3
    }

    var title: String = "Password"
    @State private var isHidden: Bool = true

    var body: some View {
        Button {
            isHidden.toggle()
        } label: {
            // MARK: -
            // It should be 2 images otherwise the ui test doesn't find any image
            // in the hierarchy.
            VStack {
                Image(systemName: isHidden ?
                      Constants.visibleImageName :
                        Constants.hiddenImageName)
                .accessibilityIdentifier(isHidden ? Constants.visibleImageId.getAccessibilityIdentifier(type: .image) : Constants.hiddenImageId.getAccessibilityIdentifier(type: .image))

                Image(systemName: "")
            }
        }
        .foregroundStyle(Color.AppPalette.TextField.primary)
        .disabled(false)
        .padding(.bottom, Constants.imageBottonPadding)
        .accessibilityLabel(isHidden ? "Show \(title)" : "Hide \(title)")
        .accessibilityIdentifier("eye".getAccessibilityIdentifier(type: .button))
    }
}

#Preview {
    IsolatedTestButton()
}
