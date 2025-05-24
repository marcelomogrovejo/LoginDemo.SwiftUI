//
//  SignInViewTests.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 19/5/2025.
//

import XCTest
@testable import LoginDemo_SwiftUI
import ViewInspector
import SwiftUI
import Combine

final class SignInViewTests: XCTestCase {

    // Ids
    struct Constants {
        static let emailTextFieldId: String = "email-plain-text-field-id"
        static let passwordSecureTextId: String = "password-secure-text-field-id"
        static let eyeButtonId: String = "eye-button-id"
        static let eyeImageId: String = "eye-image-id"
        static let signInButtonId: String = "sign-in-button-id"
        static let signUpButtonId: String = "sign-up-button-id"
    }

    var settings: AppSettings!
    var sut: AnyView!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        settings = AppSettings()

        cancellables = []

        // TODO: Warning !!
        // This should simulate a ContentView GroupWindow to fix the initialization issue.
        // It is not working but looks like the fix is on this way.
        sut = AnyView(ContentViewMock {
            SignInView().environmentObject(settings)
        })
    }

    override func tearDownWithError() throws {
        settings = nil
        sut = nil
        cancellables?.forEach{ $0.cancel() }
        cancellables?.removeAll()
    }

    func testHeaderView_ShouldBePresent() throws {
        // Arrange

        // Act
        let signInView = try sut.inspect().find(ViewType.ScrollView.self)
        /// vStack(1) instead of (0) because some way, within the zStack, element 0 is Color() and element 1 is the VStack()
        let vStack = try signInView.zStack().vStack(1)
        let headerView = try vStack.find(HeaderView.self).actualView()
        let text = headerView.title

        // Assert
        XCTAssertEqual(text, "Welcome\n Back", "Header text should be 'Welcome\n Back'")
    }

    func testEmailCustomTextField_ShouldBePresentAndEmpty() throws {
        // Arrange

        // Act
        let signInView = try sut.inspect().find(ViewType.ScrollView.self)
        /// vStack(1) instead of (0) because some way, within the zStack, element 0 is Color() and element 1 is the VStack()
        let vStack = try signInView.zStack().vStack(1)
        /// Found the first CustomTextField, so to find Password, it doesn't work
        let emailTextField = try vStack.find(CustomTextField.self).actualView()
        let text = emailTextField.title
        let textField = try emailTextField.body.inspect().find(ViewType.TextField.self)

        // TODO: -
        // I couldn't find a way to check the textfield is empty...

        // Assert
        XCTAssertEqual(text, "Email", "Email textfield title should be 'Email'")
        XCTAssertFalse(textField.isDisabled(), "Email textfield should be enabled")
    }

    func testPasswordCustomTextField_ShouldBePresentSecureAndEmpty() throws {
        // Arrange

        // Act
        /// Implementing ViewInspector way of traversing the hierarchy
        let inspectedView = try sut.inspect()
        let mainView = try inspectedView.anyView(0)
        /// Needs to pass the type of the generic 'ViewModel', in this case can be my view model mock
        let signInView = try mainView.find(SignInView<SignInViewModelMock>.self)
        let scrollView = try signInView.scrollView(0)
        let zStack = try scrollView.zStack()
        let mainContentVStack = try zStack.vStack(1)
        let textFieldContainerVStack = try mainContentVStack.vStack(1)
        let passwordCustomTextField = try textFieldContainerVStack.view(CustomTextField.self, 2).actualView()

        // TODO: -
        // I couldn't find a way to check the textfield is empty...

        // Assert
        XCTAssertEqual(passwordCustomTextField.title, "Password", "Password textfield title should be 'Password'")
        XCTAssertTrue(passwordCustomTextField.isSecureText, "Password textfield should be SecureText")
    }

    func testPasswordCustomTextFieldInteraction_ShouldBeTypable() throws {
        // Arrange

        // TODO: mock the viewModel -> https://stackoverflow.com/questions/68565266/mocking-view-model-in-swiftui-with-combine
        let viewModelMock = SignInViewModel()
        let passwordText: String = "123456789"

        // Act
        sut = AnyView(ContentViewMock {
            SignInView(viewModel: viewModelMock).environmentObject(settings)
        })

        /// Implementing ViewInspector way of traversing the hierarchy
        let inspectedView = try sut.inspect()
        let passwordCustomTextField = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.passwordSecureTextId)
            .first
        guard let passwordCustomTextField = passwordCustomTextField else {
            XCTFail("Could not find password custom text field")
            return
        }
        try passwordCustomTextField.secureField().setInput(passwordText)

        // Assert
        XCTAssertEqual(viewModelMock.password, passwordText)
    }

    func testEyeButton_ShouldBePresent() throws {
        // Arrange

        // Act
        sut = AnyView(ContentViewMock {
            SignInView().environmentObject(settings)
        })

        /// Implementing ViewInspector way of traversing the hierarchy
        let inspectedView = try sut.inspect()
        let eyeButton = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.eyeButtonId)
            .first
        guard let eyeButton = eyeButton else {
            XCTFail("Could not find eye button")
            return
        }

        // Assert
        XCTAssertFalse(eyeButton.isHidden(), "Eye button should be visible")
        XCTAssertFalse(eyeButton.isDisabled(), "Eye button should be enabled")
    }

