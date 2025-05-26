//
//  LinkStyleButtonTests.swift
//  LoginDemo.SwiftUITests
//
//  Created by Marcelo Mogrovejo on 25/5/2025.
//

import XCTest
@testable import LoginDemo_SwiftUI
import ViewInspector

final class LinkStyleButtonTests: XCTestCase {

    var sut: LinkStyleButton!

    override func setUpWithError() throws {
        sut = LinkStyleButton()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSignUpButtonInteraction_ShouldBeTappable() throws {
        // Arrange

        // Act
        /// Implementing ViewInspector way of traversing the hierarchy
        let inspectedView = try sut.inspect()
//        let signUpLinkButton = try inspectedView
//            .find(viewWithAccessibilityIdentifier: Constants.signUpButtonId)
//            .first
//        guard let signUpLinkButton = signUpLinkButton else {
//            XCTFail("Could not find 'Sign Up' button")
//            return
//        }

//        let button = try signUpLinkButton.button()
//        try button.tap()

        // Assert

        // TODO: need to mock the viewModel to achieve that
        XCTFail("Figure out how to assert the tap result on navigation")
    }

}
