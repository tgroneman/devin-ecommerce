import UIKit
import WebKit

class ThankYouViewController: UIViewController, WKUIDelegate {

    @IBOutlet var wkwebviewOutletForPDFShow: WKWebView?
    @IBOutlet var uiviewForArko: UIView?
    @IBOutlet var emailThankYouPage: UILabel?

    private let viewModel = ThankYouViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        emailThankYouPage?.text = viewModel.userEmail

        let pdfUrl = viewModel.pdfFileURL
        wkwebviewOutletForPDFShow?.loadFileURL(pdfUrl, allowingReadAccessTo: pdfUrl)
    }
}
