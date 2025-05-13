//
//  CustomTextField.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

import SwiftUI

struct CustomTextField: View {

    struct Constants {
        static let titleFontSize: CGFloat = 15
        static let visiblePasswordImageName: String = "eye.fill"
        static let hiddenPasswordImageName: String = "eye.slash.fill"
        static let passwordImageBottonPadding: CGFloat = 3
    }

    @Binding var value: String
    @State private var isPasswordHidden: Bool = true

    var title: String = "title"
    var placeholderText: String = "placeholder here"
    var errorMessage: String = ""
    var isSecureText: Bool = false
    var textContentType: UITextContentType? = nil
    var keyboardType: UIKeyboardType = .default
    @Binding var isDisabled: Bool
    var onSubmit: () -> Void = { }

    var body: some View {
        Text(title)
            .foregroundStyle(Color.AppPalette.TextField.secondary)
            .font(.system(size: Constants.titleFontSize))

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
                        Image(systemName: isPasswordHidden ?
                              Constants.visiblePasswordImageName :
                                Constants.hiddenPasswordImageName)
                    }
                    .foregroundStyle(Color.AppPalette.TextField.primary)
                    .disabled(isDisabled)
                    .padding(.bottom, Constants.passwordImageBottonPadding)
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
                .fill(value == "" ?
                      Color.AppPalette.TextField.secondary :
                        Color.AppPalette.TextField.primary)
                .frame(height: 1)

            Text(errorMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.AppPalette.TextField.error)
        }
    }
}

#Preview {
    CustomTextField(value: .constant(""),
                    isDisabled: .constant(false))
}
