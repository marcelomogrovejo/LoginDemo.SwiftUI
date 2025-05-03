//
//  MainButtonView.swift
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

struct MainButtonView: View {

    var title: String = "Press Me"
    var action: (() -> ()?)? = nil

    var body: some View {
        Button(title) {
            print("action performed")
        }
        .buttonStyle(GrowingButtonStyle())
    }
}

#Preview {
    MainButtonView()
}
