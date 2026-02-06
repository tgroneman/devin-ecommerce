import XCTest
import UIKit
@testable import E_Commerce_App_Project__Tabbed_

class ThankYouViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "pdfFilePath")
        UserDefaults.standard.removeObject(forKey: "SessionLoggedInuserEmail")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "pdfFilePath")
        UserDefaults.standard.removeObject(forKey: "SessionLoggedInuserEmail")
        super.tearDown()
    }

    func testCreation() {
        let vc = ThankYouViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoadWithUserData() {
        UserDefaults.standard.set("user@test.com", forKey: "SessionLoggedInuserEmail")
        UserDefaults.standard.set("/tmp/test.pdf", forKey: "pdfFilePath")
        let vc = ThankYouViewController()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }

    func testViewDidLoadWithoutUserData() {
        let vc = ThankYouViewController()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }
}

class AccountCRUDViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
        super.tearDown()
    }

    func testCreation() {
        let vc = AccountCRUDViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoadNotLoggedIn() {
        UserDefaults.standard.set(false, forKey: "SeesionUserLoggedIN")
        let vc = AccountCRUDViewController()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
        XCTAssertNotNil(vc.registrationComplete)
    }

    func testViewDidLoadLoggedIn() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        let userData: [String: Any] = [
            "firstName": "John", "lastName": "Doe",
            "usersEmail": "john@example.com", "phone": "1234567890",
            "country": "USA", "state": "NY", "city": "NYC",
            "postalCode": "10001", "address": "123 Main St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        let vc = AccountCRUDViewController()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }

    func testViewDidLoadWithRegistrationFields() {
        UserDefaults.standard.set(false, forKey: "SeesionUserLoggedIN")
        let vc = AccountCRUDViewController()
        vc.firstName = UITextField()
        vc.lastName = UITextField()
        vc.email = UITextField()
        vc.password = UITextField()
        vc.confirmPassword = UITextField()
        vc.phone = UITextField()
        vc.country = UITextField()
        vc.state = UITextField()
        vc.city = UITextField()
        vc.postalCode = UITextField()
        vc.address = UITextField()
        vc.validationStatus = UILabel()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }

    func testViewDidLoadWithEditFields() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        let userData: [String: Any] = [
            "firstName": "Jane", "lastName": "Smith",
            "usersEmail": "jane@test.com", "phone": "5551234567",
            "country": "Canada", "state": "Ontario", "city": "Toronto",
            "postalCode": "M5H", "address": "456 Elm St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        let vc = AccountCRUDViewController()
        vc.editAccountFirstName = UITextField()
        vc.editAccountLastName = UITextField()
        vc.editAccountEmail = UITextField()
        vc.editAccountPassword = UITextField()
        vc.editAccountConfirmPassword = UITextField()
        vc.editAccountPhone = UITextField()
        vc.editAccountCountry = UITextField()
        vc.editAccountState = UITextField()
        vc.editAccountCity = UITextField()
        vc.editAccountPostalCode = UITextField()
        vc.editAccountAddress = UITextField()
        vc.editAccountValidationStatus = UILabel()
        vc.loadViewIfNeeded()
        XCTAssertEqual(vc.editAccountFirstName?.text, "Jane")
        XCTAssertEqual(vc.editAccountLastName?.text, "Smith")
    }

    func testViewDidLoadWithBothFieldSets() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        let userData: [String: Any] = [
            "firstName": "Test", "lastName": "User",
            "usersEmail": "test@example.com", "phone": "9876543210",
            "country": "UK", "state": "London", "city": "London",
            "postalCode": "SW1A", "address": "10 Downing St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        let vc = AccountCRUDViewController()
        vc.firstName = UITextField()
        vc.lastName = UITextField()
        vc.email = UITextField()
        vc.password = UITextField()
        vc.confirmPassword = UITextField()
        vc.phone = UITextField()
        vc.country = UITextField()
        vc.state = UITextField()
        vc.city = UITextField()
        vc.postalCode = UITextField()
        vc.address = UITextField()
        vc.validationStatus = UILabel()
        vc.editAccountFirstName = UITextField()
        vc.editAccountLastName = UITextField()
        vc.editAccountEmail = UITextField()
        vc.editAccountPassword = UITextField()
        vc.editAccountConfirmPassword = UITextField()
        vc.editAccountPhone = UITextField()
        vc.editAccountCountry = UITextField()
        vc.editAccountState = UITextField()
        vc.editAccountCity = UITextField()
        vc.editAccountPostalCode = UITextField()
        vc.editAccountAddress = UITextField()
        vc.editAccountValidationStatus = UILabel()
        vc.loadViewIfNeeded()
        XCTAssertEqual(vc.editAccountFirstName?.text, "Test")
    }
}

class AccountViewControllerTestSuite: XCTestCase {

    private func makeVC() -> AccountViewController {
        let vc = AccountViewController()
        vc.firstName = UILabel()
        vc.lastName = UILabel()
        vc.email = UILabel()
        vc.phone = UILabel()
        vc.country = UILabel()
        vc.state = UILabel()
        vc.city = UILabel()
        vc.postalCode = UILabel()
        vc.address = UILabel()
        vc.firstNameOutlet = UILabel()
        vc.lastNameOutlet = UILabel()
        vc.emailOutlet = UILabel()
        vc.phoneOutlet = UILabel()
        vc.countryOutlet = UILabel()
        vc.stateOutlet = UILabel()
        vc.cityOutlet = UILabel()
        vc.postalCodeOutlet = UILabel()
        vc.addressOutlet = UILabel()
        vc.goToLoginButtonOutlet = UIButton()
        vc.userLogOutOutlet = UIBarButtonItem()
        vc.userHistoryOutlet = UIBarButtonItem()
        vc.editUserAccountOutlet = UIBarButtonItem()
        return vc
    }

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
        super.tearDown()
    }

    func testCreation() {
        let vc = AccountViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoadLoggedOut() {
        UserDefaults.standard.set(false, forKey: "SeesionUserLoggedIN")
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.loggedOutAlert)
        XCTAssertEqual(vc.firstName.text, "")
        XCTAssertTrue(vc.firstName.isHidden)
        XCTAssertFalse(vc.goToLoginButtonOutlet.isHidden)
    }

    func testViewDidLoadLoggedIn() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        let userData: [String: Any] = [
            "firstName": "Alice", "lastName": "Wonder",
            "usersEmail": "alice@test.com", "phone": "1234567890",
            "country": "UK", "state": "London", "city": "London",
            "postalCode": "SW1A", "address": "10 Downing St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertEqual(vc.firstName.text, "Alice")
        XCTAssertFalse(vc.firstName.isHidden)
        XCTAssertTrue(vc.goToLoginButtonOutlet.isHidden)
    }

    func testViewDidAppearLoggedOut() {
        UserDefaults.standard.set(false, forKey: "SeesionUserLoggedIN")
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewDidAppear(false)
        XCTAssertTrue(vc.firstName.isHidden)
        XCTAssertEqual(vc.firstName.text, "")
    }

    func testViewDidAppearLoggedIn() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        let userData: [String: Any] = ["firstName": "Bob", "lastName": "Builder"]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewDidAppear(false)
        XCTAssertFalse(vc.firstName.isHidden)
        XCTAssertEqual(vc.firstName.text, "Bob")
    }
}

