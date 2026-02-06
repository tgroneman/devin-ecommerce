import Foundation

class Items: NSObject {
    @objc static let sharedInstance = Items()

    @objc private(set) var allItems: [Item] = []

    private override init() {
        super.init()
        allItems = loadItemsFromJSON()
    }

    private func loadItemsFromJSON() -> [Item] {
        guard let filePath = Bundle.main.path(forResource: "data", ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
              let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            return []
        }

        var itemArray: [Item] = []
        for itemDictionary in jsonArray {
            let itemObject = Item()
            itemObject.ID = itemDictionary["id"] as? NSNumber ?? 0
            itemObject.sale = itemDictionary["Sale"] as? NSNumber ?? 0
            itemObject.itemName = itemDictionary["ProductName"] as? String ?? ""
            itemObject.photoURL = itemDictionary["URL"] as? String ?? ""
            if let priceNumber = itemDictionary["Price"] as? NSNumber {
                itemObject.price = priceNumber.doubleValue
            } else if let priceString = itemDictionary["Price"] as? String, let priceValue = Double(priceString) {
                itemObject.price = priceValue
            }
            itemObject.itemCategory = itemDictionary["ProductType"] as? String ?? ""
            itemObject.brand = itemDictionary["BrandName"] as? String ?? ""
            itemObject.quality = itemDictionary["Quality"] as? String ?? ""
            itemObject.cartAddedQuantity = 0
            itemArray.append(itemObject)
        }
        return itemArray
    }
}
