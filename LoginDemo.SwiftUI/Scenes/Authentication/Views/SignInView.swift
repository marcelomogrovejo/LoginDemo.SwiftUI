//
//  SignInView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 26/04/2025.
//

// Source: https://designmodo.com/wp-content/uploads/2018/12/login-form.jpg
// Source: https://www.youtube.com/watch?v=K9d45tbLi0M
// Source: https://www.youtube.com/watch?v=ASnDMEFmty0
// Focus handler source: https://stackoverflow.com/questions/73726968/how-to-make-swiftui-textfield-more-genric-for-focus-state

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var settings: AppSettings
    @StateObject private var viewModel: SignInViewModel = SignInViewModel()

    @State private var height: CGFloat = 0
    private var sharedWindow: [UIWindow].Element? {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
    private var isSmallScreenPhone: Bool {
        UIScreen.main.bounds.height < 750
    }

    @FocusState private var currentFocus: TextFieldFocusType?

    var body: some View {

        /// To adjust the view when the keyboard appears
        /// for phones having lesser screen size, we're enabling scroll view for all time
        ScrollView(isSmallScreenPhone ? .vertical : (height == 0 ? .init() : .vertical),
                   showsIndicators: false) {
            ZStack {
                Color.AppPalette.Main.appBackground
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HeaderView(title: "Welcome\n Back")

                    VStack(alignment: .leading) {
                        CustomTextField(value: $viewModel.email,
                                        title: "Email",
                                        errorMessage: "Email error message here",
                                        textContentType: .emailAddress,
                                        keyboardType: .emailAddress,
                                        isDisabled: $viewModel.isLoading,
                                        onSubmit: {
                            currentFocus = .password
                        })
                        .focused($currentFocus, equals: .email)

                        Spacer()
                            .frame(height: 20)

                        CustomTextField(value: $viewModel.password,
                                        title: "Password",
                                        errorMessage: "Wrong password error message here",
                                        isSecureText: true,
                                        textContentType: .password,
                                        isDisabled: $viewModel.isLoading,
                                        onSubmit: {
                            viewModel.triggerAuthentication()
                        })
                        .focused($currentFocus, equals: .password)
                    }
                    .padding(.horizontal, 40)

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Sign In")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.AppPalette.Text.primary)
                                .font(.system(size: 24))

                            Spacer()

                            CircleButton(isEnabled: $viewModel.isFormValid,
                                         isLoading: $viewModel.isLoading) {
                                viewModel.triggerAuthentication()
                            }
                        }

                        HStack {
                            LinkStyleButton(title: "Sign Up")
                                .padding(.vertical, 30)

                            Spacer()

                            LinkStyleButton(title: "Forgot Password")
                        }

                        Spacer()
                    }
                    .padding(40)
                }
                /// -130 is just a random number that pulls the screen upward to show the bottom buttons.
                .padding(.top, isSmallScreenPhone ? -130 : 0)
            }
        }
        .offset(y: -height)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Default focus
            // TODO: set here

            // Keyboard handlers
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                                   object: nil,
                                                   queue: .main) { notification in
                guard let userInfo = notification.userInfo else { return }
                guard let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

                guard let bottomHeight = self.sharedWindow?.safeAreaInsets.bottom else { return }
                #if DEBUG
//                print(bottomHeight)
                #endif

                let height = keyboardFrameEnd.height - bottomHeight
                #if DEBUG
//                print(keyboardFrameEnd.height)
//                print(height)
                #endif

                /// 195 and 230 are just random numbers that approache to the password error message bottom
                self.height = height - (isSmallScreenPhone ? 195 : 230)
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                                   object: nil,
                                                   queue: .main) { _ in
                #if DEBUG
//                print("hidden")
                #endif
                self.height = 0
            }

            // Configure enviroment vars
            viewModel.setup(settings)
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AppSettings())
}
