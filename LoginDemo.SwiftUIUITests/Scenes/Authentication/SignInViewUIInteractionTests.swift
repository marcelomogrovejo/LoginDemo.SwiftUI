//
//  SignInViewUIInteractionTests.swift
//  LoginDemo.SwiftUIUITests
//
//  Created by Marcelo Mogrovejo on 27/5/2025.
//

// Source: https://masilotti.com/ui-testing-cheat-sheet/

import XCTest
import SwiftUI
import CommonAccessibility

final class SignInViewUIInteractionTests: XCTestCase {

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
    func testSignInView_SignInButtonEnabledWhenFormIsFilledCorrectly() throws {
        // Arrange
        let signInButtonId = "sign-in".getAccessibilityIdentifier(type: .accButton)
        let emailTextFieldId = "username".getAccessibilityIdentifier(type: .accPlainTextField)
        let passwordTextFieldId = "password".getAccessibilityIdentifier(type: .accSecureTextField)
        let validEmail = "test@example.com"
        let nextButtonTitle = "next"
        let validPassword = "secureText123"

        // Act
        let signInButton = sut.buttons[signInButtonId]

        // Assert the circular button is initialy present and disabled
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2),
                      "Sign in button should be present but it is not")
        XCTAssertFalse(signInButton.isEnabled,
                       "Sign in button should be disabled but it is enabled")

        // Act
        let emailTextField = sut.textFields[emailTextFieldId]

        // Assert the text field is enabled and empty
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2),
                      "Email text field should be present but it is not")
        XCTAssertTrue(emailTextField.isEnabled,
                      "Email text field should be enabled but it is not")
        XCTAssertEqual(emailTextField.value as! String, "",
                       "Email text field should be empty but it is not")

        // Act
        emailTextField.tap()
        emailTextField.typeText(validEmail)

        let passwordTextField = sut.secureTextFields[passwordTextFieldId]

        // Assert the secure text is enabled and empty
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 2),
                      "Password text field should be present but it is not")
        XCTAssertTrue(passwordTextField.isEnabled,
                      "Password text field should be enabled but it is not")
        XCTAssertEqual(passwordTextField.value as! String, "",
                       "Password text field should be empty but it is not")

        // Act
        // TODO: Warning !
        // Check when localization is present if this is still working when the keyboard is in nother language
        let nextKey = sut.keyboards.buttons[nextButtonTitle]
        XCTAssertTrue(nextKey.exists && nextKey.isHittable,
                      "Next key should be visible and hittable on username keyboard")
        nextKey.tap()

        passwordTextField.typeText(validPassword)

        // Assert the circular button is enabled after filling the form correctly
        XCTAssertTrue(signInButton.isEnabled,
                       "Sign in button should be enabled but it is enabled")
    }

    // TODO: check error when invalid username/email and button disabled
    // Note: error message is not working in this app, looks like the validation is only performed when the button is tapped.
    // So, the component is able to show an error message above the value, but not in this implementation

    // TODO: check error when invalid password and button disabled
    // Note: error message is not working in this app, looks like the validation is only performed when the button is tapped
    // So, the component is able to show an error message above the value, but not in this implementation

    @MainActor
    func testSignInView_PasswordEyeButtonToggle() throws {
        // Arrange
        let eyeButtonId = "toggle".getAccessibilityIdentifier(type: .accButton)
        let eyeButton = sut.buttons[eyeButtonId]
        let eyeSlashButtonImageId = "show".getAccessibilityIdentifier(type: .accImage)
        let eyeSlashButtonImage = sut.images[eyeSlashButtonImageId]
        let eyeButtonImageId = "hide".getAccessibilityIdentifier(type: .accImage)
        let eyeButtonImage = sut.images[eyeButtonImageId]

        // Assert: initial state
        XCTAssertTrue(eyeButton.waitForExistence(timeout: 2),
                      "Eye button should be present but it is not")
        XCTAssertTrue(eyeButton.isHittable,
                      "Eye button should be enabled but it is not")

        XCTAssertTrue(eyeSlashButtonImage.waitForExistence(timeout: 5),
                      "Eye slash button image should be present but it is not")
        XCTAssertTrue(eyeSlashButtonImage.isHittable,
                      "Eye slash button image should be enabled but it is not (password hidden)")
        XCTAssertFalse(eyeButtonImage.exists,
                      "Eye button image should not be present but it is")
        XCTAssertFalse(eyeButtonImage.isHittable,
                       "Eye button image should not be hittable initially (password hidden)")

        // Act
        eyeButton.tap()

        // Assert: state changes -> Password visible
        XCTAssertFalse(eyeSlashButtonImage.waitForExistence(timeout: 5),
                      "Eye slash button image should not be present but it is")
        XCTAssertFalse(eyeSlashButtonImage.isHittable,
                      "Eye slash button image should not be enabled but it is (password visible)")
        XCTAssertTrue(eyeButtonImage.exists,
                      "Eye button image should be present but it is not")
        XCTAssertTrue(eyeButtonImage.isHittable,
                      "Eye button image should be hittable but it is not (password visible)")

        // Act
        eyeButton.tap()

        // Assert: state changes -> Password hidden
        XCTAssertTrue(eyeSlashButtonImage.waitForExistence(timeout: 5),
                      "Eye slash button image should be present but it is not")
        XCTAssertTrue(eyeSlashButtonImage.isHittable,
                      "Eye slash button image should be enabled but it is not (password hidden)")
        XCTAssertFalse(eyeButtonImage.exists,
                      "Eye button image should not be present but it is")
        XCTAssertFalse(eyeButtonImage.isHittable,
                      "Eye button image should not be hittable but it is (password hidden)")

    }

    @MainActor
    func testSignInView_AlertShouldBePresentWhenInvalidCredentials() throws {
        // Arrange
        let invalidEmail = "invalid.test@test.com"
        let invalidPassword = "invalidPassword123"
        let signInButtonId = "sign-in".getAccessibilityIdentifier(type: .accButton)
        let signInButton = sut.buttons[signInButtonId]
        let emailTextFieldId = "username".getAccessibilityIdentifier(type: .accPlainTextField)
        let emailTextField = sut.textFields[emailTextFieldId]
        let nextButtonTitle = "next"
        let passwordTextFieldId = "password".getAccessibilityIdentifier(type: .accSecureTextField)
        let passwordTextField = sut.secureTextFields[passwordTextFieldId]
        let returnButtonTitle = "return"

        // Act

        // Assert the circular button is initialy present and disabled
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2),
                      "Sign in button should be present but it is not")
        // Assert the text field is enabled and empty
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2),
                      "Email text field should be present but it is not")
        XCTAssertTrue(emailTextField.isHittable,
                      "Email text field should be enabled but it is not")
        // Assert the secure text is enabled and empty
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 2),
                      "Password text field should be present but it is not")
        XCTAssertTrue(passwordTextField.isHittable,
                      "Password text field should be enabled but it is not")

        // Act
        emailTextField.tap()
        emailTextField.typeText(invalidEmail)

        // Act
        // TODO: Warning !
        // Check when localization is present if this is still working when the keyboard is in nother language
        let nextKey = sut.keyboards.buttons[nextButtonTitle]
        XCTAssertTrue(nextKey.exists && nextKey.isHittable,
                      "Next key should be visible and hittable on username keyboard")
        nextKey.tap()

        passwordTextField.typeText(invalidPassword)

        // Assert the circular button is enabled after filling the form correctly
        XCTAssertTrue(signInButton.isEnabled,
                       "Sign in button should be disabled but it is enabled")

        // Act
        // TODO: Warning !
        // Check when localization is present if this is still working when the keyboard is in nother language
        let returnKey = sut.keyboards.buttons[returnButtonTitle]
        XCTAssertTrue(returnKey.waitForExistence(timeout: 2) && returnKey.isHittable,
                      "Return key should be visible and hittable on password keyboard")

        returnKey.tap()

        // TODO: check the loading state of the sign in button
        // TODO: check the disabled state of the email, password text fields and eye, sign up and forgot password buttons while loading

        // Assert
        // TODO: Alert accessibilityId doesn't work.
        let errorAlert = sut.alerts.element
        XCTAssertTrue(errorAlert.waitForExistence(timeout: 2), "Error alert should be present but it is not")

        // MARK: Warning !
        // en_EN was set as the default testing language.
        XCTAssertEqual(errorAlert.label, "Error",
                       "An error alert should be present but it is not")
    }

    @MainActor
    func testSignInView_NavigationShouldBePerformedWhenValidCredentials() throws {
        // Arrange
        let validEmail = "valid.test@test.com"
        let validPassword = "validPassword123"
        let signInButtonId = "sign-in".getAccessibilityIdentifier(type: .accButton)
        let signInButton = sut.buttons[signInButtonId]
        let emailTextFieldId = "username".getAccessibilityIdentifier(type: .accPlainTextField)
        let emailTextField = sut.textFields[emailTextFieldId]
        let nextButtonTitle = "next"
        let passwordTextFieldId = "password".getAccessibilityIdentifier(type: .accSecureTextField)
        let passwordTextField = sut.secureTextFields[passwordTextFieldId]
        let returnButtonTitle = "return"

        // Act

        // Assert the circular button is initialy present and disabled
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2),
                      "Sign in button should be present but it is not")
        // Assert the text field is enabled and empty
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2),
                      "Email text field should be present but it is not")
        XCTAssertTrue(emailTextField.isHittable,
                      "Email text field should be enabled but it is not")
        // Assert the secure text is enabled and empty
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 2),
                      "Password text field should be present but it is not")
        XCTAssertTrue(passwordTextField.isHittable,
                      "Password text field should be enabled but it is not")

        // Act
        emailTextField.tap()
        emailTextField.typeText(validEmail)

        // Act
        // TODO: Warning !
        // Check when localization is present if this is still working when the keyboard is in nother language
        let nextKey = sut.keyboards.buttons[nextButtonTitle]
        XCTAssertTrue(nextKey.exists && nextKey.isHittable,
                      "Next key should be visible and hittable on username keyboard")
        nextKey.tap()

        passwordTextField.typeText(validPassword)

        // Assert the circular button is enabled after filling the form correctly
        XCTAssertTrue(signInButton.isEnabled,
                       "Sign in button should be disabled but it is enabled")

        // Act
        // TODO: Warning !
        // Check when localization is present if this is still working when the keyboard is in nother language
        let returnKey = sut.keyboards.buttons[returnButtonTitle]
        XCTAssertTrue(returnKey.waitForExistence(timeout: 2) && returnKey.isHittable,
                      "Return key should be visible and hittable on password keyboard")
        returnKey.tap()

        // TODO: check navigation blocked meanwhile loading
        // 1. check the loading state on the sign in button
        // 2. check the disabled state of the email text field
        // 3. check the disabled state of the password text fields
        // 4. check the disabled state of the eye button
        // 5. check the disabled state of the sign up button
        // 6. check the disabled state of the forgot password buttons

        // Assert
        XCTFail("Figure out how to assert the navigation to a new view")
    }

    // TODO: check navigation when sign up button is tapped
    // TODO: check navigation when forgot password button is tapped

//    func testLaunchPerformance() throws {
//        // This measures how long it takes to launch your application.
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
//    }
}
