//
//  AppSettings.swift
//  CombineDemo2.SwiftUI
//
//  Created by Marcelo Mogrovejo on 27/04/2025.
//

import Foundation

class AppSettings: ObservableObject {
    // TODO: this var can be replaced by token in the future and depending on the auth method.
    @Published var isLoggedIn = false
}
