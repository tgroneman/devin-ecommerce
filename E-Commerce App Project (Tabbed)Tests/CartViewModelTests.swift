import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class CartViewModelTests: XCTestCase {

    var viewModel: CartViewModel!
    var cart: ShoppingCart!

    override func setUp() {
        super.setUp()
        cart = ShoppingCart.sharedInstance
        cart.clearCart()
        viewModel = CartViewModel()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
    }

    override func tearDown() {
        cart.clearCart()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        viewModel = nil
        super.tearDown()
    }

    private func makeItem(id: Int = 1, name: String = "Test", price: Double = 100.0) -> Item {
        let item = Item()
        item.ID = NSNumber(value: id)
        item.itemName = name
        item.price = price
        item.cartAddedQuantity = 0
        return item
    }

    func testIsCartEmptyInitially() {
        XCTAssertTrue(viewModel.isCartEmpty)
    }

    func testIsCartEmptyAfterAddingItem() {
        let item = makeItem()
        cart.addItem(item)
        XCTAssertFalse(viewModel.isCartEmpty)
    }

    func testCartItems() {
        let item = makeItem()
        cart.addItem(item)
        XCTAssertEqual(viewModel.cartItems.count, 1)
    }

    func testNumberOfCartItems() {
        XCTAssertEqual(viewModel.numberOfCartItems, 0)
        let item = makeItem()
        cart.addItem(item)
        XCTAssertEqual(viewModel.numberOfCartItems, 1)
    }

    func testItemAtIndex() {
        let item = makeItem(id: 1, name: "Test Item")
        cart.addItem(item)
        let retrieved = viewModel.item(at: 0)
        XCTAssertEqual(retrieved.itemName, "Test Item")
    }

    func testTotalAmount() {
        let item = makeItem(id: 1, price: 200.0)
        cart.addItem(item)
        let total = viewModel.totalAmount()
        XCTAssertEqual(total.doubleValue, 200.0)
    }

    func testFormattedTotal() {
        let item = makeItem(id: 1, price: 150.0)
        cart.addItem(item)
        let formatted = viewModel.formattedTotal()
        XCTAssertTrue(formatted.hasPrefix("$"))
    }

    func testFormattedItemPrice() {
        let item = makeItem(id: 1, price: 50.0)
        cart.addItem(item)
        cart.addItem(item)
        let formatted = viewModel.formattedItemPrice(at: 0)
        XCTAssertTrue(formatted.hasPrefix("$"))
        XCTAssertTrue(formatted.contains("100"))
    }

    func testFormattedItemQuantity() {
        let item = makeItem(id: 1, price: 50.0)
        cart.addItem(item)
        cart.addItem(item)
        cart.addItem(item)
        let formatted = viewModel.formattedItemQuantity(at: 0)
        XCTAssertEqual(formatted, "3")
    }

    func testUpdateQuantity() {
        let item = makeItem(id: 1, price: 50.0)
        cart.addItem(item)
        viewModel.updateQuantity(at: 0, value: 5.0)
        XCTAssertEqual(item.cartAddedQuantity, 5.0)
    }

    func testRemoveItem() {
        let item = makeItem(id: 1)
        cart.addItem(item)
        XCTAssertEqual(viewModel.numberOfCartItems, 1)
        viewModel.removeItem(at: 0)
        XCTAssertEqual(viewModel.numberOfCartItems, 0)
    }

    func testToggleEdit() {
        XCTAssertFalse(viewModel.editClicked)
        viewModel.toggleEdit()
        XCTAssertTrue(viewModel.editClicked)
        viewModel.toggleEdit()
        XCTAssertFalse(viewModel.editClicked)
    }

    func testIsUserLoggedInFalse() {
        UserDefaults.standard.set(false, forKey: "SeesionUserLoggedIN")
        XCTAssertFalse(viewModel.isUserLoggedIn)
    }

    func testIsUserLoggedInTrue() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        XCTAssertTrue(viewModel.isUserLoggedIn)
    }

    func testShowPrice() {
        let result = viewModel.showPrice(NSNumber(value: 299.99))
        XCTAssertEqual(result, "$299.99")
    }

    func testShowPriceZero() {
        let result = viewModel.showPrice(NSNumber(value: 0))
        XCTAssertEqual(result, "$0")
    }

    func testFormattedTotalEmpty() {
        let formatted = viewModel.formattedTotal()
        XCTAssertTrue(formatted.hasPrefix("$"))
    }
}
