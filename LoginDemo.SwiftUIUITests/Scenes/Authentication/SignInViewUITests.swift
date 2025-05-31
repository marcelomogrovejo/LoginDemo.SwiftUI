//
//  SignInViewUITests.swift
//  LoginDemo.SwiftUIUITests
//
//  Created by Marcelo Mogrovejo on 26/5/2025.
//

// Source: https://blog.egesucu.com.tr/how-to-do-ui-tests-in-swiftui-5d16b5ade080

import XCTest
@testable import LoginDemo_SwiftUI

final class SignInViewUITests: XCTestCase {

    var sut: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        sut = XCUIApplication()
        sut.launch()
    }

    override func tearDownWithError() throws {
        sut.terminate()
        sut = nil
    }

    @MainActor
    func testSignInView_TitleDisplay() throws {
        // Arrange
        let titleId: String = "title".getAccessibilityIdentifier(type: AccessibilityIdentifierType.text)

        // Act
        let title = sut.staticTexts[titleId]

        // Assert
        /// Have to wait because of the splash screen has to finish loading and doing the animation.
        XCTAssertTrue(title.waitForExistence(timeout: 2),
                      "Title should be present but it is not")
    }

    @MainActor
    func testSignInView_EmailTextFieldDisplay() throws {
        // Arrange
        let emailTextFielId: String = "email".getAccessibilityIdentifier(type: AccessibilityIdentifierType.plainTextField)
        let emailSeparatorLineId: String = "email".getAccessibilityIdentifier(type: AccessibilityIdentifierType.separatorLine)
        let emailErrorMessageId: String = "email".getAccessibilityIdentifier(type: AccessibilityIdentifierType.errorTextMessage)

        // Act
        let emailTextField = sut.textFields[emailTextFielId]
        let separatorLine = sut.otherElements.element(matching: .any,
                                                      identifier: emailSeparatorLineId)
        let errorText = sut.staticTexts[emailErrorMessageId]

        // Assert

        // TODO: check if emailTextField is empty ?

        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2),
                      "Email text field should be present but it is not")
        XCTAssertTrue(separatorLine.waitForExistence(timeout: 2),
                      "Separator line should be present but it is not")
        XCTAssertFalse(errorText.waitForExistence(timeout: 2),
                       "Error text should NOT be present but it is not")
    }

    @MainActor
    func testSignInView_PasswordTextFieldDisplay() throws {
        // Arrange
        let passwordTextFielId: String = "password".getAccessibilityIdentifier(type: AccessibilityIdentifierType.secureField)
        let passwordSeparatorLineId: String = "password".getAccessibilityIdentifier(type: AccessibilityIdentifierType.separatorLine)
        let passwordErrorMessageId: String = "password".getAccessibilityIdentifier(type: AccessibilityIdentifierType.errorTextMessage)

        // Act
        let passwordTextField = sut.secureTextFields[passwordTextFielId]
        let separatorLine = sut.otherElements.element(matching: .any,
                                                      identifier: passwordSeparatorLineId)
        let errorText = sut.staticTexts[passwordErrorMessageId]

        // Assert

        // TODO: check if password secure field is empty ?

        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 2),
                      "Password text field should be present but it is not")
        XCTAssertTrue(separatorLine.waitForExistence(timeout: 2),
                      "Separator line should be present but it is not")
        XCTAssertFalse(errorText.waitForExistence(timeout: 2),
                       "Error text should NOT be present but it is not")
    }

    @MainActor
    func testSignInView_EyeButtonDisplay() throws {
        // Arrange
        let toggleButtonId = "toggle".getAccessibilityIdentifier(type: AccessibilityIdentifierType.button)

        // Act
        let eyeButton = sut.buttons[toggleButtonId]

        // Assert
        XCTAssertTrue(eyeButton.waitForExistence(timeout: 2),
                      "Eye button should be present but it is not")
    }

    @MainActor
    func testSignInView_SignInButtonDisplay() throws {
        // Arrange
        let signInButtonTitleId = "sign-in".getAccessibilityIdentifier(type: AccessibilityIdentifierType.buttonTitle)
        let signInButtonId = "sign-in".getAccessibilityIdentifier(type: AccessibilityIdentifierType.button)

        // Act
        let signInTitle = sut.staticTexts[signInButtonTitleId]
        let signInButton = sut.buttons[signInButtonId]

        // Assert
        XCTAssertTrue(signInTitle.waitForExistence(timeout: 2),
                      "Sign in title should be present but it is not")
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2),
                      "Sign in button should be present but it is not")
    }

    @MainActor
    func testSignInView_SignUpButtonDisplay() throws {
        // Arrange
        let signUpButtonId = "sign-up".getAccessibilityIdentifier(type: AccessibilityIdentifierType.button)
        // Act
        let signUpButton = sut.buttons[signUpButtonId]

        // Assert
        XCTAssert(signUpButton.waitForExistence(timeout: 2),
                  "Sign up button should be present but it is not")
    }

    @MainActor
    func testSignInView_ForgotPasswordButtonDisplay() throws {
        // Arrange
        let forgotPasswordButtonId = "forgot password?".getAccessibilityIdentifier(type: AccessibilityIdentifierType.button)

        // Act
        // TODO: Warning !
        // The special char '?' is being taking in account.
        // Id should be just words separated by '-' char
        let forgotPasswordButton = sut.buttons[forgotPasswordButtonId]

        // Assert
        XCTAssert(forgotPasswordButton.waitForExistence(timeout: 2),
                  "Forgot Password button should be present but it is not")
    }


//    @MainActor
//    func testLaunchPerformance() throws {
//        // This measures how long it takes to launch your application.
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
//    }
}
