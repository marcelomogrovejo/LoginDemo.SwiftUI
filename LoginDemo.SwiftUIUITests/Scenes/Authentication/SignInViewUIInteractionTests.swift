//
//  SignInViewUIInteractionTests.swift
//  LoginDemo.SwiftUIUITests
//
//  Created by Marcelo Mogrovejo on 27/5/2025.
//

// Source: https://masilotti.com/ui-testing-cheat-sheet/

import XCTest

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

        // Act
        let signInButton = sut.buttons["sign-in-button-id"]

        // Assert the circular button is initialy present and disabled
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2),
                      "Sign in button should be present but it is not")
        XCTAssertFalse(signInButton.isEnabled,
                       "Sign in button should be disabled but it is enabled")

        // Act
        let emailTextField = sut.textFields["email-plain-text-field-id"]

        // Assert the text field is enabled and empty
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2),
                      "Email text field should be present but it is not")
        XCTAssertTrue(emailTextField.isEnabled,
                      "Email text field should be enabled but it is not")
        XCTAssertEqual(emailTextField.value as! String, "",
                       "Email text field should be empty but it is not")

        // Act
        emailTextField.tap()
        emailTextField.typeText("test@test.com")

        let passwordTextField = sut.secureTextFields["password-secure-text-field-id"]

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
        let nextKey = sut.keyboards.buttons["next"]
        XCTAssertTrue(nextKey.exists && nextKey.isHittable,
                      "Next key should be visible and hittable on username keyboard")
        nextKey.tap()

        passwordTextField.typeText("secureText123")

        // Assert the circular button is enabled after filling the form correctly
        XCTAssertTrue(signInButton.isEnabled,
                       "Sign in button should be disabled but it is enabled")
    }

    // TODO: check error when invalid username/email and button disabled
    // Note: error message is not working in this app, looks like the validation is only performed when the button is tapped.
    // So, the component is able to show an error message above the value, but not in this implementation

    // TODO: check error when invalid password and button disabled
    // Note: error message is not working in this app, looks like the validation is only performed when the button is tapped
    // So, the component is able to show an error message above the value, but not in this implementation

    // TODO: check alert error when invalid credentials
    @MainActor
    func testSignInView_AlertShouldBePresentWhenInvalidCredentials() throws {
        // Arrange
        let signInButton = sut.buttons["sign-in-button-id"]
        let emailTextField = sut.textFields["email-plain-text-field-id"]
        let passwordTextField = sut.secureTextFields["password-secure-text-field-id"]

        // Act

        // Assert the circular button is initialy present and disabled
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2),
                      "Sign in button should be present but it is not")
        // Assert the text field is enabled and empty
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 2),
                      "Email text field should be present but it is not")
        XCTAssertTrue(emailTextField.isHittable,
                      "Email text field should be enabled but it is not")

        // Act
        emailTextField.tap()
        emailTextField.typeText("test@test.com")

        // Assert the secure text is enabled and empty
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 2),
                      "Password text field should be present but it is not")
        XCTAssertTrue(passwordTextField.isHittable,
                      "Password text field should be enabled but it is not")

        // Act
        // TODO: Warning !
        // Check when localization is present if this is still working when the keyboard is in nother language
        let nextKey = sut.keyboards.buttons["next"]
        XCTAssertTrue(nextKey.exists && nextKey.isHittable,
                      "Next key should be visible and hittable on username keyboard")
        nextKey.tap()

        passwordTextField.typeText("secureText123")

        // Assert the circular button is enabled after filling the form correctly
        XCTAssertTrue(signInButton.isEnabled,
                       "Sign in button should be disabled but it is enabled")

        // Act
        // TODO: Warning !
        // Check when localization is present if this is still working when the keyboard is in nother language
        let returnKey = sut.keyboards.buttons["return"]
        XCTAssertTrue(returnKey.waitForExistence(timeout: 2) && returnKey.isHittable,
                      "Return key should be visible and hittable on password keyboard")
        returnKey.tap()

        // Assert
        // TODO: Warning !
        // Check when localization is present if this is still working when the language changes
        XCTAssertEqual(sut.alerts.element.label, "Error",
                       "An error alert should be present but it is not")
    }

    // TODO: check navigation when valid credentials
    // TODO: check navigation when sign up button is tapped
    // TODO: check navigation when forgot password button is tapped
    // TODO: check password eye button toggle
    
//    func testLaunchPerformance() throws {
//        // This measures how long it takes to launch your application.
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
//    }
}
