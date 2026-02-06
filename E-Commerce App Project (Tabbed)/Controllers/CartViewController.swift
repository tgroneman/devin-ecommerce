import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var checkoutCart: ShoppingCart!

    var itemImage: UIImageView?
    var itemNameLabel: UILabel?
    var itemPriceLabel: UILabel?
    var itemQuantityLabel: UILabel?
    var itemQuantityInText: String = ""
    @IBOutlet var totalAmountLabelOutlet: UILabel!
    @IBOutlet var totalAmountShowOutlet: UILabel!
    var updatedSingleItemPriceText: String = ""
    @IBOutlet var cartTableView: UITableView!
    var quantityStepper: UIStepper?
    @IBOutlet var editCartButtonOutlet: UIBarButtonItem!
    @IBOutlet var cartContinueButtonOutlet: UIBarButtonItem!

    private var updatedSingleItemPrice: Double = 0
    private var updatedSingleItemPriceDoubleValueToNumber: NSNumber = 0
    private var stepperClickedValue: Double = 0
    private var editClicked: Bool = false
    private var intendedPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutCart = ShoppingCart.sharedInstance
        cartTableView.reloadData()
        updateCartUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cartTableView.reloadData()
        updateCartUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartTableView.reloadData()
    }

    private func updateCartUI() {
        if checkoutCart.itemsInCart().isEmpty {
            editCartButtonOutlet.isEnabled = false
            editCartButtonOutlet.tintColor = .clear
            cartContinueButtonOutlet.isEnabled = false
            cartContinueButtonOutlet.tintColor = .clear
            totalAmountLabelOutlet.isHidden = true
            totalAmountShowOutlet.isHidden = true
        } else {
            editCartButtonOutlet.isEnabled = true
            editCartButtonOutlet.tintColor = UIColor(named: "Cornflower Blue")
            cartContinueButtonOutlet.isEnabled = true
            cartContinueButtonOutlet.tintColor = UIColor(named: "Cornflower Blue")
            totalAmountLabelOutlet.isHidden = false
            totalAmountShowOutlet.isHidden = false
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let itemObject = checkoutCart.itemsInCart()[indexPath.row]
            intendedPath = indexPath
            let cellIdentifier = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCellIdentifier")!

            itemImage = cellIdentifier.viewWithTag(701) as? UIImageView
            itemNameLabel = cellIdentifier.viewWithTag(702) as? UILabel
            itemPriceLabel = cellIdentifier.viewWithTag(703) as? UILabel
            itemQuantityLabel = cellIdentifier.viewWithTag(704) as? UILabel
            quantityStepper = cellIdentifier.viewWithTag(705) as? UIStepper

            if let url = URL(string: itemObject.photoURL), let data = try? Data(contentsOf: url) {
                itemImage?.image = UIImage(data: data)
            }
            itemNameLabel?.text = itemObject.itemName
            quantityStepper?.value = itemObject.cartAddedQuantity

            updatedSingleItemPrice = itemObject.cartAddedQuantity * itemObject.price
            updatedSingleItemPriceDoubleValueToNumber = NSNumber(value: updatedSingleItemPrice)
            itemPriceLabel?.text = showPrice(updatedSingleItemPriceDoubleValueToNumber)

            itemQuantityInText = "\(NSNumber(value: itemObject.cartAddedQuantity))"
            itemQuantityLabel?.text = itemQuantityInText
            totalAmountShowOutlet.text = showPrice(checkoutCart.total())

            return cellIdentifier
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? checkoutCart.itemsInCart().count : 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @IBAction func stepperClicked(_ sender: UIStepper) {
        let stepperValue = sender.value
        let buttonPosition = sender.convert(CGPoint.zero, to: cartTableView)
        if let rowIndexPath = cartTableView.indexPathForRow(at: buttonPosition) {
            returnStepperValue(rowIndexPath, withStepperValue: stepperValue)
        }
    }

    func returnStepperValue(_ indexPath: IndexPath, withStepperValue stepperValue: Double) {
        let itemObject = checkoutCart.itemsInCart()[indexPath.row]
        itemObject.cartAddedQuantity = stepperValue
        cartTableView.reloadData()
    }

    @IBAction func editCartButton(_ sender: Any) {
        if !editClicked {
            cartTableView.setEditing(true, animated: true)
            editClicked = true
            cartTableView.reloadData()
        } else {
            cartTableView.setEditing(false, animated: true)
            editClicked = false
            cartTableView.reloadData()
        }
    }

    @IBAction func CartContinueButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "SeesionUserLoggedIN") {
            performSegue(withIdentifier: "cartToLogInSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "checkOutSegue", sender: nil)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemObject = checkoutCart.itemsInCart()[indexPath.row]
            checkoutCart.removeFromCart(itemObject)
            totalAmountShowOutlet.text = "\(checkoutCart.total())"
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func showPrice(_ price: NSNumber) -> String {
        return "$\(price)"
    }
}
