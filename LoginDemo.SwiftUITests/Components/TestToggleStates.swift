//
//  TestToggleStates.swift
//  LoginDemo.SwiftUI
//
//  Created by Marcelo Mogrovejo on 25/5/2025.
//

import SwiftUI
import XCTest
import ViewInspector

// No @testable import needed for this simple, self-contained view

// MARK: Warning !
/* This isolated test has been created to figure out how .tap() works and why it is not working as expected, means, not changing the state of the text field when toggle
 */
final class ViewInspectorBasicToggleTest: XCTestCase {

    // Define a simple, self-contained SwiftUI View for testing basic toggle functionality
    struct SimpleToggleView: View {
        @State private var showContent: Bool = false // Internal @State

        var body: some View {
            VStack {
                Button("Toggle Content") {
                    showContent.toggle()
                }
                .accessibilityIdentifier("toggleButton")

                if showContent {
                    Text("Content is ON")
                        .accessibilityIdentifier("onContent")
                } else {
                    Text("Content is OFF")
                        .accessibilityIdentifier("offContent")
                }
            }
        }
    }

    @MainActor // Ensures the test runs on the main thread, required by ViewInspector
    func testBasicToggleFunctionality() throws {
        // Arrange: Create an instance of our simple view
        let sut = SimpleToggleView()

        // --- Initial Inspection ---
        // Use 'var' so we can reassign it after state changes
        var inspectedView = try sut.inspect()

        print("\n--- Basic Toggle Test: Initial State ---")
        // Assert initial state: "Content is OFF" should be visible
        XCTAssertNotNil(try? inspectedView.find(viewWithAccessibilityIdentifier: "offContent").first, "Initially, 'offContent' should be present")
        XCTAssertNil(try? inspectedView.find(viewWithAccessibilityIdentifier: "onContent").first, "Initially, 'onContent' should NOT be present")
        print("Initial 'offContent' presence: \( (try? inspectedView.find(viewWithAccessibilityIdentifier: "offContent").first) != nil ? "Present" : "Not Present")")
        print("Initial 'onContent' presence: \( (try? inspectedView.find(viewWithAccessibilityIdentifier: "onContent").first) != nil ? "Present" : "Not Present")")


        // --- ACT: Tap the button ---
        print("\n--- Basic Toggle Test: Tapping button ---")
//        let button = try inspectedView.find(button: "toggleButton")
        let buttonView = try? inspectedView
            .find(viewWithAccessibilityIdentifier: "toggleButton")
            .first
        try buttonView?.button().tap()

        // Expectation does not work
//        let expectation = XCTestExpectation(description: "View update")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.4)

        // --- RE-INSPECT THE VIEW HIERARCHY AFTER STATE CHANGE ---
        inspectedView = try sut.inspect() // Get a new snapshot of the view's state

        print("\n--- Basic Toggle Test: After First Tap ---")
        // Assert state after first tap: "Content is ON" should now be visible
        XCTAssertNil(try? inspectedView.find(viewWithAccessibilityIdentifier: "offContent").first, "After tap, 'offContent' should NOT be present")
        XCTAssertNotNil(try? inspectedView.find(viewWithAccessibilityIdentifier: "onContent").first, "After tap, 'onContent' should be present")
        print("After tap 'offContent' presence: \( (try? inspectedView.find(viewWithAccessibilityIdentifier: "offContent").first) != nil ? "Present" : "Not Present")")
        print("After tap 'onContent' presence: \( (try? inspectedView.find(viewWithAccessibilityIdentifier: "onContent").first) != nil ? "Present" : "Not Present")")


        // --- ACT: Tap the button again ---
        print("\n--- Basic Toggle Test: Tapping button again ---")
        try buttonView?.button().tap()

        // --- RE-INSPECT THE VIEW HIERARCHY AFTER STATE CHANGE ---
        inspectedView = try sut.inspect() // Get another new snapshot

        print("\n--- Basic Toggle Test: After Second Tap ---")
        // Assert state after second tap: "Content is OFF" should be visible again
        XCTAssertNotNil(try? inspectedView.find(viewWithAccessibilityIdentifier: "offContent").first, "After second tap, 'offContent' should be present again")
        XCTAssertNil(try? inspectedView.find(viewWithAccessibilityIdentifier: "onContent").first, "After second tap, 'onContent' should NOT be present again")
        print("After second tap 'offContent' presence: \( (try? inspectedView.find(viewWithAccessibilityIdentifier: "offContent").first) != nil ? "Present" : "Not Present")")
        print("After second tap 'onContent' presence: \( (try? inspectedView.find(viewWithAccessibilityIdentifier: "onContent").first) != nil ? "Present" : "Not Present")")
    }
}
