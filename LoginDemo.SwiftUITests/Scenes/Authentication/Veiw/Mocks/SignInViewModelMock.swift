//
//  SignInViewModelMock.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 21/5/2025.
//

import Foundation
import Combine
@testable import LoginDemo_SwiftUI

class SignInViewModelMock: SignInViewModelProtocol {
    @Published var email: String = "" { didSet { updateFormValidity() } }
    @Published var password: String = "" { didSet { updateFormValidity() } }
    @Published var isLoading: Bool = false
    @Published var isFormValid: Bool = false
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    @Published var shouldAuthenticate: Bool = false

    var validEmail: String = ""
    var validPassword: String = ""

//    private var setupCalled: Bool = false
//    private var numberOfTimesSetupCalled: Int = 0
//    private var triggerAuthenticationCalled: Bool = false
//    private var numberOfTimesTriggerAuthenticationCalled: Int = 0

    var authenticateUserCalled: Bool = false
    var numberOfTimesAuthenticateUserCalled: Int = 0

    init(initialEmail: String = "", initialPassword: String = "") {
        self.email = initialEmail
        self.password = initialPassword
        updateFormValidity()
    }

    private func updateFormValidity() {
        // Mirror SignInViewModel email validation
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@",
                                         "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        let isEmailValid = !email.isEmpty && emailPredicate.evaluate(with: email)
        // Mirror SignInViewModel password validation
        let isPasswordValid = !password.isEmpty && password.count >= 8
        Task { @MainActor in
            self.isFormValid = isEmailValid && isPasswordValid
//            print("DEBUG: MockViewModel - email='\(email)', password='\(password)', isFormValid=\(self.isFormValid)")
        }
    }

    func triggerAuthentication() {
        // Mimics your real SignInViewModel's combine sink logic
        shouldAuthenticate = true
        if self.shouldAuthenticate && self.isFormValid {
            Task { @MainActor in
                try await self.authenticateUser()
            }
        }
        self.shouldAuthenticate = false
    }

    @MainActor
    func authenticateUser() async throws {
        // Simulate API call delay and result
        isLoading = true
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 second delay

        authenticateUserCalled = true
        numberOfTimesAuthenticateUserCalled += 1

        if isFormValid && email == validEmail && password == validPassword {
            isLoading = false
            errorMessage = nil
            hasError = false

            // TODO: Warning !!
            // To simulate a success navigation, it should be an extra set -> AppSettings.isLoggedIn = true
        } else {
            isLoading = false
            errorMessage = "Invalid credentials from mock"
            hasError = true
            // TODO: Warning !!
            // To test the alert
        }
    }

    func setup(_ appSettings: AppSettings) {
        // TODO: content
    }

}
