//
//  AuthApiService.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 17/5/2025.
//

import Foundation

// TODO: implement here the real api call and dtos

protocol ApiServiceProtocol {
    func mockLoginUser(email: String, password: String, shouldSucceed: Bool) async throws -> Bool
}

struct AuthApiService: ApiServiceProtocol {

    /// Mock method that simulates a call to an api to authenticate a generic username/email and password
    ///
    /// - Parameters:
    ///   - email: String
    ///   - password: String
    ///   - shouldSucced: Bool
    /// - Returns: Bool -> true on success and false on failure
    func mockLoginUser(email: String, password: String, shouldSucceed: Bool) async throws -> Bool {
        do {
            try await Task.sleep(for: .seconds(2))
            return shouldSucceed
        } catch {
            print("Error AuthApiService mockLoginUser: \(error)")
            return false
        }
    }

}
