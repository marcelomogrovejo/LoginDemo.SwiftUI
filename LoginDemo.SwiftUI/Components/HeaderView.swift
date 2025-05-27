//
//  HeaderView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 28/04/2025.
//

import SwiftUI

struct HeaderView: View {

    var title: String = ""

    var body: some View {
        ZStack(alignment: .top) {
//            Image("login-form-template")

            Rectangle()
                .fill(Color.AppPalette.Main.appSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .offset(x: 0, y: 0)

            Circle()
                .fill(Color.AppPalette.Main.appTertiary)
                .frame(width: 400, height: 400)
                .offset(x: 220, y: 0)

            StainShape()
                .fill(Color.AppPalette.Main.appPrimary)
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
                    .accessibilityIdentifier("title-text-id")

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
