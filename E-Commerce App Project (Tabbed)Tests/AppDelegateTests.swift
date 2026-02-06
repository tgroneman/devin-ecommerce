import XCTest
import UIKit
@testable import E_Commerce_App_Project__Tabbed_

class AppDelegateTests: XCTestCase {

    func testAppDelegateCreation() {
        let appDelegate = AppDelegate()
        XCTAssertNotNil(appDelegate)
    }

    func testApplicationDidFinishLaunching() {
        let appDelegate = AppDelegate()
        let result = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(result)
    }

    func testApplicationWillResignActive() {
        let appDelegate = AppDelegate()
        appDelegate.applicationWillResignActive(UIApplication.shared)
        XCTAssertNotNil(appDelegate)
    }

    func testApplicationDidEnterBackground() {
        let appDelegate = AppDelegate()
        appDelegate.applicationDidEnterBackground(UIApplication.shared)
        XCTAssertNotNil(appDelegate)
    }

    func testApplicationWillEnterForeground() {
        let appDelegate = AppDelegate()
        appDelegate.applicationWillEnterForeground(UIApplication.shared)
        XCTAssertNotNil(appDelegate)
    }

    func testApplicationDidBecomeActive() {
        let appDelegate = AppDelegate()
        appDelegate.applicationDidBecomeActive(UIApplication.shared)
        XCTAssertNotNil(appDelegate)
    }

    func testApplicationWillTerminate() {
        let appDelegate = AppDelegate()
        appDelegate.applicationWillTerminate(UIApplication.shared)
        XCTAssertNotNil(appDelegate)
    }

    func testWindowProperty() {
        let appDelegate = AppDelegate()
        XCTAssertNil(appDelegate.window)
        appDelegate.window = UIWindow()
        XCTAssertNotNil(appDelegate.window)
    }
}

class ViewControllerBaseTests: XCTestCase {

    func testViewControllerCreation() {
        let vc = ViewController()
        XCTAssertNotNil(vc)
    }

    func testViewControllerViewDidLoad() {
        let vc = ViewController()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }
}
