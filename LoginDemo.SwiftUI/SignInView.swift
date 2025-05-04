//
//  SignInView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 26/04/2025.
//

// Source: https://www.youtube.com/watch?v=ASnDMEFmty0

import SwiftUI

struct SignInView: View {

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var height: CGFloat = 0
    private var sharedWindow = UIApplication
        .shared
        .connectedScenes
        .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
        .first { $0.isKeyWindow }

    var body: some View {
        /// for phones having lesser screen size, we're enabling scroll view for all time
        ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : (height == 0 ? .init() : .vertical),
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
                                // TODO:
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
                .padding(.bottom, sharedWindow?.safeAreaInsets.bottom)
            }
        }
        .padding(.bottom, height)
        .background(Color.black.opacity(0.03).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                                   object: nil,
                                                   queue: .main) { notification in
                // TODO: WARNING!
                // guard let
                let data = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                // guard let
                let height = data.cgRectValue.height - (self.sharedWindow?.safeAreaInsets.bottom)!

                print(height)
                self.height = height
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                                   object: nil,
                                                   queue: .main) { _ in
                print("hidden")
                self.height = 0
            }
        }
    }
}

#Preview {
    SignInView()
}
