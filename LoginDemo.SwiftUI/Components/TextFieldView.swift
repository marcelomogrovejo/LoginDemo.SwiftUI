//
//  TextFieldView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

import SwiftUI

struct TextFieldView: View {

    @Binding var value: String

    var placeholderText: String = "placeholder here"
    var width: CGFloat = 200
    var isSecureText: Bool = false
    var errorMessage: String = "error message"

    var body: some View {
        HStack {
            Spacer()

            VStack (alignment: .leading){
                TextField("", text: $value, prompt: Text(placeholderText).foregroundColor(.gray))
                    .foregroundStyle(Color.purple)
                    .frame(height: 40)
                    .padding(.horizontal, 10)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.purple, lineWidth: 1.0)
                    )

                Text(errorMessage)
                    .foregroundStyle(Color.red)
                    .font(.system(size: 12))
                    .padding(.leading, 10)
            }

            Spacer()
        }
        .frame(width: width)
//        .background(Color.teal)
    }
}

#Preview {
    TextFieldView(value: .constant(""))
}
