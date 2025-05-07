//
//  Color+Palette.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 03/05/2025.
//

import SwiftUI

extension Color {
    struct AppPalette {
        struct Main {
            static let appBackground = Color("bkg-default-color")
            static let appPink = Color("app-pink-color")
            static let appPurple = Color("app-purple-color")
            static let appYellow = Color("app-yellow-color")
        }

        struct Text {
            static let title = Color("txt-title-color")
            static let primary = Color("txt-primary-color")
            static let secondary = Color("txt-secondary-color")
            static let error = Color("txt-error-color")
        }

        struct TextField {
            static let primary = Color("txtfld-primary-color")
        }

        struct Button {
            static let enabled = Color("btn-enabled-color")
            static let disabled = Color("btn-disabled-color")
        }
    }
}
