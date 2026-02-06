import UIKit

class AccountViewController: UIViewController {

    @IBOutlet var firstName: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var country: UILabel!
    @IBOutlet var state: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var postalCode: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var firstNameOutlet: UILabel!
    @IBOutlet var lastNameOutlet: UILabel!
    @IBOutlet var emailOutlet: UILabel!
    @IBOutlet var countryOutlet: UILabel!
    @IBOutlet var stateOutlet: UILabel!
    @IBOutlet var cityOutlet: UILabel!
    @IBOutlet var postalCodeOutlet: UILabel!
    @IBOutlet var addressOutlet: UILabel!
    @IBOutlet var goToLoginButtonOutlet: UIButton!
    @IBOutlet var phoneOutlet: UILabel!
    @IBOutlet var userLogOutOutlet: UIBarButtonItem!
    @IBOutlet var userHistoryOutlet: UIBarButtonItem!
    @IBOutlet var editUserAccountOutlet: UIBarButtonItem!

    var loggedOutAlert: UIAlertController!

    private var accountOperationsObj: AccountOperations!
    private var defaults: UserDefaults!
    private var userData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        accountOperationsObj = AccountOperations()
        defaults = UserDefaults.standard

        if !defaults.bool(forKey: "SeesionUserLoggedIN") {
            setLoggedOutState()
        } else {
            setLoggedInState()
        }

        loggedOutAlert = UIAlertController(
            title: "Log Out?",
            message: "Are you sure?",
            preferredStyle: .alert
        )

        let noButton = UIAlertAction(title: "Yes, Log Out!", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.defaults.set(false, forKey: "SeesionUserLoggedIN")
            self.defaults.set("", forKey: "SessionLoggedInuserEmail")
            self.defaults.set("", forKey: "LoggedInUsersDetail")
            self.defaults.synchronize()
        }
        let yesButton = UIAlertAction(title: "Log Back In!", style: .default, handler: nil)

        loggedOutAlert.addAction(yesButton)
        loggedOutAlert.addAction(noButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.reloadInputViews()
        if !defaults.bool(forKey: "SeesionUserLoggedIN") {
            setLoggedOutState()
        } else {
            setLoggedInStateAppeared()
        }
    }

    private func setLoggedOutState() {
        firstName.text = ""
        lastName.text = ""
        email.text = ""
        phone.text = ""
        country.text = ""
        state.text = ""
        city.text = ""
        postalCode.text = ""
        address.text = ""
        firstName.isHidden = true
        lastName.isHidden = true
        email.isHidden = true
        phone.isHidden = true
        country.isHidden = true
        state.isHidden = true
        city.isHidden = true
        postalCode.isHidden = true
        address.isHidden = true
        firstNameOutlet.isHidden = true
        lastNameOutlet.isHidden = true
        emailOutlet.isHidden = true
        phoneOutlet.isHidden = true
        countryOutlet.isHidden = true
        stateOutlet.isHidden = true
        cityOutlet.isHidden = true
        postalCodeOutlet.isHidden = true
        addressOutlet.isHidden = true
        goToLoginButtonOutlet.isHidden = false
        userHistoryOutlet.isEnabled = false
        userHistoryOutlet.tintColor = .clear
        userLogOutOutlet.isEnabled = false
        userLogOutOutlet.tintColor = .clear
    }

    private func setLoggedInState() {
        firstName.isHidden = false
        lastName.isHidden = false
        email.isHidden = false
        phone.isHidden = false
        country.isHidden = false
        state.isHidden = false
        city.isHidden = false
        postalCode.isHidden = false
        address.isHidden = false
        firstNameOutlet.isHidden = false
        lastNameOutlet.isHidden = false
        emailOutlet.isHidden = false
        phoneOutlet.isHidden = false
        countryOutlet.isHidden = false
        stateOutlet.isHidden = false
        cityOutlet.isHidden = false
        postalCodeOutlet.isHidden = false
        addressOutlet.isHidden = false
        goToLoginButtonOutlet.isHidden = true
        userHistoryOutlet.isEnabled = true
        userHistoryOutlet.tintColor = UIColor(named: "Cornflower Blue")
        userLogOutOutlet.isEnabled = true
        userLogOutOutlet.tintColor = UIColor(named: "Cornflower Blue")

        userData = defaults.dictionary(forKey: "LoggedInUsersDetail")
        populateUserData()
    }

    private func setLoggedInStateAppeared() {
        firstName.isHidden = false
        lastName.isHidden = false
        email.isHidden = false
        phone.isHidden = false
        country.isHidden = false
        state.isHidden = false
        city.isHidden = false
        postalCode.isHidden = false
        address.isHidden = false
        firstNameOutlet.isHidden = false
        lastNameOutlet.isHidden = false
        emailOutlet.isHidden = false
        phoneOutlet.isHidden = false
        countryOutlet.isHidden = false
        stateOutlet.isHidden = false
        cityOutlet.isHidden = false
        postalCodeOutlet.isHidden = false
        addressOutlet.isHidden = false
        goToLoginButtonOutlet.isHidden = true
        userHistoryOutlet.isEnabled = false
        userHistoryOutlet.tintColor = .clear
        userLogOutOutlet.isEnabled = true
        userLogOutOutlet.tintColor = UIColor(named: "Cornflower Blue")

        userData = defaults.dictionary(forKey: "LoggedInUsersDetail")
        populateUserData()
    }

    private func populateUserData() {
        firstName.text = userData?["firstName"] as? String
        lastName.text = userData?["lastName"] as? String
        email.text = userData?["usersEmail"] as? String
        phone.text = userData?["phone"] as? String
        country.text = userData?["country"] as? String
        state.text = userData?["state"] as? String
        city.text = userData?["city"] as? String
        postalCode.text = userData?["postalCode"] as? String
        address.text = userData?["address"] as? String
    }

    @IBAction func theEditButtonForLoginOrEdit(_ sender: Any) {
        if !defaults.bool(forKey: "SeesionUserLoggedIN") {
            performSegue(withIdentifier: "loginAccountSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "editAccountSegue", sender: nil)
        }
    }

    @IBAction func goToLoginButton(_ sender: Any) {
        performSegue(withIdentifier: "loginAccountSegue", sender: nil)
    }

    @IBAction func userLogoutButton(_ sender: Any) {
        present(loggedOutAlert, animated: true, completion: nil)
    }
}
