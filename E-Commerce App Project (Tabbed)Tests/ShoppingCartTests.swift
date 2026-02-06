import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class ShoppingCartTests: XCTestCase {

    var cart: ShoppingCart!

    override func setUp() {
        super.setUp()
        cart = ShoppingCart.sharedInstance
        cart.clearCart()
    }

    override func tearDown() {
        cart.clearCart()
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

    func testSharedInstance() {
        let cart2 = ShoppingCart.sharedInstance
        XCTAssertTrue(cart === cart2)
    }

    func testEmptyCart() {
        XCTAssertTrue(cart.itemsInCart().isEmpty)
    }

    func testAddItem() {
        let item = makeItem()
        cart.addItem(item)
        XCTAssertEqual(cart.itemsInCart().count, 1)
        XCTAssertEqual(item.cartAddedQuantity, 1)
    }

    func testAddSameItemTwice() {
        let item = makeItem()
        cart.addItem(item)
        cart.addItem(item)
        XCTAssertEqual(cart.itemsInCart().count, 1)
        XCTAssertEqual(item.cartAddedQuantity, 2)
    }

    func testAddDifferentItems() {
        let item1 = makeItem(id: 1, name: "Item A")
        let item2 = makeItem(id: 2, name: "Item B")
        cart.addItem(item1)
        cart.addItem(item2)
        XCTAssertEqual(cart.itemsInCart().count, 2)
    }

    func testContainsItem() {
        let item = makeItem()
        XCTAssertFalse(cart.containsItem(item))
        cart.addItem(item)
        XCTAssertTrue(cart.containsItem(item))
    }

    func testContainsItemByID() {
        let item1 = makeItem(id: 5, name: "A")
        let item2 = makeItem(id: 5, name: "B")
        cart.addItem(item1)
        XCTAssertTrue(cart.containsItem(item2))
    }

    func testRemoveItemDecrementsQuantity() {
        let item = makeItem()
        cart.addItem(item)
        cart.addItem(item)
        XCTAssertEqual(item.cartAddedQuantity, 2)
        cart.removeItem(item)
        XCTAssertEqual(item.cartAddedQuantity, 1)
    }

    func testRemoveItemAtZeroQuantity() {
        let item = makeItem()
        cart.addItem(item)
        item.cartAddedQuantity = 0
        cart.removeItem(item)
        XCTAssertEqual(item.cartAddedQuantity, 0)
    }

    func testRemoveFromCart() {
        let item = makeItem()
        cart.addItem(item)
        cart.addItem(item)
        cart.removeFromCart(item)
        XCTAssertEqual(item.cartAddedQuantity, 0)
        XCTAssertTrue(cart.itemsInCart().isEmpty)
    }

    func testRemoveFromCartItemNotInCart() {
        let item = makeItem()
        cart.removeFromCart(item)
        XCTAssertEqual(item.cartAddedQuantity, 0)
        XCTAssertTrue(cart.itemsInCart().isEmpty)
    }

    func testClearCart() {
        let item1 = makeItem(id: 1)
        let item2 = makeItem(id: 2)
        cart.addItem(item1)
        cart.addItem(item2)
        XCTAssertEqual(cart.itemsInCart().count, 2)
        cart.clearCart()
        XCTAssertTrue(cart.itemsInCart().isEmpty)
    }

    func testTotal() {
        let item1 = makeItem(id: 1, price: 100.0)
        let item2 = makeItem(id: 2, price: 200.0)
        cart.addItem(item1)
        cart.addItem(item2)
        let total = cart.total()
        XCTAssertEqual(total.doubleValue, 300.0)
    }

    func testTotalWithMultipleQuantities() {
        let item = makeItem(id: 1, price: 50.0)
        cart.addItem(item)
        cart.addItem(item)
        cart.addItem(item)
        let total = cart.total()
        XCTAssertEqual(total.doubleValue, 150.0)
    }

    func testTotalEmptyCart() {
        let total = cart.total()
        XCTAssertEqual(total.doubleValue, 0.0)
    }

    func testTotalSavesToUserDefaults() {
        let item = makeItem(id: 1, price: 99.99)
        cart.addItem(item)
        _ = cart.total()
        let savedTotal = UserDefaults.standard.string(forKey: "cartTotalAmount")
        XCTAssertNotNil(savedTotal)
    }

    func testItemsInCartReturnsArray() {
        let items = cart.itemsInCart()
        XCTAssertNotNil(items)
    }

    func testAddItemThenRemoveFromCart() {
        let item = makeItem()
        cart.addItem(item)
        XCTAssertEqual(cart.itemsInCart().count, 1)
        cart.removeFromCart(item)
        XCTAssertEqual(cart.itemsInCart().count, 0)
    }

    func testMultipleItemsTotal() {
        let item1 = makeItem(id: 1, price: 10.0)
        let item2 = makeItem(id: 2, price: 20.0)
        let item3 = makeItem(id: 3, price: 30.0)
        cart.addItem(item1)
        cart.addItem(item2)
        cart.addItem(item3)
        cart.addItem(item1)
        let total = cart.total()
        XCTAssertEqual(total.doubleValue, 70.0)
    }
}
