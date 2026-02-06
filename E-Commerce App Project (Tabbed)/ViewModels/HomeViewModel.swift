import Foundation

class HomeViewModel {

    private(set) var tvCategory: [Item] = []
    private(set) var laptopCategoryItemsList: [Item] = []
    private(set) var mobileCategoryItemsList: [Item] = []
    private(set) var desktopCategoryItemsList: [Item] = []
    private(set) var tabletCategoryItemsList: [Item] = []

    let sliderImageNames: [String] = ["image1.jpg", "image2.png", "image4.jpg", "image5.jpg"]

    var sliderIndex: Int = 0

    func loadCategories() {
        tvCategory = CategoryItemList.sharedInstance.tvCategoryItemsList
        laptopCategoryItemsList = CategoryItemList.sharedInstance.laptopCategoryItemsList
        desktopCategoryItemsList = CategoryItemList.sharedInstance.desktopCategoryItemsList
        mobileCategoryItemsList = CategoryItemList.sharedInstance.mobileCategoryItemsList
        tabletCategoryItemsList = CategoryItemList.sharedInstance.tabletCategoryItemsList
    }

    func numberOfItems(forCollectionViewTag tag: Int) -> Int {
        switch tag {
        case 0: return tvCategory.count
        case 1: return laptopCategoryItemsList.count
        case 2: return desktopCategoryItemsList.count
        case 3: return mobileCategoryItemsList.count
        case 4: return tabletCategoryItemsList.count
        default: return 0
        }
    }

    func item(forCollectionViewTag tag: Int, at index: Int) -> Item {
        switch tag {
        case 0: return tvCategory[index]
        case 1: return laptopCategoryItemsList[index]
        case 2: return desktopCategoryItemsList[index]
        case 3: return mobileCategoryItemsList[index]
        default: return tabletCategoryItemsList[index]
        }
    }

    func categoryItems(forCollectionViewTag tag: Int) -> [Item] {
        switch tag {
        case 0: return tvCategory
        case 1: return laptopCategoryItemsList
        case 2: return desktopCategoryItemsList
        case 3: return mobileCategoryItemsList
        case 4: return tabletCategoryItemsList
        default: return []
        }
    }

    func categoryName(forCollectionViewTag tag: Int) -> String {
        switch tag {
        case 0: return "Television"
        case 1: return "Laptop"
        case 2: return "Desktop"
        case 3: return "Mobile"
        case 4: return "Tablet"
        default: return ""
        }
    }

    func advanceSliderIndex() {
        if sliderIndex == sliderImageNames.count - 1 {
            sliderIndex = 0
        } else {
            sliderIndex += 1
        }
    }

    func formatPrice(_ price: Double) -> String {
        return "$\(NSNumber(value: price))"
    }
}
