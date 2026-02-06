import Foundation

class SingleItemViewModel {

    private let cart: ShoppingCart
    private(set) var itemObject: Item!

    var itemImageData: Data?
    var itemName: String = ""
    var itemCategory: String = ""
    var itemID: NSNumber?
    var itemPrice: NSNumber?
    var itemBrand: String = ""
    var itemQuality: String = ""

    init() {
        cart = ShoppingCart.sharedInstance
    }

    func configure(with item: Item) {
        itemObject = item
        itemName = item.itemName
        itemCategory = item.itemCategory
        itemID = item.ID
        itemPrice = NSNumber(value: item.price)
        itemBrand = item.brand
        itemQuality = item.quality
        if let url = URL(string: item.photoURL) {
            itemImageData = try? Data(contentsOf: url)
        }
    }

    var isInCart: Bool {
        return cart.containsItem(itemObject)
    }

    func addToCart() {
        cart.addItem(itemObject)
    }

    func removeFromCart() {
        cart.removeItem(itemObject)
    }

    func formatPrice(_ price: NSNumber?) -> String {
        guard let price = price else { return "$0" }
        return "$\(price)"
    }

    var formattedPrice: String {
        return formatPrice(itemPrice)
    }

    var formattedID: String {
        return itemID?.stringValue ?? ""
    }
}
