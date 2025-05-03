//
//  ScrollViewView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 03/05/2025.
//

import SwiftUI

struct ScrollViewView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ForEach(0..<5) { index in
                        Text("Element \(index)")
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}

#Preview {
    ScrollViewView()
}
