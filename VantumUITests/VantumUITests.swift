import XCTest

final class VantumUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testShellInteractionFlow() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 5))

        app.buttons["refreshButton"].tap()
        app.buttons["startSetupButton"].tap()

        let nameField = app.textFields["athleteNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText("Avery")

        app.segmentedControls.buttons["Conditioning"].tap()
        app.switches["notificationsToggle"].tap()
        app.buttons["saveOnboardingButton"].tap()

        app.tabBars.buttons["Trends"].tap()
        app.segmentedControls.buttons["Resting"].tap()

        app.tabBars.buttons["Plan"].tap()
        app.segmentedControls.buttons["Recovery"].tap()
        app.switches["deloadToggle"].tap()

        app.tabBars.buttons["Settings"].tap()
        app.switches["reminderToggle"].tap()
        app.buttons["reviewSetupButton"].tap()
        app.buttons["closeOnboardingButton"].tap()
        app.buttons["resetPreviewButton"].tap()
        app.buttons["Cancel"].tap()
    }
}