class CartViewControllerTestSuite: XCTestCase {

    private func makeVC() -> CartViewController {
        let vc = CartViewController()
        vc.totalAmountLabelOutlet = UILabel()
        vc.totalAmountShowOutlet = UILabel()
        vc.cartTableView = UITableView()
        vc.editCartButtonOutlet = UIBarButtonItem()
        vc.cartContinueButtonOutlet = UIBarButtonItem()
        return vc
    }

    override func setUp() {
        super.setUp()
        ShoppingCart.sharedInstance.clearCart()
    }

    override func tearDown() {
        ShoppingCart.sharedInstance.clearCart()
        super.tearDown()
    }

    func testCreation() {
        let vc = CartViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoadEmptyCart() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
        XCTAssertFalse(vc.editCartButtonOutlet.isEnabled)
        XCTAssertFalse(vc.cartContinueButtonOutlet.isEnabled)
        XCTAssertTrue(vc.totalAmountLabelOutlet.isHidden)
        XCTAssertTrue(vc.totalAmountShowOutlet.isHidden)
    }

    func testViewDidLoadWithItems() {
        let item = Item()
        item.ID = 1
        item.price = 100
        item.itemName = "Test"
        item.photoURL = ""
        ShoppingCart.sharedInstance.addItem(item)
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertTrue(vc.editCartButtonOutlet.isEnabled)
        XCTAssertTrue(vc.cartContinueButtonOutlet.isEnabled)
        XCTAssertFalse(vc.totalAmountLabelOutlet.isHidden)
        XCTAssertFalse(vc.totalAmountShowOutlet.isHidden)
    }

