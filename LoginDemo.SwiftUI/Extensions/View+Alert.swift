//
//  View+Alert.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 12/5/2025.
//

import SwiftUI

extension View {

    func customeAlert(isPresented: Binding<Bool>,
                      title: LocalizedStringKey?,
                      message: LocalizedStringKey?,
                      buttonTitle: LocalizedStringKey?,
                      accessibilityId: String? = nil,
                      action: (() -> ())? = nil) -> some View {
        self.alert(
            Text(title ?? "Title"),
            isPresented: isPresented
        ) {
            Button(buttonTitle ?? "OK") {
                action?()
            }
        } message: {
            Text(message ?? "Some message")
        }
        .accessibilityIdentifier(accessibilityId ?? "custom-alert-id")
    }

}
