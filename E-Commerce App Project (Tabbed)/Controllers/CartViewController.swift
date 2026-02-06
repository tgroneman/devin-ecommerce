import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let viewModel = CartViewModel()

    @IBOutlet var totalAmountLabelOutlet: UILabel!
    @IBOutlet var totalAmountShowOutlet: UILabel!
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet var editCartButtonOutlet: UIBarButtonItem!
    @IBOutlet var cartContinueButtonOutlet: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if viewModel.isCartEmpty {
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
            let itemObject = viewModel.item(at: indexPath.row)
            let cellIdentifier = tableView.dequeueReusableCell(withIdentifier: "cartTableViewCellIdentifier")!

            let itemImage = cellIdentifier.viewWithTag(701) as? UIImageView
            let itemNameLabel = cellIdentifier.viewWithTag(702) as? UILabel
            let itemPriceLabel = cellIdentifier.viewWithTag(703) as? UILabel
            let itemQuantityLabel = cellIdentifier.viewWithTag(704) as? UILabel
            let quantityStepper = cellIdentifier.viewWithTag(705) as? UIStepper

            if let url = URL(string: itemObject.photoURL), let data = try? Data(contentsOf: url) {
                itemImage?.image = UIImage(data: data)
            }
            itemNameLabel?.text = itemObject.itemName
            quantityStepper?.value = itemObject.cartAddedQuantity

            itemPriceLabel?.text = viewModel.formattedItemPrice(at: indexPath.row)
            itemQuantityLabel?.text = viewModel.formattedItemQuantity(at: indexPath.row)
            totalAmountShowOutlet.text = viewModel.showPrice(viewModel.totalAmount())

            return cellIdentifier
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.numberOfCartItems : 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    @IBAction func stepperClicked(_ sender: UIStepper) {
        let stepperValue = sender.value
        let buttonPosition = sender.convert(CGPoint.zero, to: cartTableView)
        if let rowIndexPath = cartTableView.indexPathForRow(at: buttonPosition) {
            viewModel.updateQuantity(at: rowIndexPath.row, value: stepperValue)
            cartTableView.reloadData()
        }
    }

    @IBAction func editCartButton(_ sender: Any) {
        viewModel.toggleEdit()
        cartTableView.setEditing(viewModel.editClicked, animated: true)
        cartTableView.reloadData()
    }

    @IBAction func CartContinueButton(_ sender: Any) {
        if !viewModel.isUserLoggedIn {
            performSegue(withIdentifier: "cartToLogInSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "checkOutSegue", sender: nil)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeItem(at: indexPath.row)
            totalAmountShowOutlet.text = viewModel.formattedTotal()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
