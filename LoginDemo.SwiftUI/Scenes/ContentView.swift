//
//  ContentView.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 03/05/2025.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var settings: AppSettings

    var body: some View {
        NavigationStack {
            if settings.isLoggedIn {
                HomeView()
            } else {
                SignInView()
                    .environmentObject(settings)
            }
        }
    }
}

#Preview {
    ContentView()
}
