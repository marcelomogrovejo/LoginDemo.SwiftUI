//
//  View+Alert.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 12/5/2025.
//

// Source: https://stackoverflow.com/questions/68178219/swiftui-creating-custom-alert

import SwiftUI

extension View {

    func customeAlert(isPresented: Binding<Bool>, title: String?, message: String?, buttonTitle: String?, action: (() -> ())? = nil) -> some View {
        self.alert(isPresented: isPresented) {
            Alert(
                title: Text(title ?? "Title"),
                message: Text(message ?? "Some message"),
                dismissButton: .default(Text(buttonTitle ?? "OK")) { action?() }
            )
        }
    }

}
