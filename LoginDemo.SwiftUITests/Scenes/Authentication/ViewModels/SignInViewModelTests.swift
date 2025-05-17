//
//  SignInViewModelTests.swift
//  LoginDemo.SwiftUITests
//
//  Created by Marcelo Mogrovejo on 15/5/2025.
//

import XCTest
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

    // init ?

    // TODO: Not working
    // Looks like the issue is related to async/await and combine. In some way, the test is not waiting
    // the completion of the async task to do the assertions.
    // The google searchs were related to 'how to unit testing main actor task', 'how to unit testing
    // async/await and combine' and things like that.
    //
    // Discoveries:
    // * Setting a breakpoint on 'authenticateUser()' method on SignInViewModel:97: self.isLoading = false
    //   When the app run on simulator, the breakpoint is reached.
    //   When the test runs, the breakpoint is never reached, and the test fails very fast.
    // * Setting a breakpoint on 'mockLoginUser()' method on ApiService:26: return shouldSucceed
    //   When the app run on simulator, the breakpoint is reached.
    //   When the test runs, the breakpoint is never reached, and the test fails very fast.
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
            expectation.fulfill()
        }

        // Assert
        await fulfillment(of: [expectation], timeout: 5)

//        XCTAssertFalse(sut.appSettings?.isLoggedIn,
//                       "appSettings.isLoggedIn should be false but it was true.")
        XCTAssertTrue(sut.hasError, "hasError should be true")
        XCTAssertEqual(sut.errorMessage, errorMessage, "errorMessage should be '\(errorMessage)'")
        XCTAssertFalse(sut.isLoading, "isLoading should be false")
    }

    func testAuthenticateUserShouldSucced() async throws {
    }

    func testTriggerAuthenticationShouldSucced() throws {
        // Arrange
        sut.shouldAuthenticate = false

        // Act
        sut.triggerAuthentication()

        // Assert
        XCTAssertTrue(sut.shouldAuthenticate,
                      "shouldAuthenticate should be true but it was false.")
    }

}
