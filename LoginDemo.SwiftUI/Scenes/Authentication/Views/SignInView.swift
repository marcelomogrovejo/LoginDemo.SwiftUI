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
// Alert source: https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-an-alert

import SwiftUI

struct SignInView<ViewModel>: View where ViewModel: SignInViewModelProtocol {

    @EnvironmentObject var settings: AppSettings
    @StateObject private var viewModel: ViewModel

    @State private var height: CGFloat = 0
    private var sharedWindow: [UIWindow].Element? {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
    private var isSmallScreenPhone: Bool {
        UIScreen.main.bounds.height < AuthConstants.SignInView.screenHeight
    }

    @FocusState private var currentFocus: TextFieldFocusType?

    init(viewModel: ViewModel = SignInViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {

        /// To adjust the view when the keyboard appears
        /// for phones having lesser screen size, we're enabling scroll view for all time
        ScrollView(isSmallScreenPhone ? .vertical : (height == 0 ? .init() : .vertical),
                   showsIndicators: false) {
            ZStack {
                Color.AppPalette.Main.appBackground
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HeaderView(title: AuthConstants.SignInView.mainTitle)

                    VStack(alignment: .leading) {
                        CustomTextField(value: $viewModel.email,
                                        title: AuthConstants.SignInView.usernameTitle,
                                        textContentType: .emailAddress,
                                        keyboardType: .emailAddress,
                                        isDisabled: $viewModel.isLoading,
                                        onSubmit: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                currentFocus = .password
                            }
                        })
                        .focused($currentFocus, equals: .email)

                        Spacer()
                            .frame(height: AuthConstants.SignInView.spaceBetweenTextFields)

                        CustomTextField(value: $viewModel.password,
                                        title: AuthConstants.SignInView.passwordTitle,
                                        isSecureText: true,
                                        textContentType: .password,
                                        isDisabled: $viewModel.isLoading,
                                        onSubmit: {
                            viewModel.triggerAuthentication()
                        })
                        .focused($currentFocus, equals: .password)
                    }
                    .padding(.horizontal, AuthConstants.SignInView.formPadding)

                    VStack(alignment: .leading) {
                        HStack {
                            // TODO: Warning !
                            // This text componend from the original design is confused
                            // bucause it looks like a Sign In button but it's not.
                            // Maybe it shouldn't be here or should have anogher design
                            // in order not to look like a posible button to tap.
                            Text(AuthConstants.SignInView.submitTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.AppPalette.Text.primary)
                                .font(.system(size: AuthConstants.SignInView.submitFontSize))
                            /// Makes UI test fails -> it doesn't find the element
//                                .accessibilityHidden(true)
                                .accessibilityIdentifier("sign-in-button-text-id")

                            Spacer()

                            CircleButton(title: AuthConstants.SignInView.circularButtonTitle,
                                         isEnabled: $viewModel.isFormValid,
                                         isLoading: $viewModel.isLoading) {
                                viewModel.triggerAuthentication()
                            }
                        }

                        HStack {
                            LinkStyleButton(title: AuthConstants.SignInView.signUpTitle)
                                .padding(.vertical, AuthConstants.SignInView.signUpButtonVerticalPadding)

                            Spacer()

                            LinkStyleButton(title: AuthConstants.SignInView.forgotPasswordTitle)
                        }

                        Spacer()
                    }
                    .padding(AuthConstants.SignInView.buttonSectionPadding)
                }
                /// -130 is just a random number that pulls the screen upward to show the bottom buttons.
                .padding(.top, isSmallScreenPhone ?  AuthConstants.SignInView.viewPadding : 0)
            }
        }
        // Pushes up the scrollview content to make the password visible.
        // The button is covered by the keyboard.
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
        .customeAlert(isPresented: $viewModel.hasError,
                      title: AuthConstants.SignInView.errorAlertTitle,
                      message: viewModel.errorMessage ?? AuthConstants.SignInView.errorAlertMessage,
                      buttonTitle: AuthConstants.SignInView.errorAlertButtonTitle)
    }
}

#Preview {
    SignInView()
        .environmentObject(AppSettings())
}
