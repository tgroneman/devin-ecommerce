import UIKit

class SaleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var saleItemsList: [Item] = []
    @IBOutlet var saleCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        saleCollectionView.dataSource = self
        saleCollectionView.delegate = self
    }

    func returnSaleArray(_ allItems: [Item]) -> [Item] {
        return allItems.filter { $0.sale.intValue != 0 }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let allItemsList = Items.sharedInstance.allItems
        saleItemsList = returnSaleArray(allItemsList)
        let individualData = saleItemsList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sellCellIdentifier", for: indexPath)

        let itemImage = cell.viewWithTag(601) as? UIImageView
        let itemNameLabel = cell.viewWithTag(602) as? UILabel
        let itemPriceLabel = cell.viewWithTag(603) as? UILabel

        if let url = URL(string: individualData.photoURL), let data = try? Data(contentsOf: url) {
            itemImage?.image = UIImage(data: data)
        }
        itemNameLabel?.text = individualData.itemName
        itemPriceLabel?.text = showPrice(individualData.price)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allItemsList = Items.sharedInstance.allItems
        saleItemsList = returnSaleArray(allItemsList)
        return saleItemsList.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleItemView = storyboard?.instantiateViewController(withIdentifier: "singleItemViewStoryBoardIdentifier") as? SingleItemViewController else { return }

        let individualData = saleItemsList[indexPath.row]
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
