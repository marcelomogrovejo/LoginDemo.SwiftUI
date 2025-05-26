//
//  ContentViewMock.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 19/5/2025.
//

//
//  ContentViewMock.swift
//  ViewInspectorDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 18/5/2025.
//

import SwiftUI

struct ContentViewMock<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
    }
}
