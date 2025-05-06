//
//  LoginDemo_SwiftUIApp.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 03/05/2025.
//

import SwiftUI

@main
struct LoginDemo_SwiftUIApp: App {

    @StateObject var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(settings)
        }
    }
}
