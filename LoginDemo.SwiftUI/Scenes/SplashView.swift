//
//  SplashView.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 5/5/2025.
//

import SwiftUI

struct SplashView: View {

    @State private var isActive: Bool = false
    @State private var size: CGFloat = 1.0
    @State private var opacity: CGFloat = 0.5

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color(.white)

                VStack {
                    VStack {
                        Image("playstore")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 128, height: 128)
                        
                        //                            Text("Mogro's App")
                        //                                .font(.system(size: 26))
                        //                                .foregroundStyle(Color.black.opacity(0.8))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            self.size = 2.0
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.smooth(duration: 1.0)) {
                            self.isActive = true
                        }
                    }
                }
            }
            .ignoresSafeArea(.all)
        }
    }
}


#Preview {
    SplashView()
}
