//
//  IsolatedTestView.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 29/5/2025.
//

import SwiftUI

struct IsolatedTestView: View {
    var body: some View {
        VStack {
            IsolatedTestButton()

            Button("Click me!") {
                print("Hello, World!")
            }

            Button(action: {
                print(1)
            }, label: {
                Image(systemName: "star")
            })

            Button(action: {
                print(1)
            }, label: {
                VStack {
                    Image(systemName: "star")
                    Image(systemName: "star.fill")
                    Text("Click me again!")
                }
            })

            Button(action: {
                print(1)
            }, label: {
                VStack {
                    Image(systemName: "star")
                    Image(systemName: "star.fill")
                    Text("Click me one more time!")
                }
            })
            .accessibilityIdentifier("ViewWithTwoImagesAndText")

            Button(action: {
                print(1)
            }, label: {
                VStack {
                    Image(systemName: "eye")
                        .accessibilityIdentifier("eye-image-id")
                    Image(systemName: "eye.fill")
                        .accessibilityIdentifier("eye-fill-image-id")
                }
            })
            .accessibilityIdentifier("ViewWithTwoImages")
        }
    }
}

#Preview {
    IsolatedTestView()
}
