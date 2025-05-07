//
//  CustomTextField.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

import SwiftUI

struct CustomTextField: View {

    @Binding var value: String
    @FocusState private var focusState: TextFieldFocusable?
    @State private var isPasswordHidden: Bool = true

    var title: String = "title"
    var placeholderText: String = "placeholder here"
    var errorMessage: String = "error message"
    var isSecureText: Bool = false
    var textContentType: UITextContentType? = nil
    var keyboardType: UIKeyboardType = .default
    var focus: TextFieldFocusable? = nil

    var body: some View {
        Text(title)
            .foregroundStyle(Color.AppPalette.Text.secondary)
            .font(.system(size: 15))

        VStack(alignment: .leading) {
            if isSecureText {
                ZStack(alignment: .trailing) {
                    if isPasswordHidden {
                        SecureField("", text: $value)
                            .foregroundStyle(Color.AppPalette.TextField.primary)
                    } else {
                        TextField("", text: $value)
                            .disableAutocorrection(true)
                            .foregroundStyle(Color.AppPalette.TextField.primary)
                    }

                    Button {
                        isPasswordHidden.toggle()
                    } label: {
                        Image(systemName: isPasswordHidden ? "eye.fill" : "eye.slash.fill")
                    }
                    .foregroundStyle(Color.AppPalette.Main.appPurple)
                }
            } else {
                TextField("", text: $value)
                    .foregroundStyle(Color.AppPalette.TextField.primary)
                    .textContentType(textContentType)
                    .keyboardType(keyboardType)
                    .submitLabel(.next)
                    .focused($focusState, equals: focus)
                    .onSubmit {
                        // TODO: figure out how to send the focus to the next textField
//                        focus = .password
                        // also if password, can trigger the login() function as the main button
                    }
            }

            Rectangle()
                .fill(value == "" ? Color.black.opacity(0.08) : Color.AppPalette.Main.appPurple)
                .frame(height: 1)

            Text(errorMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.AppPalette.Text.error)
        }
    }
}

#Preview {
    CustomTextField(value: .constant(""))
}
