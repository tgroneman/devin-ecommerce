import UIKit
import MessageUI

class CheckOutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    private let viewModel = CheckOutViewModel()

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

    private var paymentAlert: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()

        paymentAlert = UIAlertController(
            title: "Payment Method Not Selected",
            message: "Please Choose your payment method From the Payment Method Section",
            preferredStyle: .alert
        )
        let yesAction = UIAlertAction(title: "OK!", style: .default, handler: nil)
        paymentAlert.addAction(yesAction)

        if !viewModel.isUserLoggedIn {
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
            viewModel.loadUserData()

            checkOutTotalAmount.text = viewModel.formattedTotal
            firstName.text = viewModel.userFirstName
            lastName.text = viewModel.userLastName
            email.text = viewModel.userEmail
            phone.text = viewModel.userPhone
            country.text = viewModel.userCountry
            city.text = viewModel.userCity
            State.text = viewModel.userState
            postalCode.text = viewModel.userPostalCode
            address.text = viewModel.userAddress
        }
    }

    @IBAction func bkashAction(_ sender: Any) {
        viewModel.toggleBkash()
        updatePaymentCheckboxes()
    }

    @IBAction func rocketAction(_ sender: Any) {
        viewModel.toggleRocket()
        updatePaymentCheckboxes()
    }

    @IBAction func cashOnDeliveryAction(_ sender: Any) {
        viewModel.toggleCashOnDelivery()
        updatePaymentCheckboxes()
    }

    private func updatePaymentCheckboxes() {
        let bkashImage = viewModel.bkashChecked ? "checkboxChecked-icon-40.png" : "checkboxUnchecked-icon-40.png"
        let rocketImage = viewModel.rocketChecked ? "checkboxChecked-icon-40.png" : "checkboxUnchecked-icon-40.png"
        let codImage = viewModel.cashOnDeliveryChecked ? "checkboxChecked-icon-40.png" : "checkboxUnchecked-icon-40.png"
        bkashOutlet.setImage(UIImage(named: bkashImage), for: .normal)
        rocketOutlet.setImage(UIImage(named: rocketImage), for: .normal)
        cashOnDeliveryOutlet.setImage(UIImage(named: codImage), for: .normal)
    }

    func savePDF() {
        let pageFrame = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)

        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        let printFormatter = UIMarkupTextPrintFormatter(markupText: viewModel.getHTMLString())
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        UIGraphicsBeginPDFPage()
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()

        var pdfPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        pdfPath = pdfPath + "/invoiceFromICTcom.pdf"
        pdfData.write(toFile: pdfPath, atomically: true)
        viewModel.setPDFFilePath(pdfPath)
    }

    @IBAction func finishCheckOutButton(_ sender: Any) {
        if !viewModel.isPaymentMethodSelected {
            present(paymentAlert, animated: true, completion: nil)
        } else {
            savePDF()
            sendMailWithPDF()
            viewModel.finishCheckout()
            performSegue(withIdentifier: "checkoutToThankyouSegue", sender: nil)
        }
    }

    func sendMailWithPDF() {
        if MFMailComposeViewController.canSendMail() {
            let saleMail = MFMailComposeViewController()
            saleMail.mailComposeDelegate = self
            saleMail.setSubject("Invoice From ICTcom App")
            saleMail.setMessageBody("Thanks so much for your purchase.<br>Please find the attached invoice.<br>Thanks From ICTcom", isHTML: true)
            if let contentsOfFile = try? Data(contentsOf: URL(fileURLWithPath: viewModel.pdfFilePath)) {
                saleMail.addAttachmentData(contentsOfFile, mimeType: "application/pdf", fileName: "Invoice")
            }
            let userEmail = viewModel.userEmail
            if !userEmail.isEmpty {
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
