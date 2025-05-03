//
//  StainView.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 28/04/2025.
//

// Source: https://www.youtube.com/watch?v=8vAJ9x0z4k8

import SwiftUI

struct StainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let startPoint = CGPoint(x: rect.minX, y: height * 0.47)
        let endPoint = CGPoint(x: rect.minX, y: height * 0.77)

        path.move(to: startPoint)

        path.addCurve(to: CGPoint(x: width * 0.33, y: height * 0.15),
                      control1: CGPoint(x: width * 0.2, y: height * 0.45),
                      control2: CGPoint(x: width * 0.18, y: height * 0.25))

        path.addCurve(to: CGPoint(x: width * 0.78, y: rect.minY),
                      control1: CGPoint(x: width * 0.7, y: height * 0.005),
                      control2: CGPoint(x: width * 0.6, y: height * 0.10))

        // Corner rect to the right
        path.addLine(to: CGPoint(x: width, y: rect.minY))

        // Corner rect down
        path.addLine(to: CGPoint(x: width, y: height * 0.13))

        path.addCurve(to: CGPoint(x: width * 0.65, y: height * 0.65),
                      control1: CGPoint(x: width * 0.90, y: height * 0.4),
                      control2: CGPoint(x: width * 0.6, y: height * 0.3))

        path.addQuadCurve(to: CGPoint(x: width * 0.35, y: height * 0.96),
                          control: CGPoint(x: width * 0.62, y: height * 0.95))
        
        path.addQuadCurve(to: endPoint,
                          control: CGPoint(x: width * 0.08, y: height * 0.93))

        path.closeSubpath()

        return path
    }
}

struct StainView: View {
    var body: some View {
        StainShape()
            .fill(.pink)
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.width)
            .background(.blue.opacity(0.6))
    }
}

#Preview {
    StainShape()
}
