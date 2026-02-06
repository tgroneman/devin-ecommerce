import XCTest
import UIKit
@testable import E_Commerce_App_Project__Tabbed_

class TAPageControlTests: XCTestCase {

    func testPageControlCreation() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        XCTAssertNotNil(pageControl)
    }

    func testPageControlDefaultProperties() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        XCTAssertEqual(pageControl.numberOfPages, 0)
        XCTAssertEqual(pageControl.currentPage, 0)
        XCTAssertFalse(pageControl.hidesForSinglePage)
        XCTAssertTrue(pageControl.shouldResizeFromCenter)
    }

    func testSetNumberOfPages() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.numberOfPages = 5
        XCTAssertEqual(pageControl.numberOfPages, 5)
    }

    func testSetCurrentPage() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.numberOfPages = 5
        pageControl.currentPage = 2
        XCTAssertEqual(pageControl.currentPage, 2)
    }

    func testCurrentPageBeyondRange() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.numberOfPages = 0
        pageControl.currentPage = 5
        XCTAssertEqual(pageControl.currentPage, 5)
    }

    func testSizeForNumberOfPages() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let size = pageControl.sizeForNumberOfPages(3)
        XCTAssertTrue(size.width > 0)
        XCTAssertTrue(size.height > 0)
    }

    func testSizeForZeroPages() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let size = pageControl.sizeForNumberOfPages(0)
        XCTAssertTrue(size.width <= 0)
    }

    func testDotSize() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.dotSize = CGSize(width: 20, height: 20)
        XCTAssertEqual(pageControl.dotSize.width, 20)
        XCTAssertEqual(pageControl.dotSize.height, 20)
    }

    func testSpacingBetweenDots() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.spacingBetweenDots = 12
        XCTAssertEqual(pageControl.spacingBetweenDots, 12)
    }

    func testHidesForSinglePage() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = 1
        XCTAssertTrue(pageControl.isHidden)
    }

    func testDoesNotHideForMultiplePages() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = 3
        XCTAssertFalse(pageControl.isHidden)
    }

    func testSizeToFit() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.numberOfPages = 5
        pageControl.sizeToFit()
        XCTAssertTrue(pageControl.frame.width > 0)
    }

    func testDotViewClassDefault() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        XCTAssertNotNil(pageControl.dotViewClass)
    }

    func testSetDotImage() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let image = UIImage()
        pageControl.dotImage = image
        XCTAssertNotNil(pageControl.dotImage)
    }

    func testSetCurrentDotImage() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        let image = UIImage()
        pageControl.currentDotImage = image
        XCTAssertNotNil(pageControl.currentDotImage)
    }

    func testPageControlWithDotImages() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.dotImage = UIImage()
        pageControl.currentDotImage = UIImage()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        XCTAssertEqual(pageControl.currentPage, 1)
    }

    func testSamePageNoChange() {
        let pageControl = TAPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        pageControl.currentPage = 1
        XCTAssertEqual(pageControl.currentPage, 1)
    }
}

class TADotViewTests: XCTestCase {

    func testDotViewCreation() {
        let dotView = TADotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        XCTAssertNotNil(dotView)
    }

    func testDotViewCornerRadius() {
        let dotView = TADotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        XCTAssertEqual(dotView.layer.cornerRadius, 10)
    }

    func testDotViewActiveState() {
        let dotView = TADotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        dotView.changeActivityState(true)
        XCTAssertNotNil(dotView.backgroundColor)
    }

    func testDotViewInactiveState() {
        let dotView = TADotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        dotView.changeActivityState(false)
        XCTAssertNotNil(dotView.backgroundColor)
    }

    func testDotViewToggleStates() {
        let dotView = TADotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        dotView.changeActivityState(true)
        let activeColor = dotView.backgroundColor
        dotView.changeActivityState(false)
        let inactiveColor = dotView.backgroundColor
        XCTAssertNotEqual(activeColor, inactiveColor)
    }
}

class TAAnimatedDotViewTests: XCTestCase {

    func testAnimatedDotViewCreation() {
        let dotView = TAAnimatedDotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        XCTAssertNotNil(dotView)
    }

    func testAnimatedDotViewSetup() {
        let dotView = TAAnimatedDotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        XCTAssertEqual(dotView.backgroundColor, .clear)
        XCTAssertEqual(dotView.layer.cornerRadius, 10)
        XCTAssertEqual(dotView.layer.borderWidth, 2)
    }

    func testAnimatedDotViewActiveState() {
        let dotView = TAAnimatedDotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        dotView.changeActivityState(true)
        XCTAssertNotNil(dotView)
    }

    func testAnimatedDotViewInactiveState() {
        let dotView = TAAnimatedDotView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        dotView.changeActivityState(false)
        XCTAssertNotNil(dotView)
    }
}
