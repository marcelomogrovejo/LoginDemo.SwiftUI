//
//  CustomTextField.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

import SwiftUI

enum TextFieldFocusType: Hashable {
    case email
    case password
}

struct CustomTextField: View {

    struct Constants {
        static let titleFontSize: CGFloat = 15
        static let visibleImageName: String = "eye.slash.fill"
        static let hiddenImageName: String = "eye.fill"
        static let toggleImageBottonPadding: CGFloat = 3
        static let toggleButtonHeight: CGFloat = 25

        struct Ids {
            static let toggleButtonId: String = "toggle"
            static let toggleImageVisibleid: String = "show"
            static let toggleImageHiddenid: String = "hide"
        }
    }

    @Binding var value: String
    @State private var isHidden: Bool = true

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
            .accessibilityHidden(true)

        VStack(alignment: .leading) {
            if isSecureText {
                ZStack(alignment: .trailing) {
                    if isHidden {
                        // Textfield content hidden
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
                            .accessibilityLabel("\(title) textfield")
                            .accessibilityIdentifier("\(title.getAccessibilityIdentifier(type: .secureField))")
                        #if DEBUG
                            .simultaneousGesture(TapGesture().onEnded {
                                print("\(title) pressed")
                            })
                        #endif
                    } else {
                        // Textfield content visible
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
                            .accessibilityLabel("\(title) textfield")
                            .accessibilityIdentifier("\(title.getAccessibilityIdentifier(type: .plainTextField))")
                        #if DEBUG
                            .simultaneousGesture(TapGesture().onEnded {
                                print("\(title) pressed")
                            })
                        #endif
                    }

                    Button {
                        isHidden.toggle()
                    } label: {
                        VStack{
                            Image(systemName: isHidden ?
                                  Constants.visibleImageName :
                                    Constants.hiddenImageName)
                            .accessibilityIdentifier(isHidden ?
                                                     Constants.Ids.toggleImageVisibleid.getAccessibilityIdentifier(type: .image) :
                                                        Constants.Ids.toggleImageHiddenid.getAccessibilityIdentifier(type: .image))

                            Image(systemName: "")
                        }
                    }
                    .foregroundStyle(Color.AppPalette.TextField.primary)
                    .disabled(isDisabled)
                    .padding(.bottom, Constants.toggleImageBottonPadding)
                    .accessibilityLabel(isHidden ? "Show \(title)" : "Hide \(title)")
                    .accessibilityIdentifier(Constants.Ids.toggleButtonId.getAccessibilityIdentifier(type: .button))
                    .frame(height: Constants.toggleButtonHeight)
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
                    .accessibilityLabel("\(title) textfield")
                    .accessibilityIdentifier("\(title.getAccessibilityIdentifier(type: .plainTextField))")
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
                .accessibilityIdentifier("\(title.getAccessibilityIdentifier(type: .separatorLine))")

            Text(errorMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.AppPalette.TextField.error)
                .accessibilityIdentifier("\(title.getAccessibilityIdentifier(type: .errorTextMessage))")
        }
    }
}

#Preview {
    CustomTextField(value: .constant(""),
                    isDisabled: .constant(false))
}
