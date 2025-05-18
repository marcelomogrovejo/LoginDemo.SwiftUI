//
//  SignInViewModel.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 7/5/2025.
//

// Source form validation: https://blorenzop.medium.com/form-validation-with-combine-4988adcc3b0

import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    // Input values
    @Published var email: String = ""
    @Published var password: String = ""
    // Output subscriber
    @Published var isFormValid: Bool = false
    @Published var shouldAuthenticate = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasError: Bool = false

    private var cancellables: Set<AnyCancellable> = []
    let authApiService: ApiServiceProtocol
    @Published var appSettings: AppSettings?

    // MARK: - WARNING !!!
    // This variable tells the mock authentication method to be succed or fail when sign in.
    // It is just here for testing purposes. In a real app it mustn't be here.
    var loginShouldSucced: Bool = false

    init(authApiService: ApiServiceProtocol) {
        self.authApiService = authApiService

        isValidFormPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)

        $shouldAuthenticate
            // Only authenticate if shouldAuthenticate is true ($0) AND the form is valid
            .filter { $0 && self.isFormValid }
            // It is the crucial operator that allows you to "subscribe" to a publisher and
            // define what actions should occur whenever the publisher emits a new value or
            // when it finishes. It's the bridge between the reactive data flow you define
            // with Combine and the imperative actions you need to perform in your application.
            .sink { _ in
                Task { @MainActor in
                    try await self.authenticateUser()
                }
                // Reset the trigger
                self.shouldAuthenticate = false
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }

    /// Configure the scene to be able to navigate
    /// - Parameter appSettings: Global configuration file
    func setup(_ appSettings: AppSettings) {
        self.appSettings = appSettings
    }

    /// Enabled the form to be validated
    func triggerAuthentication() {
        shouldAuthenticate = true
    }

//    func validateForm() {
        // This is working but it is not robust bocause it depends
        // on SwiuftUI way to observe published vars.
        // Even though validateForm() itself doesn't directly change
        // email or password, the fact that you're calling a method
        // on the ViewModel within the UI event handler (onSubmit())
        // could be enough for SwiftUI's change detection to kick in.
        // It might be thinking: "The user interacted with the UI and
        // called a ViewModel method; I should probably check if any
        // @Published properties that the UI depends on have been
        // affected (even indirectly)."
        // Important Note: Relying on an empty method to trigger a
        // Combine pipeline update is generally not a robust or
        // recommended practice. It's a bit of a side effect of
        // SwiftUI's observation mechanism. The more reliable way to
        // ensure your validation runs is when the actual @Published
        // properties (email and password) change due to user input.
//        print("ViewModel validateForm()...")
//    }

    /// Perfomrs an api call to authenticate the user
    func authenticateUser() async throws {
        Task { @MainActor [weak self] in
            guard let self else { return }

            self.isLoading = true

            do {
                // shouldSucced: for testing purposes can be true to succed or false to fail.
                let result = try await self.authApiService.mockLoginUser(email: self.email,
                                                                    password: self.password,
                                                                    shouldSucceed: self.loginShouldSucced)

                self.isLoading = false

                if result {
                    // Navigate to a logged in home page
                    self.appSettings?.isLoggedIn = result
                } else {
                    print("Error: Authentication")

                    // Simulate API response error on username/email
                    // Simulate API response error on password
                    self.hasError = true
                    self.errorMessage = "🔒 Invalid credentials"
                }
            } catch {
                print("Error: Mock Authentication failed: \(error)")
                self.isLoading = false

                // Simulate API response error on username/email
                // Simulate API response error on password
                self.hasError = true
                self.errorMessage = "Something went wrong."
            }
        }
    }

}

extension SignInViewModel {

    /// Creates a combine publisher that validates the email or username
    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email
            .map{ email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@",
                                                 "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
    
    /// Creates a combine publisher that validates the password
    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map{ password in
                return password.count >= 8
            }
            .eraseToAnyPublisher()
    }
    
    /// Checks if the form (username and password) are valid
    var isValidFormPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            isValidEmailPublisher,
            isValidPasswordPublisher
        )
        .map{ isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid //&& !email.isEmpty && !password.isEmpty
        }
        .eraseToAnyPublisher()
    }
}
