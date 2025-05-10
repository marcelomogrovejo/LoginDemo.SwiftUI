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

    private var cancellables: Set<AnyCancellable> = []
    var appSettings: AppSettings?

    init() {
        isFormValidPublisher
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
                self.authenticateUser()
                // Reset the trigger
                self.shouldAuthenticate = false
            }
            .store(in: &cancellables)
    }

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

    private func authenticateUser() {
        print("Authenticating...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.appSettings?.isLoggedIn = true
        }
    }

    func setup(_ appSettings: AppSettings) {
        self.appSettings = appSettings
    }
}

private extension SignInViewModel {

    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .map{ email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }

    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map{ password in
                return password.count >= 8
            }
            .eraseToAnyPublisher()
    }

    var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            isEmailValidPublisher,
            isPasswordValidPublisher
        )
        .map{ isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid //&& !email.isEmpty && !password.isEmpty
        }
        .eraseToAnyPublisher()
    }
}
