//
//  SignInViewModel.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 7/5/2025.
//

import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var buttonState: CircleButtonType = .disabled

    private var cancellables: Set<AnyCancellable> = []

    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .map{ !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map{ !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    var appSettings: AppSettings?

    init() {
        // TODO: This is not working, the form is not being validated on keyboard return and tapping the main button when is active.

        /// Simple textfield validateion, if both are not empty, enable the submit button
        isEmailValidPublisher.combineLatest(isPasswordValidPublisher)
            .map{ value1, value2 in
                value1 && value2
            }
            .map{ fieldsValid -> CircleButtonType in
                if fieldsValid {
                    return CircleButtonType.enabled
                }
                return CircleButtonType.disabled
            }
            .assign(to: \.buttonState, on: self)
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
