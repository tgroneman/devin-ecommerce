import Foundation

class Item: NSObject {
    @objc var itemName: String = ""
    @objc var photoURL: String = ""
    @objc var quality: String = ""
    @objc var itemCategory: String = ""
    @objc var brand: String = ""
    @objc var price: Double = 0
    @objc var sale: NSNumber = 0
    @objc var ID: NSNumber = 0
    @objc var cartAddedQuantity: Double = 0
}
