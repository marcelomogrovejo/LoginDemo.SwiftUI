//
//  HomeView.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 6/5/2025.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var settings: AppSettings

    var body: some View {
        ZStack {
            Color(.white)

            Button {
                settings.isLoggedIn = false
            } label: {
                Text("Logout")
                    .foregroundStyle(Color.AppPalette.Main.appPurple)
            }
            .padding(.trailing, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            VStack(alignment: .center) {
                Image(systemName: "flag.pattern.checkered")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(Color.AppPalette.Main.appPurple)
                    .symbolEffect(.breathe)
                
                Text("Home View")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.AppPalette.Main.appPurple)
                    .bold()
                    .padding(.vertical)
            }
        }
    }
}

#Preview {
    HomeView()
}
