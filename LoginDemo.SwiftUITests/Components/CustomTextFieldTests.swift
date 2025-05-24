//
//  CustomTextFieldTests.swift
//  LoginDemo.SwiftUITests
//
//  Created by Marcelo Mogrovejo on 24/5/2025.
//

import SwiftUI
import XCTest
import ViewInspector

@testable import LoginDemo_SwiftUI

final class CustomTextFieldTests: XCTestCase {

    var sut: CustomTextField!

    @MainActor
    func testPasswordVisibilityToggle() async throws {
        // Arrange
        let passwordBinding = Binding.constant("myPassword")
        let isDisabled = Binding.constant(false)
        sut = CustomTextField(value: passwordBinding,
                              isSecureText: true,
                              isDisabled: isDisabled)

        // Inspect the view
        let inspectedView = try sut.inspect()

        let mainVStack = try inspectedView
            .find(ViewType.VStack.self)
            .first

        guard let mainVStack = mainVStack else {
            XCTFail("Could not find main VStack")
            return
        }

        let zStack = try mainVStack.zStack(0)

        let toggleButton = try zStack
            .find(viewWithAccessibilityIdentifier: "eye-button-id")
            .first
        guard let toggleButton = toggleButton else {
            XCTFail("Could not find eye button")
            return
        }

        let toggleImage = try toggleButton
            .find(viewWithAccessibilityIdentifier: "eye-image-id")
            .first
        guard let toggleImage = toggleImage else {
            XCTFail("Could not find eye image")
            return
        }

        print(try toggleImage.accessibilityLabel().string())

//        XCTAssertEqual(try toggleImage.accessibilityLabel().string(), "Show-Password", "Initial image should represent 'Show-Password'")
//        XCTAssertTrue(try zStack.secureField(0).isPresent, "Initial state should show SecureField")
//        XCTAssertFalse(try zStack.textField(0).isPresent, "Initial state should NOT show TextField")


//        print("TOGGLE IMAGE NAME: \(try image.systemName)")

//        XCTAssertEqual(try toggleImage.systemName, "eye.fill", "Initial image should be 'eye.fill'")
//        XCTAssertTrue(try inspectedView.find(ViewType.SecureField.self, containing: "passwordField").isPresent, "Initial state should show SecureField")


        // 2. Act: Tap the button
//        try toggleButton.tap()

        // 3. Assert State After First Tap (Crossed-eye is visible)
        // Re-find the image, as the view has likely re-rendered
//        toggleImage = try toggleButton
//            .find(ViewType.Image.self, containing: "passwordVisibilityToggleImage")
//            .first.unwrap(expectation: "Toggle image not found after first tap")
//
//        XCTAssertEqual(try toggleImage.systemName(), "eye.slash.fill", "Image should be 'eye.slash.fill' after first tap")
//        XCTAssertTrue(try inspectedView.find(ViewType.TextField.self, containing: "passwordField").isPresent, "After tap, TextField should be visible")


        // 4. Act: Tap the button again
//        try toggleButton.tap()

        // 5. Assert State After Second Tap (Eye is visible again)
//        toggleImage = try toggleButton
//            .find(ViewType.Image.self, containing: "passwordVisibilityToggleImage")
//            .first.unwrap(expectation: "Toggle image not found after second tap")
//
//        XCTAssertEqual(try toggleImage.systemName(), "eye.fill", "Image should be 'eye.fill' after second tap")
//        XCTAssertTrue(try inspectedView.find(ViewType.SecureField.self, containing: "passwordField").isPresent, "After second tap, SecureField should be visible again")
    }
}
