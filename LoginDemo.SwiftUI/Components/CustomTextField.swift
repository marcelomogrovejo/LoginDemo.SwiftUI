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

        static let defaultTitle: LocalizedStringKey = "lang-default-custom-text-field-title-key"
        static let defaultSecureTextAccessibilityId: String = "custom".getAccessibilityIdentifier(type: .secureField)
        static let defaultPlainTextAccessibilityId: String = "custom".getAccessibilityIdentifier(type: .plainTextField)

        struct Ids {
            static let toggleButtonId: String = "toggle"
            static let toggleImageVisibleid: String = "show"
            static let toggleImageHiddenid: String = "hide"
        }
    }

    @Binding var value: String
    @State private var isHidden: Bool = true

    // TODO: WARNING
    // Components shouldn't know how to get identifiers and labels, it just has to receibe them.
    // Create default ones to be default values and receive them as parameters from the views
    // which implements them.
    // WARNING: check out the secure and plain text field identifiers, to keep the ui test working
    // as expected.
    var title: LocalizedStringKey?
    var accessibilityId: String?
    var accessibilityLabelValue: LocalizedStringKey?
    var placeholderText: LocalizedStringKey = "placeholder here"
    var errorMessage: LocalizedStringKey = ""
    var accessibilityErrorLabelValue: LocalizedStringKey = "Something was wrong"
    var isSecureText: Bool = false
    var textContentType: UITextContentType? = nil
    var keyboardType: UIKeyboardType = .default
    @Binding var isDisabled: Bool
    var onSubmit: () -> Void = { }

//    lang-sign-in-view-username-title-key

    var body: some View {
        Text(title ?? Constants.defaultTitle)
            .foregroundStyle(Color.AppPalette.TextField.secondary)
            .font(.system(size: Constants.titleFontSize))
            .accessibilityHidden(true)

        VStack(alignment: .leading) {
            if isSecureText {
                ZStack(alignment: .trailing) {
                    if isHidden {
                        // Textfield content hidden
                        SecureField(placeholderText, text: $value)
                            .foregroundStyle(isDisabled ?
                                             Color.AppPalette.TextField.secondary :
                                                Color.AppPalette.TextField.primary)
                            .textContentType(textContentType)
                            .keyboardType(keyboardType)
                            .submitLabel(.return) // TODO: pass it as param
                            .disabled(isDisabled)
                            .onSubmit {
                                onSubmit()
                            }
                            .accessibilityLabel("\(title) textfield")
                            .accessibilityIdentifier("\(accessibilityId.getAccessibilityIdentifier(type: .secureField))")
                        #if DEBUG
                            .simultaneousGesture(TapGesture().onEnded {
                                print("\(title) pressed")
                            })
                        #endif
                    } else {
                        // Textfield content visible
                        TextField(placeholderText, text: $value)
                            .disableAutocorrection(true)
                            .foregroundStyle(isDisabled ?
                                             Color.AppPalette.TextField.secondary :
                                                Color.AppPalette.TextField.primary)
                            .textContentType(textContentType)
                            .keyboardType(keyboardType)
                            .submitLabel(.return) // TODO: pass it as param
                            .disabled(isDisabled)
                            .onSubmit {
                                onSubmit()
                            }
                            .accessibilityLabel("\(title) textfield")
                            .accessibilityIdentifier("\(accessibilityId.getAccessibilityIdentifier(type: .plainTextField))")
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
                TextField(placeholderText, text: $value)
                    .foregroundStyle(isDisabled ?
                                     Color.AppPalette.TextField.secondary :
                                        Color.AppPalette.TextField.primary)
                    .textContentType(textContentType)
                    .keyboardType(keyboardType)
                    .submitLabel(.next) // TODO: pass it as param
                    .disabled(isDisabled)
                    .onSubmit {
                        onSubmit()
                    }
                    .accessibilityLabel("\(title) textfield")
                    .accessibilityIdentifier("\(accessibilityId.getAccessibilityIdentifier(type: .plainTextField))")
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
                .accessibilityIdentifier("\(accessibilityId.getAccessibilityIdentifier(type: .separatorLine))")

            Text(errorMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.AppPalette.TextField.error)
                .accessibilityIdentifier("\(accessibilityId.getAccessibilityIdentifier(type: .errorTextMessage))")
                .accessibilityLabel(accessibilityErrorLabelValue)
        }
    }
}

#Preview {
    CustomTextField(value: .constant(""),
                    isDisabled: .constant(false))
}
