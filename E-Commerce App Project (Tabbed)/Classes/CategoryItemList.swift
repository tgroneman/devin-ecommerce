import Foundation

class CategoryItemList: NSObject {
    @objc static let sharedInstance = CategoryItemList()

    @objc private(set) var tvCategoryItemsList: [Item] = []
    @objc private(set) var laptopCategoryItemsList: [Item] = []
    @objc private(set) var mobileCategoryItemsList: [Item] = []
    @objc private(set) var desktopCategoryItemsList: [Item] = []
    @objc private(set) var tabletCategoryItemsList: [Item] = []

    private override init() {
        super.init()
        let allItemsList = Items.sharedInstance.allItems
        tvCategoryItemsList = returnCategoryArray(allItemsList, forCategory: "Television")
        laptopCategoryItemsList = returnCategoryArray(allItemsList, forCategory: "Laptops")
        desktopCategoryItemsList = returnCategoryArray(allItemsList, forCategory: "Desktop")
        mobileCategoryItemsList = returnCategoryArray(allItemsList, forCategory: "Mobile")
        tabletCategoryItemsList = returnCategoryArray(allItemsList, forCategory: "Tablet")
    }

    private func returnCategoryArray(_ allItems: [Item], forCategory itemCategoryName: String) -> [Item] {
        return allItems.filter { $0.itemCategory == itemCategoryName }
    }
}
