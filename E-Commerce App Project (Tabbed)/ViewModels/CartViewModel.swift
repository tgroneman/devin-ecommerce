import Foundation

class CartViewModel {

    private let cart: ShoppingCart

    private(set) var editClicked: Bool = false

    init() {
        cart = ShoppingCart.sharedInstance
    }

    var cartItems: [Item] {
        return cart.itemsInCart()
    }

    var isCartEmpty: Bool {
        return cart.itemsInCart().isEmpty
    }

    var numberOfCartItems: Int {
        return cart.itemsInCart().count
    }

    func item(at index: Int) -> Item {
        return cart.itemsInCart()[index]
    }

    func totalAmount() -> NSNumber {
        return cart.total()
    }

    func formattedTotal() -> String {
        return "$\(cart.total())"
    }

    func formattedItemPrice(at index: Int) -> String {
        let itemObject = cart.itemsInCart()[index]
        let updatedPrice = itemObject.cartAddedQuantity * itemObject.price
        return "$\(NSNumber(value: updatedPrice))"
    }

    func formattedItemQuantity(at index: Int) -> String {
        let itemObject = cart.itemsInCart()[index]
        return "\(NSNumber(value: itemObject.cartAddedQuantity))"
    }

    func updateQuantity(at index: Int, value: Double) {
        let itemObject = cart.itemsInCart()[index]
        itemObject.cartAddedQuantity = value
    }

    func removeItem(at index: Int) {
        let itemObject = cart.itemsInCart()[index]
        cart.removeFromCart(itemObject)
    }

    func toggleEdit() {
        editClicked = !editClicked
    }

    var isUserLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: "SeesionUserLoggedIN")
    }

    func showPrice(_ price: NSNumber) -> String {
        return "$\(price)"
    }
}
