//
//  Color+Palette.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 03/05/2025.
//

// Source: https://coolors.co/ffbc42-d81159-8f2d56-218380-73d2de

import SwiftUI

extension Color {
    struct AppPalette {
        struct Main {
            static let appBackground = Color("bkg-default-color")
            static let appPrimary = Color("app-primary-color")
            static let appSecondary = Color("app-secondary-color")
            static let appTertiary = Color("app-tertiary-color")
        }

        struct Text {
            static let title = Color("txt-title-color")
            static let primary = Color("txt-primary-color")
            static let secondary = Color("txt-secondary-color")
            static let error = Color("txt-error-color")
        }

        struct TextField {
            static let primary = Color("txtfld-primary-color")
            static let secondary = Color("txtfld-secondary-color")
            static let error = Color("txtfld-error-color")
        }

        struct Button {
            static let enabled = Color("btn-enabled-color")
            static let disabled = Color("btn-disabled-color")
        }
    }
}
