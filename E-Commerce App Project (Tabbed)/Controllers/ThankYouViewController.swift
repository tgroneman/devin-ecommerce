import UIKit
import WebKit

class ThankYouViewController: UIViewController, WKUIDelegate {

    @IBOutlet var wkwebviewOutletForPDFShow: WKWebView!
    @IBOutlet var uiviewForArko: UIView!
    @IBOutlet var emailThankYouPage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        let PDFFilePath = defaults.value(forKey: "pdfFilePath") as? String ?? ""
        emailThankYouPage.text = defaults.value(forKey: "SessionLoggedInuserEmail") as? String

        let pdfUrl = URL(fileURLWithPath: PDFFilePath)
        wkwebviewOutletForPDFShow.loadFileURL(pdfUrl, allowingReadAccessTo: pdfUrl)
    }
}