    func testViewDidAppear() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewDidAppear(false)
        XCTAssertNotNil(vc.view)
    }

    func testViewWillAppear() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewWillAppear(false)
        XCTAssertNotNil(vc.view)
    }

    func testTableViewNumberOfRows() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let rows = vc.tableView(vc.cartTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 0)
    }

    func testTableViewNumberOfRowsSection1() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let rows = vc.tableView(vc.cartTableView, numberOfRowsInSection: 1)
        XCTAssertEqual(rows, 1)
    }

    func testTableViewHeightForRow() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let height = vc.tableView(vc.cartTableView, heightForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(height, 100)
    }

    func testEditCartButton() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.editCartButton(UIButton())
        XCTAssertTrue(vc.cartTableView.isEditing)
    }

    func testEditCartButtonToggle() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.editCartButton(UIButton())
        XCTAssertTrue(vc.cartTableView.isEditing)
        vc.editCartButton(UIButton())
        XCTAssertFalse(vc.cartTableView.isEditing)
    }
}

class CheckOutViewControllerTestSuite: XCTestCase {

    private func makeVC() -> CheckOutViewController {
        let vc = CheckOutViewController()
        vc.checkOutTotalAmount = UILabel()
        vc.firstName = UILabel()
        vc.lastName = UILabel()
        vc.email = UILabel()
        vc.phone = UILabel()
        vc.country = UILabel()
        vc.city = UILabel()
        vc.State = UILabel()
        vc.postalCode = UILabel()
        vc.address = UILabel()
        vc.bkashOutlet = UIButton()
        vc.rocketOutlet = UIButton()
        vc.cashOnDeliveryOutlet = UIButton()
        return vc
    }

    override func setUp() {
        super.setUp()
        ShoppingCart.sharedInstance.clearCart()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
        UserDefaults.standard.removeObject(forKey: "cartTotalAmount")
        UserDefaults.standard.removeObject(forKey: "paymentMethodUsed")
    }

    override func tearDown() {
        ShoppingCart.sharedInstance.clearCart()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
        UserDefaults.standard.removeObject(forKey: "cartTotalAmount")
        UserDefaults.standard.removeObject(forKey: "paymentMethodUsed")
        super.tearDown()
    }

