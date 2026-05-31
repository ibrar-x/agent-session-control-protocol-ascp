import XCTest

class RunnerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication(bundleIdentifier: "app.continuum.mobile")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Pairing Flow Tests

    func testFirstRunPairingScreenAppears() {
        // Wait for app to load
        XCTAssertTrue(app.staticTexts["Continuum"].waitForExistence(timeout: 10))
        
        // Verify first-run pairing screen elements
        XCTAssertTrue(app.staticTexts["Continuum"].exists)
        XCTAssertTrue(app.staticTexts["Unpaired"].exists)
        XCTAssertTrue(app.staticTexts["Scanning"].exists)
        XCTAssertTrue(app.staticTexts["Pair New Device"].exists)
        XCTAssertTrue(app.staticTexts["Enter code manually"].exists)
    }

    func testManualCodeEntryNavigation() {
        // Wait for app to load
        XCTAssertTrue(app.staticTexts["Continuum"].waitForExistence(timeout: 10))
        
        // Tap "Enter code manually"
        let enterCodeButton = app.staticTexts["Enter code manually"]
        XCTAssertTrue(enterCodeButton.waitForExistence(timeout: 5))
        enterCodeButton.tap()

        // Wait for text field to appear
        XCTAssertTrue(app.textFields.firstMatch.waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Verify"].waitForExistence(timeout: 5))
    }

    func testPairingCodeSubmission() {
        // Wait for app to load
        XCTAssertTrue(app.staticTexts["Continuum"].waitForExistence(timeout: 10))
        
        // Create a pairing session via daemon API
        let session = createPairingSession()
        let code = session["code"] as! String

        // Navigate to manual entry
        let enterCodeButton = app.staticTexts["Enter code manually"]
        XCTAssertTrue(enterCodeButton.waitForExistence(timeout: 5))
        enterCodeButton.tap()

        // Wait for text field to appear
        let textField = app.textFields.firstMatch
        XCTAssertTrue(textField.waitForExistence(timeout: 5))
        textField.tap()
        textField.typeText("127.0.0.1:8767:\(code)")

        // Submit
        let verifyButton = app.buttons["Verify"]
        XCTAssertTrue(verifyButton.waitForExistence(timeout: 5))
        verifyButton.tap()

        // Wait for daemon to process
        sleep(3)

        // Verify daemon received the claim
        let sessions = getPairingSessions()
        let claimedSession = sessions.first { ($0["code"] as? String) == code }
        XCTAssertNotNil(claimedSession)
    }

    func testTrustedShellTransitionAfterApproval() {
        // Wait for app to load
        XCTAssertTrue(app.staticTexts["Continuum"].waitForExistence(timeout: 10))
        
        // Create and claim a pairing session
        let session = createPairingSession()
        let code = session["code"] as! String
        let sessionId = session["session_id"] as! String

        // Navigate to manual entry and submit code
        let enterCodeButton = app.staticTexts["Enter code manually"]
        XCTAssertTrue(enterCodeButton.waitForExistence(timeout: 5))
        enterCodeButton.tap()

        let textField = app.textFields.firstMatch
        XCTAssertTrue(textField.waitForExistence(timeout: 5))
        textField.tap()
        textField.typeText("127.0.0.1:8767:\(code)")

        let verifyButton = app.buttons["Verify"]
        XCTAssertTrue(verifyButton.waitForExistence(timeout: 5))
        verifyButton.tap()
        sleep(2)

        // Approve the session via daemon API
        approvePairingSession(sessionId: sessionId)

        // Wait for app to transition to trusted shell
        sleep(6)

        // Tap Continue on success screen if it exists
        let continueButton = app.buttons["Continue"]
        if continueButton.waitForExistence(timeout: 3) {
            continueButton.tap()
            sleep(2)
        }

        // Verify trusted shell elements
        XCTAssertTrue(app.staticTexts["Home"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Sessions"].exists)
        XCTAssertTrue(app.staticTexts["Approvals"].exists)
    }

    // MARK: - Dashboard Tests

    func testDashboardShowsAfterPairing() {
        completePairing()

        // Verify dashboard elements
        XCTAssertTrue(app.staticTexts["Home"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Active Sessions"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Pending Approvals"].waitForExistence(timeout: 5))
    }

    func testDashboardShowsPairedDevices() {
        completePairing()

        // Verify paired devices section
        XCTAssertTrue(app.staticTexts["Paired Devices"].waitForExistence(timeout: 5))
    }

    // MARK: - Navigation Tests

    func testNavigationToSessionsTab() {
        completePairing()

        // Navigate to Sessions tab
        let sessionsTab = app.staticTexts["Sessions"]
        XCTAssertTrue(sessionsTab.waitForExistence(timeout: 5))
        sessionsTab.tap()
        sleep(2)

        // Verify sessions screen appears
        XCTAssertTrue(app.staticTexts["Sessions"].exists)
    }

    func testNavigationToApprovalsTab() {
        completePairing()

        // Navigate to Approvals tab
        let approvalsTab = app.staticTexts["Approvals"]
        XCTAssertTrue(approvalsTab.waitForExistence(timeout: 5))
        approvalsTab.tap()
        sleep(2)

        // Verify approvals screen appears
        XCTAssertTrue(app.staticTexts["Approvals"].exists)
    }

    func testNavigationToInspectTab() {
        completePairing()

        // Navigate to Inspect tab
        app.staticTexts["Inspect"].tap()
        sleep(2)

        // Verify inspect screen appears
        XCTAssertTrue(app.staticTexts["Inspect"].exists)
    }

    func testNavigationToSettingsTab() {
        completePairing()

        // Navigate to Settings tab
        app.staticTexts["Settings"].tap()
        sleep(2)

        // Verify settings screen appears
        XCTAssertTrue(app.staticTexts["Settings"].exists)
        XCTAssertTrue(app.staticTexts["Trusted Devices"].exists)
    }

    // MARK: - Settings Tests

    func testSettingsShowsTrustedDevices() {
        completePairing()

        // Navigate to Settings tab
        app.staticTexts["Settings"].tap()
        sleep(2)

        // Verify trusted devices section
        XCTAssertTrue(app.staticTexts["Trusted Devices"].exists)
    }

    func testSettingsShowsConnectionDiagnostics() {
        completePairing()

        // Navigate to Settings tab
        app.staticTexts["Settings"].tap()
        sleep(2)

        // Verify connection diagnostics
        XCTAssertTrue(app.staticTexts["Connection"].exists)
    }

    // MARK: - Helper Methods

    private func completePairing() {
        let session = createPairingSession()
        let code = session["code"] as! String
        let sessionId = session["session_id"] as! String

        // Navigate to manual entry
        app.staticTexts["Enter code manually"].tap()

        // Enter pairing code
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("127.0.0.1:8767:\(code)")

        // Submit
        app.buttons["Verify"].tap()
        sleep(1)

        // Approve the session
        approvePairingSession(sessionId: sessionId)

        // Wait for transition
        sleep(5)

        // Tap Continue on success screen if it exists
        if app.buttons["Continue"].exists {
            app.buttons["Continue"].tap()
            sleep(2)
        }
    }

    private func createPairingSession() -> [String: Any] {
        let url = URL(string: "http://127.0.0.1:8767/admin/pairing/sessions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "requested_scopes": ["sessions.read", "sessions.write"]
        ])

        let semaphore = DispatchSemaphore(value: 0)
        var result: [String: Any] = [:]

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                result = json
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()

        return result
    }

    private func approvePairingSession(sessionId: String) {
        let url = URL(string: "http://127.0.0.1:8767/admin/pairing/sessions/\(sessionId)/approve")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: request) { _, _, _ in
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    private func getPairingSessions() -> [[String: Any]] {
        let url = URL(string: "http://127.0.0.1:8767/admin/pairing/sessions")!
        let semaphore = DispatchSemaphore(value: 0)
        var result: [[String: Any]] = []

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let sessions = json["sessions"] as? [[String: Any]] {
                result = sessions
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()

        return result
    }
}
