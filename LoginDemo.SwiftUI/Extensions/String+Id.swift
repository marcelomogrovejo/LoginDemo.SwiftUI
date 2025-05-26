//
//  String+Id.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 26/5/2025.
//

import Foundation

extension String {

    func getAccessibiltiyId(suffix: String = "") -> String {
        String(self.lowercased().replacingOccurrences(of: " ", with: "-")) + "-" + suffix + "-id"
    }
}