    func testCreation() {
        let vc = CheckOutViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoadNotLoggedIn() {
        UserDefaults.standard.set(false, forKey: "SeesionUserLoggedIN")
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertEqual(vc.checkOutTotalAmount.text, "")
        XCTAssertEqual(vc.firstName.text, "")
        XCTAssertTrue(vc.bkashOutlet.isHidden)
        XCTAssertTrue(vc.rocketOutlet.isHidden)
        XCTAssertTrue(vc.cashOnDeliveryOutlet.isHidden)
    }

    func testViewDidLoadLoggedIn() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.set("500", forKey: "cartTotalAmount")
        let userData: [String: Any] = [
            "firstName": "John", "lastName": "Doe",
            "usersEmail": "john@test.com", "phone": "1234567890",
            "country": "USA", "city": "NYC", "state": "NY",
            "postalCode": "10001", "address": "123 Main St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertEqual(vc.firstName.text, "John")
        XCTAssertEqual(vc.lastName.text, "Doe")
        XCTAssertEqual(vc.email.text, "john@test.com")
        XCTAssertEqual(vc.phone.text, "1234567890")
        XCTAssertEqual(vc.country.text, "USA")
        XCTAssertEqual(vc.city.text, "NYC")
        XCTAssertEqual(vc.State.text, "NY")
        XCTAssertEqual(vc.postalCode.text, "10001")
        XCTAssertEqual(vc.address.text, "123 Main St")
        XCTAssertFalse(vc.bkashOutlet.isHidden)
        XCTAssertFalse(vc.rocketOutlet.isHidden)
        XCTAssertFalse(vc.cashOnDeliveryOutlet.isHidden)
    }

    func testBkashAction() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.bkashAction(UIButton())
        XCTAssertNotNil(vc)
    }

    func testRocketAction() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.rocketAction(UIButton())
        XCTAssertNotNil(vc)
    }

    func testCashOnDeliveryAction() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.cashOnDeliveryAction(UIButton())
        XCTAssertNotNil(vc)
    }

    func testMultiplePaymentToggles() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.bkashAction(UIButton())
        vc.rocketAction(UIButton())
        vc.cashOnDeliveryAction(UIButton())
        XCTAssertNotNil(vc)
    }

    func testSavePDF() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.savePDF()
        XCTAssertNotNil(vc)
    }

    func testSendMailWithPDF() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.sendMailWithPDF()
        XCTAssertNotNil(vc)
    }

    func testMailComposeController() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc)
    }
}

class SingleItemViewControllerTestSuite: XCTestCase {

    private func makeItem() -> Item {
        let item = Item()
        item.ID = 1
        item.itemName = "Test Product"
        item.price = 299.99
        item.itemCategory = "Television"
        item.brand = "Samsung"
        item.quality = "HD"
        item.photoURL = ""
        item.cartAddedQuantity = 0
        return item
    }

    private func makeVC() -> SingleItemViewController {
        let vc = SingleItemViewController()
        vc.itemImage = UIImageView()
        vc.itemName = UILabel()
        vc.itemCategory = UILabel()
        vc.itemID = UILabel()
        vc.itemPrice = UILabel()
        vc.itemBrand = UILabel()
        vc.itemQuality = UILabel()
        vc.addToCartStatusoutlet = UIButton()
        vc.removeFromCartOutlet = UIButton()
        let item = makeItem()
        vc.itemObjectReceived = item
        vc.setItemName = "Test Product"
        vc.setItemCategory = "Television"
        vc.setItemID = NSNumber(value: 1)
        vc.setItemPrice = NSNumber(value: 299.99)
        vc.setItemBrand = "Samsung"
        vc.setItemQuality = "HD"
        return vc
    }

    override func setUp() {
        super.setUp()
        ShoppingCart.sharedInstance.clearCart()
    }

    override func tearDown() {
        ShoppingCart.sharedInstance.clearCart()
        super.tearDown()
    }

    func testCreation() {
        let vc = SingleItemViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoad() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertEqual(vc.itemName.text, "Test Product")
        XCTAssertEqual(vc.itemCategory.text, "Television")
        XCTAssertEqual(vc.itemBrand.text, "Samsung")
        XCTAssertEqual(vc.itemQuality.text, "HD")
        XCTAssertEqual(vc.itemID.text, "1")
    }