// TODO: eye button toggle to change SecureField by TextField
//    func testEyeButtonInteraction_ShouldToggleToPlainTextField() throws {
//        // Arrange
//
//        // Act
//        sut = AnyView(ContentViewMock {
//            SignInView().environmentObject(settings)
//        })
//
//        /// Implementing ViewInspector way of traversing the hierarchy
//        let inspectedView = try sut.inspect()
//        let eyeButton = try inspectedView
//            .find(ViewType.Button.self, containing: Constants.eyeButtonId)
//            .first
//        guard let eyeButton = eyeButton else {
//            XCTFail("Could not find eye button")
//            return
//        }
//
//        let eyeImage = try eyeButton
//            .find(ViewType.Image.self, containing: Constants.eyeImageId)
//            .first
//        guard let eyeImage = eyeImage else {
//            XCTFail("Could not find eye image")
//            return
//        }
//        
//        XCTAssertEqual(try eyeImage.systemImageName(), "eye")
//
//
////        _ = try eyeButton.button().tap()
////
////        let eyeImage = try inspectedView
////            .find(viewWithAccessibilityIdentifier: Constants.eyeImageId)
////            .first
////        guard let eyeImage = eyeImage else {
////            XCTFail("Could not find eye image")
////            return
////        }
////        print(eyeImage)
//
////        XCTAssertEqual(try eyeImage.systemImageName(), "eye.fill")
//
//        // Assert
////        XCTAssertFalse(eyeButton.isHidden(), "Eye button should be visible")
////        XCTAssertFalse(eyeButton.isDisabled(), "Eye button should be enabled")
//    }

