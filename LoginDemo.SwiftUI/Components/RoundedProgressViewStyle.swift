//
//  RoundedProgressViewStyle.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 10/5/2025.
//

// Source: https://www.youtube.com/watch?v=mw8ZRWmhK9E

import SwiftUI

struct RoundedProgressViewStyle: ProgressViewStyle {

    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            .tint(.white)
            .foregroundStyle(Color.white)
    }

}

extension ProgressViewStyle where Self == RoundedProgressViewStyle {
    static var rounded: Self { .init() }
}