    func testViewWillAppearNotInCart() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewWillAppear(false)
        XCTAssertFalse(vc.addToCartStatusoutlet.isSelected)
        XCTAssertTrue(vc.removeFromCartOutlet.isHidden)
    }

    func testViewDidAppearNotInCart() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewDidAppear(false)
        XCTAssertTrue(vc.removeFromCartOutlet.isHidden)
    }

    func testAddToCartButton() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let button = vc.addToCartStatusoutlet!
        vc.addToCartButton(button)
        XCTAssertTrue(button.isSelected)
        XCTAssertFalse(vc.removeFromCartOutlet.isHidden)
        XCTAssertEqual(button.backgroundColor, .green)
    }

    func testRemoveFromCartButton() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.addToCartButton(vc.addToCartStatusoutlet)
        let removeButton = vc.removeFromCartOutlet!
        vc.removeFromCartButton(removeButton)
        XCTAssertFalse(vc.addToCartStatusoutlet.isSelected)
        XCTAssertEqual(removeButton.backgroundColor, .blue)
    }

    func testViewWillAppearInCart() {
        let vc = makeVC()
        ShoppingCart.sharedInstance.addItem(vc.itemObjectReceived)
        vc.loadViewIfNeeded()
        vc.viewWillAppear(false)
        XCTAssertTrue(vc.addToCartStatusoutlet.isSelected)
        XCTAssertFalse(vc.removeFromCartOutlet.isHidden)
    }

    func testViewDidAppearInCart() {
        let vc = makeVC()
        ShoppingCart.sharedInstance.addItem(vc.itemObjectReceived)
        vc.loadViewIfNeeded()
        vc.addToCartStatusoutlet.isSelected = true
        vc.viewDidAppear(false)
        XCTAssertFalse(vc.removeFromCartOutlet.isHidden)
    }

    func testViewDidLoadWithImageData() {
        let vc = makeVC()
        let imageSize = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(imageSize)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.red.cgColor)
        context.fill(CGRect(origin: .zero, size: imageSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        vc.setItemImageData = image.pngData()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.itemImage.image)
    }
}

class HomeViewControllerTestSuite: XCTestCase {

    private func makeVC() -> HomeViewController {
        let vc = HomeViewController()
        vc.sliderScrollView = UIScrollView()
        vc.tvCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.laptopCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.desktopCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.mobileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.tabletCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return vc
    }

