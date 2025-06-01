//
//  IsolatedButtonTests.swift
//  LoginDemo.SwiftUIUITests
//
//  Created by Marcelo Mogrovejo on 29/5/2025.
//

// Source: https://smashswift.com/how-to-test-buttons-in-ui-tests-in-swiftui/

import XCTest

final class IsolatedButtonTests: XCTestCase {

    var sut: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        sut = XCUIApplication()
        sut.launch()
    }

    override func tearDownWithError() throws {
        sut.terminate()
        sut = nil
    }

    @MainActor
    func testTempView_EyeButtonShouldToggle() throws {

//        static let visibleImageName: String = "eye.slash.fill"
//        static let visibleImageId: String = "show-image-id"
//        static let hiddenImageName: String = "eye.fill"
//        static let hiddenImageId: String = "hide-image-id"

        // Arrange
        let eyeButton = sut.buttons["eye-button-id"]
        let eyeSlashButtonImage = sut.images["show-image-id"]
        let eyeButtonImage = sut.images["hide-image-id"]

        // Assert: initial state
        XCTAssertTrue(eyeButton.waitForExistence(timeout: 2),
                      "Eye button should be present but it is not")
        XCTAssertTrue(eyeButton.isHittable,
                      "Eye button should be enabled but it is not")

        XCTAssertTrue(eyeSlashButtonImage.waitForExistence(timeout: 5),
                      "Eye slash button image should be present but it is not")
        XCTAssertTrue(eyeSlashButtonImage.isHittable,
                      "Eye slash button image should be enabled but it is not (password hidden)")
        XCTAssertFalse(eyeButtonImage.exists,
                      "Eye button image should not be present but it is")
        XCTAssertFalse(eyeButtonImage.isHittable,
                       "Eye button image should not be hittable initially (password hidden)")

        // Act
        eyeButton.tap()

        // Assert: state changes -> Password visible
        XCTAssertFalse(eyeSlashButtonImage.waitForExistence(timeout: 5),
                      "Eye slash button image should not be present but it is")
        XCTAssertFalse(eyeSlashButtonImage.isHittable,
                      "Eye slash button image should not be enabled but it is (password visible)")
        XCTAssertTrue(eyeButtonImage.exists,
                      "Eye button image should be present but it is not")
        XCTAssertTrue(eyeButtonImage.isHittable,
                      "Eye button image should be hittable but it is not (password visible)")

        // Act
        eyeButton.tap()

        // Assert: state changes -> Password hidden
        XCTAssertTrue(eyeSlashButtonImage.waitForExistence(timeout: 5),
                      "Eye slash button image should be present but it is not")
        XCTAssertTrue(eyeSlashButtonImage.isHittable,
                      "Eye slash button image should be enabled but it is not (password hidden)")
        XCTAssertFalse(eyeButtonImage.exists,
                      "Eye button image should not be present but it is")
        XCTAssertFalse(eyeButtonImage.isHittable,
                      "Eye button image should not be hittable but it is (password hidden)")
    }

    @MainActor
    func testTempView_ClickMeButtonShouldTap() throws {
        sut.buttons["Click me!"].tap()
    }

    @MainActor
    func testTempView_StartButtonShouldTap() throws {
        sut.buttons["star"].tap()

        // MARK: - here the test is working fine. But if i move the tap() line after the XCTAssertTrue, it fails.
        XCTAssertTrue(sut.buttons["star"].exists,
                      "Start button image should exist")
    }

    // MARK: -
    /*
     The Key Difference: tap() Has an Implicit Wait, exists Does Not
     sut.buttons["star"].tap() (when called first):

     The tap() method is an action. When you call tap() on an XCUIElement, XCUITest has an implicit waiting mechanism built into it.
     It will wait for a certain period (Xcode's default timeout, often around 10 seconds) for the element to become exists AND isHittable before attempting the tap.
     Because your app has just launched (sut.launch()), the UI elements might not be immediately available in the accessibility tree or fully rendered. The tap() call effectively waits for the "star" button (found by its default accessibilityLabel) to appear and become interactive. Once it's hittable, it taps it, and then your subsequent XCTAssertTrue(sut.buttons["star"].exists) correctly finds it because it's now fully present.
     XCTAssertTrue(sut.buttons["star"].exists) (when called first, leading to failure):

     The exists property is a synchronous property check. It immediately queries the current state of the accessibility tree at the exact moment the line of code is executed.
     If your app has just launched (sut.launch()), there's a very brief but critical period where the UI is still drawing, views are being laid out, and accessibility elements are being registered.
     If the "star" button hasn't been fully registered in the accessibility tree by the time XCTAssertTrue(sut.buttons["star"].exists) is evaluated, exists will return false, causing your assertion to fail. The tap() line is never even reached.
     In essence: tap() is "smarter" and more resilient to initial UI loading delays because it waits. exists (when used directly in an XCTAssertTrue) is a "snapshot" check and will fail if the element isn't immediately ready.

     The Solution: Always Wait for Existence/Hittability
     */
    @MainActor
    func testTempView_StartButtonImageShouldExist() throws {
        let startButton = sut.buttons["star"]

        XCTAssertTrue(startButton.waitForExistence(timeout: 5),
                      "Start button image should exist")

        startButton.tap()
    }

    @MainActor
    func testTempView_VStackButtonShouldTap() throws {
        sut.buttons["Click me again!"].tap()
    }

    @MainActor
    func testTempView_NewVStackButtonShouldTap() throws {
        sut.buttons["ViewWithTwoImagesAndText"].tap()

        print(sut.buttons) // prints: <XCUIElementQuery: 0x600002119360>
    }

    @MainActor
    func testTemView_ImagesOnButtonShouldExist() throws {
        // That doesn't work
//        let eyeImage = sut.buttons["eye"]
//        let eyeFillImage = sut.buttons["eye.fill"]

        // That works
//        let eyeImage = sut.images["eye"]
//        let eyeFillImage = sut.images["eye.fill"]

//        .accessibilityIdentifier("eye-image-id")
//        .accessibilityIdentifier("eye--fill-image-id")
        // Tat doesn't work
//        let eyeImage = sut.buttons["eye-image-id"]
//        let eyeFillImage = sut.buttons["eye--fill-image-id"]

        // That works
        let eyeImage = sut.images["eye-image-id"]
        let eyeFillImage = sut.images["eye-fill-image-id"]


        XCTAssertTrue(eyeImage.waitForExistence(timeout: 5), "Eye image should exist")
        XCTAssertTrue(eyeFillImage.exists, "Eye fill image should exist")
    }

}
