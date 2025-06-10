//
//  CircleButton.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 30/04/2025.
//

// Source SF symbols colors: https://stackoverflow.com/questions/56709463/change-the-stroke-fill-color-of-sf-symbol-icon-in-swiftui

import SwiftUI
import CommonAccessibility

enum CircleButtonType {
    case enabled
    case disabled
    case loading
}

// TODO: button growing event
//struct GrowingButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding()
//            .background(.purple)
//            .foregroundStyle(.white)
//            .clipShape(Capsule())
//            .scaleEffect(configuration.isPressed ? 1.2 : 1)
//            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
//    }
//}

struct CircleButton: View {

    private struct Constants {
        static let animationDuration: Double = 2.0
        static let animationImageStartAngleDegrees: Double = 0.0
        static let animationImageEndAngleDegrees: Double = 360.0
        static let submitImageName: String = "arrow.right.circle.fill"
        static let loadingImageName: String = "arrow.trianglehead.2.clockwise.rotate.90.circle.fill"
        static let imageWidth: CGFloat = 50
        static let imageHeight: CGFloat = 50

        static let defaultAccessibilityId: String = "main".getAccessibilityIdentifier(type: .accButton)
        static let defaultAccessibilityLabelValue = LocalizedStringKey("submit-button".getAccessibilityLabel(viewType: .button))

//        static let accessibilityLoadingLabel: String = "Loading indicator rolling"
        static let defaultAccessibilityLoadingLabel = LocalizedStringKey("submit-loading".getAccessibilityLabel(viewType: .text))
//        static let accessibilityLoadingValue: String = "It is a loading indicator that rolling instead of showing the button."
        static let defaultAccessibilityLoadingValue = LocalizedStringKey("submit-loading-value".getAccessibilityLabel(viewType: .text))

    }

    private var color: Color

    var title: String
    var accessibilityId: String?
    var accessibilityLabelValue: LocalizedStringKey?
    var accessibilityLoadingLabel: LocalizedStringKey?
    var accessibilityLoadingValue: LocalizedStringKey?
    @Binding var isEnabled: Bool
    @Binding var isLoading: Bool
    var action: (() -> ())?

    @State private var isAnimating = false
    private var foreverAnimation: Animation {
        Animation.linear(duration: Constants.animationDuration)
            .repeatForever(autoreverses: false)
    }

    init(title: String,
         accessibilityId: String?,
         accessibilityLabelValue: LocalizedStringKey?,
         accessibilityLoadingLabel: LocalizedStringKey?,
         accessibilityLoadingValue: LocalizedStringKey?,
         isEnabled: Binding<Bool>,
         isLoading: Binding<Bool>,
         action: (() -> ())? = nil) {
        self.color = .AppPalette.Button.enabled
        self.title = title
        self.accessibilityId = accessibilityId
        self.accessibilityLabelValue = accessibilityLabelValue
        self.accessibilityLoadingLabel = accessibilityLoadingLabel
        self.accessibilityLoadingValue = accessibilityLoadingValue
        self._isEnabled = isEnabled
        self._isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button {
            if !isLoading && isEnabled {
                if let action = action {
                    action()
                }
            }

            #if DEBUG
            // TODO: Warning! Testing the fade bug
//            isLoading.toggle()
            #endif
        } label: {
            // TODO: figure out how to have just one image
            if isLoading {
                Image(systemName: Constants.loadingImageName)
                    .resizable()
                    .scaledToFit()
                    /// .white = primary, disabled color = secondary, none = tertiary
                    .foregroundStyle(.white, Color.AppPalette.Button.disabled)
                    .rotationEffect(Angle(degrees: isAnimating ?
                                          Constants.animationImageEndAngleDegrees :
                                            Constants.animationImageStartAngleDegrees))
                    .animation(isAnimating ? foreverAnimation : .default, value: UUID())
                    .onAppear {
                        self.isAnimating = true
                        self.isEnabled = false
                    }
                    .onDisappear {
                        self.isAnimating = false
                        self.isEnabled = true
                    }
                    .frame(width: Constants.imageWidth,
                           height: Constants.imageHeight)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(accessibilityLoadingLabel ?? Constants.defaultAccessibilityLoadingLabel)
                    .accessibilityValue(accessibilityLoadingValue ?? Constants.defaultAccessibilityLoadingValue)
            } else {
                Image(systemName: Constants.submitImageName)
                    .resizable()
                    .scaledToFit()
                    /// .white = primary, disabled color = secondary, none = tertiary
                    .foregroundStyle(.white, (isEnabled ? color : Color.AppPalette.Button.disabled))
                    .frame(width: Constants.imageWidth,
                           height: Constants.imageHeight)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(accessibilityLabelValue ?? Constants.defaultAccessibilityLabelValue)
            }
        }
        // TODO: animation
//        .buttonStyle(GrowingButtonStyle())
        .disabled(!isEnabled)
        .onAppear { self.isLoading = false }
        .accessibilityIdentifier(accessibilityId ?? Constants.defaultAccessibilityId)
    }
}

#Preview {
    CircleButton(title: "Button title",
                 accessibilityId: "",
                 accessibilityLabelValue: "",
                 accessibilityLoadingLabel: "",
                 accessibilityLoadingValue: "",
                 isEnabled: .constant(false),
                 isLoading: .constant(true),
                 action: { print("Action performed") })
}
