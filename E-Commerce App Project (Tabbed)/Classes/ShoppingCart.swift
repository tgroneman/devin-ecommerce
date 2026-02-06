import Foundation

class ShoppingCart: NSObject {
    @objc static let sharedInstance = ShoppingCart()

    private var itemArray: [Item] = []

    private override init() {
        super.init()
    }

    @objc func itemsInCart() -> [Item] {
        return itemArray
    }

    @objc func containsItem(_ itemObject: Item) -> Bool {
        return itemArray.contains { $0.ID == itemObject.ID }
    }

    @objc func addItem(_ itemObject: Item) {
        if containsItem(itemObject) {
            itemObject.cartAddedQuantity += 1
        } else {
            itemObject.cartAddedQuantity = 1
            itemArray.append(itemObject)
        }
    }

    @objc func removeItem(_ itemObject: Item) {
        if itemObject.cartAddedQuantity > 0 {
            itemObject.cartAddedQuantity -= 1
        } else {
            itemObject.cartAddedQuantity = 0
            if let index = itemArray.firstIndex(of: itemObject) {
                itemArray.remove(at: index)
            }
        }
    }

    @objc func removeFromCart(_ itemObject: Item) {
        itemObject.cartAddedQuantity = 0
        if let index = itemArray.firstIndex(of: itemObject) {
            itemArray.remove(at: index)
        }
    }

    @objc func clearCart() {
        itemArray = []
    }

    @objc func total() -> NSNumber {
        var total: Double = 0
        for itemObject in itemsInCart() {
            let totalSingleItemPrice = itemObject.cartAddedQuantity * itemObject.price
            total += totalSingleItemPrice
        }
        let roundedTotal = lroundf(Float(total))
        let defaults = UserDefaults.standard
        defaults.set(String(roundedTotal), forKey: "cartTotalAmount")
        defaults.synchronize()
        return NSNumber(value: total)
    }
}
