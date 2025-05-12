//
//  CustomTextField.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var value: String
    @State private var isPasswordHidden: Bool = true

    var title: String = "title"
    var placeholderText: String = "placeholder here"
    var errorMessage: String = "error message"
    var isSecureText: Bool = false
    var textContentType: UITextContentType? = nil
    var keyboardType: UIKeyboardType = .default
    @Binding var isDisabled: Bool
    var onSubmit: () -> Void = { }

    var body: some View {
        Text(title)
            .foregroundStyle(Color.AppPalette.Text.secondary)
            .font(.system(size: 15))

        VStack(alignment: .leading) {
            if isSecureText {
                ZStack(alignment: .trailing) {
                    if isPasswordHidden {
                        SecureField("", text: $value)
                            .foregroundStyle(isDisabled ?
                                             Color.AppPalette.TextField.secondary :
                                                Color.AppPalette.TextField.primary)
                            .textContentType(textContentType)
                            .keyboardType(keyboardType)
                            .submitLabel(.return) // TODO: param
                            .disabled(isDisabled)
                            .onSubmit {
                                onSubmit()
                            }
                        #if DEBUG
                            .simultaneousGesture(TapGesture().onEnded {
                                print("\(title) pressed")
                            })
                        #endif
                    } else {
                        TextField("", text: $value)
                            .disableAutocorrection(true)
                            .foregroundStyle(isDisabled ?
                                             Color.AppPalette.TextField.secondary :
                                                Color.AppPalette.TextField.primary)
                            .textContentType(textContentType)
                            .keyboardType(keyboardType)
                            .submitLabel(.return) // TODO: param
                            .disabled(isDisabled)
                            .onSubmit {
                                onSubmit()
                            }
                        #if DEBUG
                            .simultaneousGesture(TapGesture().onEnded {
                                print("\(title) pressed")
                            })
                        #endif
                    }

                    Button {
                        isPasswordHidden.toggle()
                    } label: {
                        Image(systemName: isPasswordHidden ? "eye.fill" : "eye.slash.fill")
                    }
                    .foregroundStyle(Color.AppPalette.Main.appPurple)
                    .disabled(isDisabled)
                }
            } else {
                TextField("", text: $value)
                    .foregroundStyle(isDisabled ?
                                     Color.AppPalette.TextField.secondary :
                                        Color.AppPalette.TextField.primary)
                    .textContentType(textContentType)
                    .keyboardType(keyboardType)
                    .submitLabel(.next) // TODO: param
                    .disabled(isDisabled)
                    .onSubmit {
                        onSubmit()
                    }
                #if DEBUG
                    .simultaneousGesture(TapGesture().onEnded {
                        print("\(title) pressed")
                    })
                #endif
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
    CustomTextField(value: .constant(""),
                    isDisabled: .constant(false))
}
