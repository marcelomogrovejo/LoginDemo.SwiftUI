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

    private var cancellables: Set<AnyCancellable> = []
    var appSettings: AppSettings?

    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }

    func setup(_ appSettings: AppSettings) {
        self.appSettings = appSettings
    }

    func authenticate() {
        appSettings?.isLoggedIn = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
//            self?.settings.isLoggedIn = true
//        }
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
