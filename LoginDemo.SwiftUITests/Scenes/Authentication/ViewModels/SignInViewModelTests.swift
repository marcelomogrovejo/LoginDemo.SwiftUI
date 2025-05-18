//
//  SignInViewModelTests.swift
//  LoginDemo.SwiftUITests
//
//  Created by Marcelo Mogrovejo on 15/5/2025.
//

import XCTest
import Combine
@testable import LoginDemo_SwiftUI



// TODO: handle cancellables


final class SignInViewModelTests: XCTestCase {

    var authApiService: ApiServiceProtocol!
    var sut: SignInViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        authApiService = AuthApiService()
        sut = SignInViewModel(authApiService: authApiService)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        authApiService = nil
        sut = nil
    }

    // TODO: test the init ?

    func testTriggerAuthenticationShouldSucced() throws {
        // Arrange
        sut.shouldAuthenticate = false

        // Act
        sut.triggerAuthentication()

        // Assert
        XCTAssertTrue(sut.shouldAuthenticate,
                      "shouldAuthenticate should be true but it was false.")
    }

    func testAuthenticateUserShouldFail() async throws {
        // Arrange
        sut.shouldAuthenticate = true
        sut.email = "test@test.com"
        sut.password = "12345678"
        sut.loginShouldSucced = false
        let errorMessage = "🔒 Invalid credentials"
        let expectation = XCTestExpectation(description:
                                                "Failed authentication should set hasError and errorMessage")

        // Act
        Task {
            try await sut.authenticateUser()
        }

        // Observe the errorMessage and fulfill the expectation when it's set
        sut.$errorMessage
            .dropFirst() // Ignore the initial nil value
            .sink { receivedErrorMessage in
                if receivedErrorMessage == errorMessage {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertTrue(sut.hasError, "hasError should be true")
        XCTAssertEqual(sut.errorMessage, errorMessage, "errorMessage should be '\(errorMessage)'")
        XCTAssertFalse(sut.isLoading, "isLoading should be false")
    }

    func testAuthenticateUserShouldSucced() async throws {
        // Arrange
        sut.setup(AppSettings())
        sut.shouldAuthenticate = true
        sut.email = "test@test.com"
        sut.password = "12345678"
        sut.loginShouldSucced = true
        let expectation = XCTestExpectation(description:
                                                "Successful authentication should set isLoggedIn")

        // Act
        Task {
            try await sut.authenticateUser()
        }

        // Observe the errorMessage and fulfill the expectation when it's set
        sut.$isLoading
            .dropFirst() // Ignore the initial value
            .sink { receivedValue in
                if receivedValue == false {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertFalse(sut.hasError, "hasError should be false")
        XCTAssertFalse(sut.isLoading, "isLoading should be false")
        XCTAssertNotNil(sut.appSettings, "appSettings should not be nil")
        if let appSettings = sut.appSettings {
            XCTAssertTrue(appSettings.isLoggedIn, "isLoggedIn should be true")
        }
    }

    func testSetupShouldSetAppSettings() {
        // Arrange
        let appSettings = AppSettings()

        // Act
        sut.setup(appSettings)

        // Accert
        XCTAssertNotNil(sut.appSettings, "appSettings should not be nil")
        XCTAssertTrue(sut.appSettings === appSettings, "appSettings should be the same instance")
        XCTAssertFalse(appSettings.isLoggedIn, "isLoggedIn should be false as initial value")
    }

    func testIsValidEmailPublisher_ShouldBeValid() async throws {
        // Arrange
        sut.email = "test@test.com"
        var isEmailValid = false
        let expectation = XCTestExpectation(description:
                                                "Successful email validation")

        // Act
        sut.isValidEmailPublisher
            .sink { receivedValue in
                isEmailValid = receivedValue
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertTrue(isEmailValid, "Email should be valid")
    }

    func testIsValidEmailPublisher_ShouldNotBeValid() async throws {
        // Arrange
        sut.email = "test"
        var isEmailValid = false
        let expectation = XCTestExpectation(description:
                                                "Failure email validation")

        // Act
        sut.isValidEmailPublisher
            .sink { receivedValue in
                isEmailValid = receivedValue
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertFalse(isEmailValid, "Email should not be valid")
    }

    func testIsValidPasswordPublisher_ShouldBeValid() async throws {
        // Arrange
        sut.password = "12345678"
        var isPasswordValid = false
        let expectation = XCTestExpectation(description:
                                                "Successful password validation")

        // Act
        sut.isValidPasswordPublisher
            .sink { receivedValue in
                isPasswordValid = receivedValue
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertTrue(isPasswordValid, "Password should be valid")
    }

    func testIsValidPasswordPublisher_ShouldNotBeValid() async throws {
        // Arrange
        sut.email = "12"
        var isPasswordValid = false
        let expectation = XCTestExpectation(description:
                                                "Failure password validation")

        // Act
        sut.isValidPasswordPublisher
            .sink { receivedValue in
                isPasswordValid = receivedValue
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertFalse(isPasswordValid, "Password should not be valid")
    }

    func testIsValidFormPublisher_ShouldBeValid() async throws {
        // Arrange
        sut.email = "test@test.com"
        sut.password = "12345678"
        var isFormValid = false
        let expectation = XCTestExpectation(description:
                                                "Successful form validation")

        // Act
        sut.isValidFormPublisher
            .sink { receivedValue in
                isFormValid = receivedValue
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertTrue(isFormValid, "Form should be valid")
    }

    func testIsValidFormPublisher_ShouldNotBeValid_WhenEmailIsNotValid() async throws {
        // Arrange
        sut.email = "test"
        sut.password = "12345678"
        var isFormValid = false
        let expectation = XCTestExpectation(description:
                                                "Failure form validation")

        // Act
        sut.isValidFormPublisher
            .sink { receivedValue in
                isFormValid = receivedValue
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertFalse(isFormValid, "Form should not be valid")
    }

    func testIsValidFormPublisher_ShouldNotBeValid_WhenPasswordIsNotValid() async throws {
        // Arrange
        sut.email = "test@test.com"
        sut.password = "12"
        var isFormValid = false
        let expectation = XCTestExpectation(description:
                                                "Failure form validation")

        // Act
        sut.isValidFormPublisher
            .sink { receivedValue in
                isFormValid = receivedValue
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

        XCTAssertFalse(isFormValid, "Form should not be valid")
    }

}