// TODO: error messajes above Email and Password TextFields

    func testSubmitButtonInteraction_ShouldBeDisabled() throws {
        // Arrange
        let inspectedView = try sut.inspect()
        let signInButton = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.signInButtonId).first
        guard let signInButton = signInButton else {
            XCTFail("Could not find 'Sign In' button")
            return
        }

        // Act
        let button = try signInButton.button()

        // Assert
        XCTAssertTrue(button.isDisabled(), "Button should be disabled initially")
    }

    @MainActor
    func testSubmitButtonInteraction_ShouldBecomesEnabledAndAuthenticates() async throws {
        // Arrange
        let testEmailValue: String = "test@test.com"
        let testPasswordValue: String = "securePass123"

        let mockViewModel = SignInViewModelMock()
        /// To authenticate successfully
        mockViewModel.validEmail = testEmailValue
        mockViewModel.validPassword = testPasswordValue

        sut = AnyView(ContentViewMock {
            SignInView(viewModel: mockViewModel).environmentObject(settings)
        })

        let inspectedView = try sut.inspect()
        let signInButton = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.signInButtonId)
            .first
        guard let signInButton = signInButton else {
            XCTFail("Could not find 'Sign In' button")
            return
        }
        let button = try signInButton.button()

        /// Initial pre-conditions:
        /// 1. Disable Sign in button
        XCTAssertTrue(button.isDisabled(), "Pre-condition: 'Sign In' button should be disabled initially")
        /// 2. Invalid form
        XCTAssertFalse(mockViewModel.isFormValid, "Pre-condition: Form should be invalid initially")

        // Act
        let emailCustomTextField = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.emailTextFieldId)
            .first
        guard let emailCustomTextField = emailCustomTextField else {
            XCTFail("Could not find email custom text field")
            return
        }
        try emailCustomTextField.textField().setInput(testEmailValue)
        let emailFilledValue = try emailCustomTextField.textField().input()
        print("DEBUG: emailFilledValue: \(emailFilledValue)")

        let passwordCustomTextField = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.passwordSecureTextId)
            .first
        guard let passwordCustomTextField = passwordCustomTextField else {
            XCTFail("Could not find password custom text field")
            return
        }
        try passwordCustomTextField.secureField().setInput(testPasswordValue)
        let passwordFilledValue = try passwordCustomTextField.secureField().input()
        print("DEBUG: passwordFilledValue: \(passwordFilledValue)")

        let validateFormExpectation = XCTestExpectation(description: "Form becomes valid expectation")
        mockViewModel.$isFormValid
            /// To make sink ignores the initial false value that isFormValid will have when MockSignInViewModel
            /// is first instantiated. It only reacts to subsequent changes.
            .dropFirst()
            .sink(receiveCompletion: { completion in },
                  receiveValue: { isValid in
                if isValid {
                    validateFormExpectation.fulfill()
                }
            })
            .store(in: &cancellables)
        await fulfillment(of: [validateFormExpectation], timeout: 0.5)

        /// Search the button again to get the new enabled state
        let signInEnabledButton = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.signInButtonId)
            .first
        guard let signInEnabledButton = signInEnabledButton else {
            XCTFail("Could not find 'Sign In' button")
            return
        }
        let enabledButton = try signInEnabledButton.button()

        // Assert
        XCTAssertTrue(mockViewModel.isFormValid, "Post-input: Form should be valid")
        XCTAssertFalse(enabledButton.isDisabled(), "Post-input: 'Sign In' button should be enabled")

        // Act
        XCTAssertFalse(mockViewModel.authenticateUserCalled, "Pre-tap: authenticateUser should not have been called yet")
        XCTAssertFalse(mockViewModel.isLoading, "Pre-tap: SignInViewModelMock should not be loading")

        _ = try enabledButton.tap()

        let authenticationExpectation = XCTestExpectation(description: "Authentication completes expectation")
        mockViewModel.$isLoading
            /// to make sink ignores the initial false value that isLoading will have when MockSignInViewModel
            /// is first instantiated. It only reacts to subsequent changes.
            .dropFirst()
            .sink(receiveCompletion: { completion in },
                  receiveValue: { isLoading in
                if !isLoading {
                    authenticationExpectation.fulfill()
                }
            })
            .store(in: &cancellables)
        await fulfillment(of: [authenticationExpectation], timeout: 1.0)

        // Assert
        XCTAssertTrue(mockViewModel.authenticateUserCalled, "authenticateUser() should have been called after button tap")
        XCTAssertEqual(mockViewModel.numberOfTimesAuthenticateUserCalled, 1, "authenticateUser() should have been called only once")
        XCTAssertFalse(mockViewModel.isLoading, "SignInViewModelMock should not be loading after authentication completion")
        XCTAssertNil(mockViewModel.errorMessage, "No error message expected on successful mock login")
        XCTAssertFalse(mockViewModel.hasError, "hasError should be false on successful mock login")

        // TODO: maybe an extra assertion can be checking AppSettings.isLoggedIn true
    }

    @MainActor
    func testSubmitButtonInteraction_ShouldBecomesEnabledAndNotAuthenticate() async throws {
        // Arrange
        let testEmailValue: String = "test@test.com"
        let testPasswordValue: String = "securePass123"

        let mockViewModel = SignInViewModelMock()
        /// To fail on authentication
        mockViewModel.validEmail = testEmailValue
        mockViewModel.validPassword = "secure123"

        sut = AnyView(ContentViewMock {
            SignInView(viewModel: mockViewModel).environmentObject(settings)
        })

        let inspectedView = try sut.inspect()
        let signInButton = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.signInButtonId)
            .first
        guard let signInButton = signInButton else {
            XCTFail("Could not find 'Sign In' button")
            return
        }
        let button = try signInButton.button()

        /// Initial pre-conditions:
        /// 1. Disable Sign in button
        XCTAssertTrue(button.isDisabled(), "Pre-condition: 'Sign In' button should be disabled initially")
        /// 2. Invalid form
        XCTAssertFalse(mockViewModel.isFormValid, "Pre-condition: Form should be invalid initially")

        // Act
        let emailCustomTextField = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.emailTextFieldId)
            .first
        guard let emailCustomTextField = emailCustomTextField else {
            XCTFail("Could not find email custom text field")
            return
        }
        try emailCustomTextField.textField().setInput(testEmailValue)
        let emailFilledValue = try emailCustomTextField.textField().input()
        print("DEBUG: emailFilledValue: \(emailFilledValue)")

        let passwordCustomTextField = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.passwordSecureTextId)
            .first
        guard let passwordCustomTextField = passwordCustomTextField else {
            XCTFail("Could not find password custom text field")
            return
        }
        try passwordCustomTextField.secureField().setInput(testPasswordValue)
        let passwordFilledValue = try passwordCustomTextField.secureField().input()
        print("DEBUG: passwordFilledValue: \(passwordFilledValue)")

        let validateFormExpectation = XCTestExpectation(description: "Form becomes valid expectation")
        mockViewModel.$isFormValid
            /// To make sink ignores the initial false value that isFormValid will have when MockSignInViewModel
            /// is first instantiated. It only reacts to subsequent changes.
            .dropFirst()
            .sink(receiveCompletion: { completion in },
                  receiveValue: { isValid in
                if isValid {
                    validateFormExpectation.fulfill()
                }
            })
            .store(in: &cancellables)
        await fulfillment(of: [validateFormExpectation], timeout: 0.5)

        /// Search the button again to get the new enabled state
        let signInEnabledButton = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.signInButtonId)
            .first
        guard let signInEnabledButton = signInEnabledButton else {
            XCTFail("Could not find 'Sign In' button")
            return
        }
        let enabledButton = try signInEnabledButton.button()

        // Assert
        XCTAssertTrue(mockViewModel.isFormValid, "Post-input: Form should be valid")
        XCTAssertFalse(enabledButton.isDisabled(), "Post-input: 'Sign In' button should be enabled")

        // Act
        XCTAssertFalse(mockViewModel.authenticateUserCalled, "Pre-tap: authenticateUser should not have been called yet")
        XCTAssertFalse(mockViewModel.isLoading, "Pre-tap: SignInViewModelMock should not be loading")

        _ = try enabledButton.tap()

        let authenticationExpectation = XCTestExpectation(description: "Authentication completes expectation")
        mockViewModel.$isLoading
            /// to make sink ignores the initial false value that isLoading will have when MockSignInViewModel
            /// is first instantiated. It only reacts to subsequent changes.
            .dropFirst()
            .sink(receiveCompletion: { completion in },
                  receiveValue: { isLoading in
                if !isLoading {
                    authenticationExpectation.fulfill()
                }
            })
            .store(in: &cancellables)
        await fulfillment(of: [authenticationExpectation], timeout: 1.0)

        // Assert
        XCTAssertTrue(mockViewModel.authenticateUserCalled, "authenticateUser() should have been called after button tap")
        XCTAssertEqual(mockViewModel.numberOfTimesAuthenticateUserCalled, 1, "authenticateUser() should have been called only once")
        XCTAssertFalse(mockViewModel.isLoading, "SignInViewModelMock should not be loading after authentication completion")
        XCTAssertNotNil(mockViewModel.errorMessage, "Error message expected on failure mock login")
        XCTAssertTrue(mockViewModel.hasError, "hasError should be true on failure mock login")
    }

    func testSignUpButtonInteraction_ShouldBeTappable() throws {
        // Arrange

        // Act
        /// Implementing ViewInspector way of traversing the hierarchy
        let inspectedView = try sut.inspect()
        let signUpLinkButton = try inspectedView
            .find(viewWithAccessibilityIdentifier: Constants.signUpButtonId)
            .first
        guard let signUpLinkButton = signUpLinkButton else {
            XCTFail("Could not find 'Sign Up' button")
            return
        }

        let button = try signUpLinkButton.button()
        try button.tap()

        // Assert

        // TODO: need to mock the viewModel to achieve that
        XCTFail("Figure out how to assert the tap result on navigation")
    }

    // TODO: forgot password button tap. Figure out how to refine accessibilityIdentifier to take in account special chars
}
