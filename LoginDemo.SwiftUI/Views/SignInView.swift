//
//  SignInView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 26/04/2025.
//

// Source: https://designmodo.com/wp-content/uploads/2018/12/login-form.jpg
// Source: https://www.youtube.com/watch?v=K9d45tbLi0M
// TODO: https://www.youtube.com/watch?v=ASnDMEFmty0

import SwiftUI

struct SignInView: View {

    @EnvironmentObject var settings: AppSettings

    @State private var email: String = ""
    @State private var password: String = ""
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
                        TextFieldView(value: $email,
                                      title: "Email",
                                      errorMessage: "Email error message here")

                        Spacer()
                            .frame(height: 20)

                        TextFieldView(value: $password,
                                      title: "Password",
                                      errorMessage: "Wrong password error message here",
                                      isSecureText: true)
                    }
                    .padding(.horizontal, 40)

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Sign In")
                                .fontWeight(.bold)
                                .foregroundStyle(Color.AppPalette.Text.primary)
                                .font(.system(size: 24))

                            Spacer()

                            Button {
                                // TODO: validate textfields
                                settings.isLoggedIn = true
                            } label: {
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(Color.AppPalette.Main.appPurple)
                                    .frame(width: 80, height: 80)
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
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                                   object: nil,
                                                   queue: .main) { notification in
                guard let userInfo = notification.userInfo else { return }
                guard let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

                guard let bottomHeight = self.sharedWindow?.safeAreaInsets.bottom else { return }
//                print(bottomHeight)

                let height = keyboardFrameEnd.height - bottomHeight
//                print(keyboardFrameEnd.height)
//                print(height)

                /// 195 and 230 are just random numbers that approache to the password error message bottom
                self.height = height - (isSmallScreenPhone ? 195 : 230)
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                                   object: nil,
                                                   queue: .main) { _ in
//                print("hidden")
                self.height = 0
            }
        }
    }
}

#Preview {
    SignInView()
}
