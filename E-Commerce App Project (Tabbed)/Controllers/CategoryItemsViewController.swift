import UIKit

class CategoryItemsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var categoryItemsList: [Item] = []
    @IBOutlet var categoryName: UILabel?
    @IBOutlet var categoryCollectionView: UICollectionView!
    var receivedCategoryItemsList: [Item] = []
    var receivedCategoryName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryItemsList = receivedCategoryItemsList
        categoryName?.text = receivedCategoryName
        navigationItem.title = receivedCategoryName
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let individualData = categoryItemsList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath)

        let itemImage = cell.viewWithTag(1001) as? UIImageView
        let itemNameLabel = cell.viewWithTag(1002) as? UILabel
        let itemPriceLabel = cell.viewWithTag(1003) as? UILabel

        if let url = URL(string: individualData.photoURL), let data = try? Data(contentsOf: url) {
            itemImage?.image = UIImage(data: data)
        }
        itemNameLabel?.text = individualData.itemName
        itemPriceLabel?.text = showPrice(individualData.price)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItemsList.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleItemView = storyboard?.instantiateViewController(withIdentifier: "singleItemViewStoryBoardIdentifier") as? SingleItemViewController else { return }

        let individualData = categoryItemsList[indexPath.row]
        singleItemView.itemObjectReceived = individualData
        if let url = URL(string: individualData.photoURL) {
            singleItemView.setItemImageData = try? Data(contentsOf: url)
        }
        singleItemView.setItemName = individualData.itemName
        singleItemView.setItemCategory = individualData.itemCategory
        singleItemView.setItemID = individualData.ID
        singleItemView.setItemPrice = NSNumber(value: individualData.price)
        singleItemView.setItemBrand = individualData.brand
        singleItemView.setItemQuality = individualData.quality

        navigationController?.pushViewController(singleItemView, animated: true)
    }

    func showPrice(_ price: Double) -> String {
        return "$\(NSNumber(value: price))"
    }
}
