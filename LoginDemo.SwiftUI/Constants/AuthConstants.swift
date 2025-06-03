//
//  AuthConstants.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 22/5/2025.
//

import Foundation
import SwiftUICore

struct AuthConstants {

    struct SignInView {
        static let screenHeight: CGFloat = 750

        static let mainTitle: LocalizedStringKey = "lang-sign-in-view-title-key"
        static let usernameTitle = LocalizedStringKey("lang-sign-in-view-username-title-key")
        static let usernameAccessibilityId: String = "username"
        static let usernameAccessibilityLabel = LocalizedStringKey("username".getAccessibilityLabel(viewType: .signIn))
        static let usernamePlaceholder: LocalizedStringKey = "lang-sign-in-view-username-placeholder-key"
        static let usernameAccessibilityErrorLabel = LocalizedStringKey("username-error".getAccessibilityLabel(viewType: .signIn))
        static let passwordTitle: LocalizedStringKey = "lang-sign-in-view-password-title-key"
        static let passwordAccessibilityId: String = "password"
        static let passwordAccesiibilityLabel = LocalizedStringKey("password".getAccessibilityLabel(viewType: .signIn))
        static let passwordPlaceholder: LocalizedStringKey = "lang-sign-in-view-password-placeholder-key"
        static let passwordAccessibilityErrorLabel = LocalizedStringKey("password-error".getAccessibilityLabel(viewType: .signIn))

        static let spaceBetweenTextFields: CGFloat = 20
        static let formPadding: CGFloat = 40

        static let submitTitle: LocalizedStringKey = "lang-sign-in-view-submit-title-key"
        static let submitTitleAccessibilityId: String = "sign-in".getAccessibilityIdentifier(type: .buttonTitle)
        static let submitFontSize: CGFloat = 24

        static let signUpButtonVerticalPadding: CGFloat = 30
        static let signUpButtonTitle: LocalizedStringKey = "lang-sign-in-view-sign-up-button-title-key"
        static let signUpButtonAccessibilityId: String = "sign-up".getAccessibilityIdentifier(type: .button)
        static let signUpButtonAccessibilityLabel = LocalizedStringKey("Sign up button".getAccessibilityLabel(viewType: .signIn))

        static let forgotPasswordButtonTitle: LocalizedStringKey = "lang-sign-in-view-forgot-password-button-title-key"
        static let forgotPasswordButtonAccessibilityId: String = "forgot-password".getAccessibilityIdentifier(type: .button)
        static let forgotPasswordButtonAccessibilityLabel = LocalizedStringKey("Forgot password button".getAccessibilityLabel(viewType: .signIn))

        static let buttonSectionPadding: CGFloat = 40

        static let viewPadding: CGFloat = -130

        static let errorAlertTitle: String = "Error"
        static let errorAlertButtonTitle: String = "Got it!"
        static let errorAlertMessage: String = "Something went wrong"

        static let circularButtonTitle: String = "Sign In"
        static let signInButtonAccessibilityId: String = "sign-in".getAccessibilityIdentifier(type: .button)
        static let signInButtonAccessibilityLabel = LocalizedStringKey("Sign In button".getAccessibilityLabel(viewType: .signIn))
        static let signInButtonLoadingAccessibilityLabel = LocalizedStringKey("Loading indicator".getAccessibilityLabel(viewType: .text))
        static let signInButtonLoadingAccessibilityValue = LocalizedStringKey("Loading message".getAccessibilityLabel(viewType: .text))
    }
}