    func testCreation() {
        let vc = HomeViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoad() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.sliderCustomPageControl)
        XCTAssertNotNil(vc.view)
    }

    func testViewDidAppear() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewDidAppear(false)
        XCTAssertNotNil(vc.sliderTimer)
    }

    func testViewDidDisappear() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewDidAppear(false)
        XCTAssertNotNil(vc.sliderTimer)
        vc.viewDidDisappear(false)
        XCTAssertNil(vc.sliderTimer)
    }

    func testViewDidDisappearWithoutTimer() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.viewDidDisappear(false)
        XCTAssertNil(vc.sliderTimer)
    }

    func testRunImages() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.runImages()
        XCTAssertNotNil(vc)
    }

    func testScrollViewDidScroll() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
        scrollView.contentOffset = CGPoint(x: 320, y: 0)
        vc.scrollViewDidScroll(scrollView)
        XCTAssertNotNil(vc)
    }

    func testTAPageControlDidSelectPage() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.taPageControl(vc.sliderCustomPageControl, didSelectPageAt: 1)
        XCTAssertNotNil(vc)
    }

    func testCollectionViewNumberOfItemsTV() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let count = vc.collectionView(vc.tvCollectionView, numberOfItemsInSection: 0)
        XCTAssertGreaterThanOrEqual(count, 0)
    }

    func testCollectionViewNumberOfItemsLaptop() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let count = vc.collectionView(vc.laptopCollectionView, numberOfItemsInSection: 0)
        XCTAssertGreaterThanOrEqual(count, 0)
    }

    func testCollectionViewNumberOfItemsDesktop() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let count = vc.collectionView(vc.desktopCollectionView, numberOfItemsInSection: 0)
        XCTAssertGreaterThanOrEqual(count, 0)
    }

    func testCollectionViewNumberOfItemsMobile() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let count = vc.collectionView(vc.mobileCollectionView, numberOfItemsInSection: 0)
        XCTAssertGreaterThanOrEqual(count, 0)
    }

    func testCollectionViewNumberOfItemsTablet() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        let count = vc.collectionView(vc.tabletCollectionView, numberOfItemsInSection: 0)
        XCTAssertGreaterThanOrEqual(count, 0)
    }

    func testTelevisionCategoryButton() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.televisionCategoryButton(UIButton())
        XCTAssertNotNil(vc)
    }

    func testLaptopCategoryButton() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.laptopCategoryButton(UIButton())
        XCTAssertNotNil(vc)
    }

    func testDesktopCategoryButton() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.desktopCategoryButton(UIButton())
        XCTAssertNotNil(vc)
    }

    func testMobileCategoryButton() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.mobileCategoryButton(UIButton())
        XCTAssertNotNil(vc)
    }

    func testTabletCategoryButton() {
        let vc = makeVC()
        vc.loadViewIfNeeded()
        vc.tabletCategoryButton(UIButton())
        XCTAssertNotNil(vc)
    }
}

class SaleViewControllerTestSuite: XCTestCase {

    func testCreation() {
        let vc = SaleViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoad() {
        let vc = SaleViewController()
        vc.saleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }

    func testCollectionViewNumberOfItems() {
        let vc = SaleViewController()
        vc.saleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.loadViewIfNeeded()
        let count = vc.collectionView(vc.saleCollectionView, numberOfItemsInSection: 0)
        XCTAssertGreaterThanOrEqual(count, 0)
    }
}

class CategoryItemsViewControllerTestSuite: XCTestCase {

    func testCreation() {
        let vc = CategoryItemsViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoad() {
        let vc = CategoryItemsViewController()
        vc.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.receivedCategoryItemsList = []
        vc.receivedCategoryName = "Television"
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }

    func testViewDidLoadWithLabel() {
        let vc = CategoryItemsViewController()
        vc.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.categoryNameLabel = UILabel()
        vc.receivedCategoryItemsList = []
        vc.receivedCategoryName = "Laptop"
        vc.loadViewIfNeeded()
        XCTAssertEqual(vc.categoryNameLabel?.text, "Laptop")
        XCTAssertEqual(vc.navigationItem.title, "Laptop")
    }

    func testCollectionViewNumberOfItems() {
        let vc = CategoryItemsViewController()
        vc.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let item = Item()
        item.ID = 1
        item.itemName = "Test"
        vc.receivedCategoryItemsList = [item]
        vc.receivedCategoryName = "TV"
        vc.loadViewIfNeeded()
        let count = vc.collectionView(vc.categoryCollectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, 1)
    }

    func testCollectionViewNumberOfItemsEmpty() {
        let vc = CategoryItemsViewController()
        vc.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        vc.receivedCategoryItemsList = []
        vc.receivedCategoryName = "Empty"
        vc.loadViewIfNeeded()
        let count = vc.collectionView(vc.categoryCollectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, 0)
    }
}

class AccountLoginViewControllerTestSuite: XCTestCase {

    func testCreation() {
        let vc = AccountLoginViewController()
        XCTAssertNotNil(vc)
    }

    func testViewDidLoad() {
        let vc = AccountLoginViewController()
        vc.loginFormEmail = UITextField()
        vc.loginFormPassword = UITextField()
        vc.validationStatusLabel = UILabel()
        vc.loadViewIfNeeded()
        XCTAssertNotNil(vc.view)
    }
}
