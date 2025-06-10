//
//  CustomTextField.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

import SwiftUI
import CommonAccessibility

enum TextFieldFocusType: Hashable {
    case email
    case password
}

struct CustomTextField: View {

    struct Constants {
        static let titleFontSize: CGFloat = 15

        static let defaultTitle: LocalizedStringKey = "lang-default-custom-text-field-title-key"
        static let defaultPlaceholderText: LocalizedStringKey = "lang-default-custom-text-field-placeholder-key"

        static let defaultPlainTextAccessibilityId: String = "plain".getAccessibilityIdentifier(type: .accPlainTextField)
        static let defaultPlainTextAccessibilityLabelValue: LocalizedStringKey = "lang-default-custom-plain-text-field-accessibility-label-key"

        static let defaultSecureTextAccessibilityId: String = "secure".getAccessibilityIdentifier(type: .accSecureTextField)
        static let defaultSecureTextAccessibilityLabelValue: LocalizedStringKey = "lang-default-custom-secure-text-field-accessibility-label-key"

        static let defaultSeparatorLineAccessibilityId: String = "custom".getAccessibilityIdentifier(type: .accSeparatorLine)

        static let defaultErrorTextAccessibilityId: String = "custom".getAccessibilityIdentifier(type: .accErrorTextMessage)
        static let defaultErrorTextAccessibilityLabelValue: LocalizedStringKey = "lang-default-custom-text-field-error-text-key"

        static let visibleImageName: String = "eye.slash.fill"
        static let hiddenImageName: String = "eye.fill"
        static let toggleImageBottonPadding: CGFloat = 3
        static let toggleButtonHeight: CGFloat = 25
        static let defaultToggleButtonId: String = "toggle".getAccessibilityIdentifier(type: .accButton)
        static let defaultToggleImageVisibleId: String = "show".getAccessibilityIdentifier(type: .accImage)
        static let defaultToggleImageHiddenId: String = "hide".getAccessibilityIdentifier(type: .accImage)
        static let defaultToggleVisibleLabelValue: LocalizedStringKey = "lang-default-custom-text-field-toggle-visible-label-key"
        static let defaultToggleHiddenLabelValue: LocalizedStringKey = "lang-default-custom-text-field-toggle-hidden-label-key"
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
    var placeholderText: LocalizedStringKey?
    var separatorLineAccessibilityId: String?
    var errorMessage: LocalizedStringKey = ""
    var errorMessageAccessibilityId: String?
    var errorTextAccessibilityLabelValue: LocalizedStringKey?
    var isSecureText: Bool = false
    var textContentType: UITextContentType? = nil
    var keyboardType: UIKeyboardType = .default
    @Binding var isDisabled: Bool
    var onSubmit: () -> Void = { }

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
                        SecureField(placeholderText ?? Constants.defaultPlaceholderText, text: $value)
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
                            .accessibilityLabel(accessibilityLabelValue ?? Constants.defaultSecureTextAccessibilityLabelValue)
                            .accessibilityIdentifier(accessibilityId ?? Constants.defaultSecureTextAccessibilityId)
                        #if DEBUG
                            .simultaneousGesture(TapGesture().onEnded {
                                print("\(title ?? Constants.defaultTitle) pressed")
                            })
                        #endif
                    } else {
                        // Textfield content visible
                        TextField(placeholderText ?? Constants.defaultPlaceholderText, text: $value)
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
                            .accessibilityLabel(accessibilityLabelValue ?? Constants.defaultPlainTextAccessibilityLabelValue)
                            .accessibilityIdentifier(accessibilityId ?? Constants.defaultPlainTextAccessibilityId)
                        #if DEBUG
                            .simultaneousGesture(TapGesture().onEnded {
                                print("\(title ?? Constants.defaultTitle) pressed")
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
                                                     Constants.defaultToggleImageVisibleId :
                                                        Constants.defaultToggleImageHiddenId)

                            Image(systemName: "")
                        }
                    }
                    .foregroundStyle(Color.AppPalette.TextField.primary)
                    .disabled(isDisabled)
                    .padding(.bottom, Constants.toggleImageBottonPadding)
                    .accessibilityLabel(isHidden ?
                                        Constants.defaultToggleVisibleLabelValue :
                                            Constants.defaultToggleHiddenLabelValue)
                    .accessibilityIdentifier(Constants.defaultToggleButtonId)
                    .frame(height: Constants.toggleButtonHeight)
                }
            } else {
                TextField(placeholderText ?? Constants.defaultPlaceholderText, text: $value)
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
                    .accessibilityLabel(accessibilityLabelValue ?? Constants.defaultPlainTextAccessibilityLabelValue)
                    .accessibilityIdentifier(accessibilityId ?? Constants.defaultPlainTextAccessibilityId)
                #if DEBUG
                    .simultaneousGesture(TapGesture().onEnded {
                        print("\(title ?? Constants.defaultTitle) pressed")
                    })
                #endif
            }

            Rectangle()
                .fill(value == "" ?
                      Color.AppPalette.TextField.secondary :
                        Color.AppPalette.TextField.primary)
                .frame(height: 1)
                .accessibilityIdentifier(separatorLineAccessibilityId ?? Constants.defaultSeparatorLineAccessibilityId)

            Text(errorMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.AppPalette.TextField.error)
                .accessibilityIdentifier(errorMessageAccessibilityId ?? Constants.defaultErrorTextAccessibilityId)
                .accessibilityLabel(errorTextAccessibilityLabelValue ?? Constants.defaultErrorTextAccessibilityLabelValue)
        }
    }
}

#Preview {
    CustomTextField(value: .constant(""),
                    isDisabled: .constant(false))
}
