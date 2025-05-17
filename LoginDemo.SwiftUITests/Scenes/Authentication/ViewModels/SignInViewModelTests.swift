//
//  SignInViewModelTests.swift
//  LoginDemo.SwiftUITests
//
//  Created by Marcelo Mogrovejo on 15/5/2025.
//

import XCTest
import Combine
@testable import LoginDemo_SwiftUI

final class SignInViewModelTests: XCTestCase {

    var authApiService: ApiServiceProtocol!
    var sut: SignInViewModel!

    override func setUpWithError() throws {
        authApiService = AuthApiService()
        sut = SignInViewModel(authApiService: authApiService)
    }

    override func tearDownWithError() throws {
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
        var cancellables = Set<AnyCancellable>()

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
        var cancellables = Set<AnyCancellable>()

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

    // TODO: test the validation computed vars ?
}
