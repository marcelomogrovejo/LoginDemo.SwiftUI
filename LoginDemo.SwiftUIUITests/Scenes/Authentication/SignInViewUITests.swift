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

        // Act
        let title = sut.staticTexts["title-text-id"]

        // Assert
        /// Have to wait because of the splash screen has to finish loading and doing the animation.
        XCTAssertTrue(title.waitForExistence(timeout: 2),
                      "Title should be present but it is not")
    }

    @MainActor
    func testSignInView_EmailTextFieldDisplay() throws {
        // Arrange

        // Act
        let emailTextField = sut.textFields["email-plain-text-field-id"]
        let separatorLine = sut.otherElements.element(matching: .any,
                                                      identifier: "email-separator-line-id")
        let errorText = sut.staticTexts["email-error-text-id"]

        // Assert

        // TODO: check if emailTextField is empty ?

        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2),
                      "Email text field should be present but it is not")
        XCTAssertTrue(separatorLine.waitForExistence(timeout: 2),
                      "Separator line should be present but it is not")
        XCTAssertFalse(errorText.waitForExistence(timeout: 2),
                       "Error text should NOT be present but it is not")
    }

    func testSignInView_PasswordTextFieldDisplay() throws {
        // Arrange

        // Act
        let passwordTextField = sut.secureTextFields["password-secure-text-field-id"]
        let separatorLine = sut.otherElements.element(matching: .any,
                                                      identifier: "password-separator-line-id")
        let errorText = sut.staticTexts["password-error-text-id"]

        // Assert

        // TODO: check if password secure field is empty ?

        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 2),
                      "Password text field should be present but it is not")
        XCTAssertTrue(separatorLine.waitForExistence(timeout: 2),
                      "Separator line should be present but it is not")
        XCTAssertFalse(errorText.waitForExistence(timeout: 2),
                       "Error text should NOT be present but it is not")
    }

    func testSignInView_EyeButtonDisplay() throws {
        // Arrange

        // Act
        let eyeButton = sut.buttons["eye-button-id"]

        // Assert
        XCTAssertTrue(eyeButton.waitForExistence(timeout: 2),
                      "Eye button should be present but it is not")
    }

    func testSignInView_SignInButtonDisplay() throws {
        // Arrange

        // Act
        let signInTitle = sut.staticTexts["sign-in-button-text-id"]
        let signInButton = sut.buttons["sign-in-button-id"]

        // Assert
        XCTAssertTrue(signInTitle.waitForExistence(timeout: 2),
                      "Sign in title should be present but it is not")
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2),
                      "Sign in button should be present but it is not")
    }

    func testSignInView_SignUpButtonDisplay() throws {
        // Arrange

        // Act
        let signUpButton = sut.buttons["sign-up-button-id"]

        // Assert
        XCTAssert(signUpButton.waitForExistence(timeout: 2),
                  "Sign up button should be present but it is not")
    }

    func testSignInView_ForgotPasswordButtonDisplay() throws {
        // Arrange

        // Act
        // TODO: Warning !
        // The special char '?' is being taking in account.
        // Id should be just words separated by '-' char
        let forgotPasswordButton = sut.buttons["forgot-password?-button-id"]

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
