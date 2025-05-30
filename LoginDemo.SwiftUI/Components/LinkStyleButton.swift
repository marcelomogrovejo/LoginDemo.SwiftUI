//
//  LinkStyleButton.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 04/05/2025.
//

import SwiftUI

struct LinkStyleButton: View {

    var title: String = "button title"
//    var action: TODO:

    var body: some View {
        VStack(spacing: 2) {
            Button {
                // TODO: Action
            } label: {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.AppPalette.Main.appPurple)
            }
            .overlay {
                Rectangle()
                    .offset(y: 13)
                    .fill(Color.AppPalette.Main.appPurple)
                    .frame(height: 1)
            }

        }
    }
}

#Preview {
    LinkStyleButton()
}
