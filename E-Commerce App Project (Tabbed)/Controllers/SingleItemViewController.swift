import UIKit

class SingleItemViewController: ViewController {

    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var itemCategory: UILabel!
    @IBOutlet var itemID: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var itemBrand: UILabel!
    @IBOutlet var itemQuality: UILabel!
    @IBOutlet var addToCartStatusoutlet: UIButton!
    @IBOutlet var removeFromCartOutlet: UIButton!

    var setItemImageData: Data?
    var setItemName: String?
    var setItemCategory: String?
    var setItemID: NSNumber?
    var setItemPrice: NSNumber?
    var setItemBrand: String?
    var setItemQuality: String?

    var itemAlreadyAddedAlert: UIAlertController!
    var itemObjectReceived: Item!

    private let viewModel = SingleItemViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.configure(with: itemObjectReceived)

        if let imageData = setItemImageData {
            itemImage.image = UIImage(data: imageData)
        }
        itemName.text = setItemName
        itemCategory.text = setItemCategory
        itemID.text = setItemID?.stringValue
        itemPrice.text = viewModel.formatPrice(setItemPrice)
        itemBrand.text = setItemBrand
        itemQuality.text = setItemQuality

        addToCartStatusoutlet.isSelected = viewModel.isInCart

        itemAlreadyAddedAlert = UIAlertController(
            title: "Already Added To The Cart",
            message: "Item Will Be Added To Your Cart Again",
            preferredStyle: .alert
        )

        let yesButton = UIAlertAction(title: "Got it!", style: .default, handler: nil)
        let noButton = UIAlertAction(title: "Add To Cart Again!", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.addToCart()
            self.addToCartStatusoutlet.isSelected = true
        }

        itemAlreadyAddedAlert.addAction(yesButton)
        itemAlreadyAddedAlert.addAction(noButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addToCartStatusoutlet.isSelected = viewModel.isInCart
        removeFromCartOutlet.isHidden = !addToCartStatusoutlet.isSelected
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !addToCartStatusoutlet.isSelected {
            removeFromCartOutlet.isHidden = true
            addToCartStatusoutlet.setTitle("Add To Cart", for: .normal)
        } else {
            removeFromCartOutlet.isHidden = false
            addToCartStatusoutlet.setTitle("Add To Cart Again", for: .normal)
        }
    }

    @IBAction func addToCartButton(_ sender: UIButton) {
        if !addToCartStatusoutlet.isSelected {
            viewModel.addToCart()
            addToCartStatusoutlet.isSelected = true
            removeFromCartOutlet.isHidden = false
            sender.setTitle("Again Add To Cart", for: .normal)
            sender.backgroundColor = .green
            sender.setTitleColor(.black, for: .normal)
        } else {
            removeFromCartOutlet.isHidden = false
            present(itemAlreadyAddedAlert, animated: true, completion: nil)
            sender.setTitle("Again Add To Cart", for: .normal)
            sender.backgroundColor = .green
            sender.setTitleColor(.black, for: .normal)
        }
    }

    @IBAction func removeFromCartButton(_ sender: UIButton) {
        viewModel.removeFromCart()
        addToCartStatusoutlet.isSelected = false
        sender.setTitle("Add To Cart", for: .normal)
        sender.setImage(UIImage(named: "addToCart-icon-40.png"), for: .normal)
        sender.backgroundColor = .blue
    }
}
