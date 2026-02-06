import Foundation

class CategoryItemsViewModel {

    private(set) var categoryItemsList: [Item] = []
    private(set) var categoryName: String = ""

    func configure(items: [Item], name: String) {
        categoryItemsList = items
        categoryName = name
    }

    var numberOfItems: Int {
        return categoryItemsList.count
    }

    func item(at index: Int) -> Item {
        return categoryItemsList[index]
    }

    func formatPrice(_ price: Double) -> String {
        return "$\(NSNumber(value: price))"
    }
}
