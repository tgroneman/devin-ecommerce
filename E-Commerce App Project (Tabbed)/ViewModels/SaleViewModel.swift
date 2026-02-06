import Foundation

class SaleViewModel {

    private(set) var saleItemsList: [Item] = []

    func loadSaleItems() {
        let allItemsList = Items.sharedInstance.allItems
        saleItemsList = allItemsList.filter { $0.sale.intValue != 0 }
    }

    var numberOfSaleItems: Int {
        return saleItemsList.count
    }

    func item(at index: Int) -> Item {
        return saleItemsList[index]
    }

    func formatPrice(_ price: Double) -> String {
        return "$\(NSNumber(value: price))"
    }
}
