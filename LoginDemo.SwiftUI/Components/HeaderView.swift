//
//  HeaderView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 28/04/2025.
//

// Source: https://designmodo.com/wp-content/uploads/2018/12/login-form.jpg

import SwiftUI

struct HeaderView: View {

    var title: String = ""

    var body: some View {
        ZStack(alignment: .top) {
//            Image("login-form-template")

            Rectangle()
                .fill(Color.AppPalette.Main.appPink)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .offset(x: 0, y: 0)

            Circle()
                .fill(Color.AppPalette.Main.appYellow)
                .frame(width: 400, height: 400)
                .offset(x: 220, y: 0)

            StainShape()
                .fill(Color.AppPalette.Main.appPurple)
                .frame(maxWidth: .infinity, alignment: .top)
                .frame(height: 400)
                .offset(x: 0, y: 0)

            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .font(.system(size: 32))
                    .foregroundStyle(Color.AppPalette.Text.title)
                    .padding(.top, 190)
                    .padding(.leading, 50)

                Spacer()
            }
        }
        .frame(maxWidth: .infinity/*, maxHeight: .infinity*/, alignment: .top)
        .background(Color.clear)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    HeaderView()
}
