//
//  CircleButton.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

import SwiftUI

struct GrowingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.purple)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct CircleButton: View {

    private var color: Color

    @Binding var isEnabled: Bool
    var action: (() -> ())? = nil

    init(isEnabled: Binding<Bool>,
         action: (() -> ())? = nil) {
        self.color = .AppPalette.Button.enabled
        self._isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            Image(systemName: "arrow.right.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(!isEnabled ?
                                 Color.AppPalette.Button.disabled : color)
                .frame(width: 80, height: 80)
        }
        // TODO: animation
//        .buttonStyle(GrowingButtonStyle())
        .disabled(!isEnabled)
    }
}

#Preview {
    CircleButton(isEnabled: .constant(false),
                 action: { print("Action performed") })
}
