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
        ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : (height == 0 ? .init() : .vertical), showsIndicators: true) {
            ZStack {
                Color.AppPalette.Main.appBackground
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ZStack(alignment: .top) {
                        HeaderView()

                        HStack {
                            Text("Welcome\n Back")
                                .fontWeight(.bold)
                                .font(.system(size: 32))
                                .foregroundStyle(Color.AppPalette.Text.title)
                                .padding(.leading, 60)

                            Spacer()
                        }
                        .padding(.top, 150)
                    }

                    VStack(alignment: .leading) {
                        Text("Email")
                            .foregroundStyle(Color.AppPalette.Text.secondary)
                            .font(.system(size: 15))

                        VStack(alignment: .leading) {
                            TextField("", text: $email)
                                .foregroundStyle(Color.AppPalette.TextField.primary)

                            Rectangle()
                                .fill(email == "" ? Color.black.opacity(0.08) : Color.AppPalette.Main.appPurple)
                                .frame(height: 1)

                            Text("Error message")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.AppPalette.Text.error)
                        }
                        .padding(.bottom, 20)

                        Text("Password")
                            .foregroundStyle(Color.AppPalette.Text.secondary)
                            .font(.system(size: 15))

                        VStack(alignment: .leading) {
                            HStack {
                                SecureField("", text: $password)
                                    .foregroundStyle(Color.AppPalette.TextField.primary)

                                Button {
                                    // TODO:
                                } label: {
                                    Image(systemName: "eye.slash.fill")
                                        .foregroundStyle(Color.AppPalette.Main.appPurple)
                                }
                            }

                            Rectangle()
                                .fill(password == "" ? Color.black.opacity(0.08) : Color.AppPalette.Main.appPurple)
                                .frame(height: 1)

                            Text("Error message")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.AppPalette.Text.error)
                        }
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
                            Button {
                                // TODO: Sign Up
                            } label: {
                                Text("Sign Up")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.AppPalette.Main.appPurple)
                            }
                            .padding(.vertical, 30)

                            Spacer()

                            Button {
                                // TODO: Forgot password
                            } label: {
                                Text("Forgot Password")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.AppPalette.Main.appPurple)
                            }
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
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { notification in
                // TODO: WARNING!
                // guard let
                let data = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                // guard let
                let height = data.cgRectValue.height - (self.sharedWindow?.safeAreaInsets.bottom)!

                print(height)
                self.height = height
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { _ in
                print("hidden")
                self.height = 0
            }
        }
    }
}

#Preview {
    SignInView()
}
