//
//  TextFieldView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

import SwiftUI

struct TextFieldView: View {

    @Binding var value: String

    var title: String = "title"
    var placeholderText: String = "placeholder here"
    var errorMessage: String = "error message"
    var isSecureText: Bool = false

    var body: some View {
        Text(title)
            .foregroundStyle(Color.AppPalette.Text.secondary)
            .font(.system(size: 15))

        VStack(alignment: .leading) {
            if isSecureText {
                HStack {
                    SecureField("", text: $value)
                        .foregroundStyle(Color.AppPalette.TextField.primary)

                    Button {
                        // TODO:
                    } label: {
                        Image(systemName: "eye.slash.fill")
                            .foregroundStyle(Color.AppPalette.Main.appPurple)
                    }
                }
            } else {
                TextField("", text: $value)
                    .foregroundStyle(Color.AppPalette.TextField.primary)
            }

            Rectangle()
                .fill(value == "" ? Color.black.opacity(0.08) : Color.AppPalette.Main.appPurple)
                .frame(height: 1)

            Text(errorMessage)
                .font(.system(size: 12))
                .foregroundStyle(Color.AppPalette.Text.error)
        }
    }
}

#Preview {
    TextFieldView(value: .constant(""))
}
