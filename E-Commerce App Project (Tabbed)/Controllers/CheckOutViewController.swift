import UIKit
import MessageUI

class CheckOutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var checkoutCart: ShoppingCart!

    @IBOutlet var checkOutTotalAmount: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var country: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var State: UILabel!
    @IBOutlet var postalCode: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var bkashOutlet: UIButton!
    @IBOutlet var rocketOutlet: UIButton!
    @IBOutlet var cashOnDeliveryOutlet: UIButton!

    var bkashChecked: Bool = false
    var rocketChecked: Bool = false
    var cashOnDeliveryChecked: Bool = false

    private var defaults: UserDefaults!
    private var userData: [String: Any]?
    private var PDFFilePath: String = ""
    private var paymentAlert: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutCart = ShoppingCart.sharedInstance

        paymentAlert = UIAlertController(
            title: "Payment Method Not Selected",
            message: "Please Choose your payment method From the Payment Method Section",
            preferredStyle: .alert
        )
        let yesAction = UIAlertAction(title: "OK!", style: .default, handler: nil)
        paymentAlert.addAction(yesAction)

        bkashChecked = false
        rocketChecked = false
        cashOnDeliveryChecked = false

        defaults = UserDefaults.standard

        if !defaults.bool(forKey: "SeesionUserLoggedIN") {
            checkOutTotalAmount.text = ""
            firstName.text = ""
            lastName.text = ""
            email.text = ""
            phone.text = ""
            country.text = ""
            city.text = ""
            State.text = ""
            postalCode.text = ""
            address.text = ""
            bkashOutlet.isHidden = true
            rocketOutlet.isHidden = true
            cashOnDeliveryOutlet.isHidden = true
        } else {
            bkashOutlet.isHidden = false
            rocketOutlet.isHidden = false
            cashOnDeliveryOutlet.isHidden = false
            userData = defaults.dictionary(forKey: "LoggedInUsersDetail")

            checkOutTotalAmount.text = "$\(defaults.value(forKey: "cartTotalAmount") ?? "")"
            firstName.text = userData?["firstName"] as? String
            lastName.text = userData?["lastName"] as? String
            email.text = userData?["usersEmail"] as? String
            phone.text = userData?["phone"] as? String
            country.text = userData?["country"] as? String
            city.text = userData?["city"] as? String
            State.text = userData?["state"] as? String
            postalCode.text = userData?["postalCode"] as? String
            address.text = userData?["address"] as? String
        }
    }

    @IBAction func bkashAction(_ sender: Any) {
        if !bkashChecked {
            bkashOutlet.setImage(UIImage(named: "checkboxChecked-icon-40.png"), for: .normal)
            rocketOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            cashOnDeliveryOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            bkashChecked = true
            rocketChecked = false
            cashOnDeliveryChecked = false
            defaults.set("Bkash", forKey: "paymentMethodUsed")
            defaults.synchronize()
        } else {
            bkashOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            rocketOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            cashOnDeliveryOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            bkashChecked = false
            rocketChecked = false
            cashOnDeliveryChecked = false
            defaults.set("", forKey: "paymentMethodUsed")
            defaults.synchronize()
        }
    }

    @IBAction func rocketAction(_ sender: Any) {
        if !rocketChecked {
            rocketOutlet.setImage(UIImage(named: "checkboxChecked-icon-40.png"), for: .normal)
            bkashOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            cashOnDeliveryOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            rocketChecked = true
            bkashChecked = false
            cashOnDeliveryChecked = false
            defaults.set("Rocket", forKey: "paymentMethodUsed")
            defaults.synchronize()
        } else {
            bkashOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            rocketOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            cashOnDeliveryOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            bkashChecked = false
            rocketChecked = false
            cashOnDeliveryChecked = false
            defaults.set("", forKey: "paymentMethodUsed")
            defaults.synchronize()
        }
    }

    @IBAction func cashOnDeliveryAction(_ sender: Any) {
        if !cashOnDeliveryChecked {
            cashOnDeliveryOutlet.setImage(UIImage(named: "checkboxChecked-icon-40.png"), for: .normal)
            rocketOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            bkashOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            cashOnDeliveryChecked = true
            rocketChecked = false
            bkashChecked = false
            defaults.set("Cash On Delivery", forKey: "paymentMethodUsed")
            defaults.synchronize()
        } else {
            bkashOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            rocketOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            cashOnDeliveryOutlet.setImage(UIImage(named: "checkboxUnchecked-icon-40.png"), for: .normal)
            bkashChecked = false
            rocketChecked = false
            cashOnDeliveryChecked = false
            defaults.set("", forKey: "paymentMethodUsed")
            defaults.synchronize()
        }
    }

    func getHTMLString() -> String {
        let pdfLogoUrl = "https://apiforios.appendtech.com/logo.png"

        guard let filePath = Bundle.main.path(forResource: "invoice", ofType: "html"),
              let singleItemFilePath = Bundle.main.path(forResource: "single_item", ofType: "html") else {
            return ""
        }

        var strHTML = (try? String(contentsOfFile: filePath, encoding: .utf8)) ?? ""
        let itemsInCartArray = checkoutCart.itemsInCart()

        var allItemsHTMLArray: [String] = []
        for item in itemsInCartArray {
            var srtItemHTML = (try? String(contentsOfFile: singleItemFilePath, encoding: .utf8)) ?? ""
            srtItemHTML = srtItemHTML.replacingOccurrences(of: "#productName", with: item.itemName)
            srtItemHTML = srtItemHTML.replacingOccurrences(of: "#quantity", with: "\(NSNumber(value: item.cartAddedQuantity))")
            srtItemHTML = srtItemHTML.replacingOccurrences(of: "#price", with: "\(NSNumber(value: item.price))")
            allItemsHTMLArray.append(srtItemHTML)
        }
        let allItemsHTMLString = allItemsHTMLArray.joined(separator: "\n")

        strHTML = strHTML.replacingOccurrences(of: "#ITEMS#", with: allItemsHTMLString)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: Date())

        let ownerInfo = "ICTcom<br>An E-commerce App Project<br>Developed BY: Rony Banik (Arko)<br>"
        strHTML = strHTML.replacingOccurrences(of: "#ownerInfo", with: ownerInfo)
        strHTML = strHTML.replacingOccurrences(of: "#appIcon", with: pdfLogoUrl)
        strHTML = strHTML.replacingOccurrences(of: "#invoiceDate", with: dateString)
        strHTML = strHTML.replacingOccurrences(of: "#cartTotal", with: (defaults.value(forKey: "cartTotalAmount") as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#firstName", with: (userData?["firstName"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#lastName", with: (userData?["lastName"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#email", with: (userData?["usersEmail"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#phone", with: (userData?["phone"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#country", with: (userData?["country"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#city", with: (userData?["city"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#state", with: (userData?["state"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#postalCode", with: (userData?["postalCode"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#address", with: (userData?["address"] as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#paymentMethod", with: (defaults.value(forKey: "paymentMethodUsed") as? String) ?? "")

        return strHTML
    }

    func savePDF() {
        let pageFrame = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)

        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        let printFormatter = UIMarkupTextPrintFormatter(markupText: getHTMLString())
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        UIGraphicsBeginPDFPage()
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()

        PDFFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        PDFFilePath = PDFFilePath + "/invoiceFromICTcom.pdf"
        pdfData.write(toFile: PDFFilePath, atomically: true)
        defaults.set(PDFFilePath, forKey: "pdfFilePath")
        defaults.synchronize()
    }

    @IBAction func finishCheckOutButton(_ sender: Any) {
        if (defaults.value(forKey: "paymentMethodUsed") as? String) == "" {
            present(paymentAlert, animated: true, completion: nil)
        } else {
            savePDF()
            sendMailWithPDF()
            defaults.set("", forKey: "cartTotalAmount")
            defaults.set("", forKey: "paymentMethodUsed")
            defaults.synchronize()
            checkoutCart.clearCart()
            performSegue(withIdentifier: "checkoutToThankyouSegue", sender: nil)
        }
    }

    func sendMailWithPDF() {
        if MFMailComposeViewController.canSendMail() {
            let saleMail = MFMailComposeViewController()
            saleMail.mailComposeDelegate = self
            saleMail.setSubject("Invoice From ICTcom App")
            saleMail.setMessageBody("Thanks so much for your purchase.<br>Please find the attached invoice.<br>Thanks From ICTcom", isHTML: true)
            if let contentsOfFile = try? Data(contentsOf: URL(fileURLWithPath: PDFFilePath)) {
                saleMail.addAttachmentData(contentsOfFile, mimeType: "application/pdf", fileName: "Invoice")
            }
            if let userEmail = userData?["usersEmail"] as? String {
                saleMail.setToRecipients([userEmail])
            }
            present(saleMail, animated: true, completion: nil)
        } else {
            print("Device can't send email! maybe Simulator")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
