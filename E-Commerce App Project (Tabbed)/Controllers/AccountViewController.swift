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

    private let viewModel = AccountViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        if !viewModel.isUserLoggedIn {
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
            self?.viewModel.logout()
        }
        let yesButton = UIAlertAction(title: "Log Back In!", style: .default, handler: nil)

        loggedOutAlert.addAction(yesButton)
        loggedOutAlert.addAction(noButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.reloadInputViews()
        if !viewModel.isUserLoggedIn {
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
        setFieldsVisible(true)
        goToLoginButtonOutlet.isHidden = true
        userHistoryOutlet.isEnabled = true
        userHistoryOutlet.tintColor = UIColor(named: "Cornflower Blue")
        userLogOutOutlet.isEnabled = true
        userLogOutOutlet.tintColor = UIColor(named: "Cornflower Blue")

        viewModel.loadUserData()
        populateUserData()
    }

    private func setLoggedInStateAppeared() {
        setFieldsVisible(true)
        goToLoginButtonOutlet.isHidden = true
        userHistoryOutlet.isEnabled = false
        userHistoryOutlet.tintColor = .clear
        userLogOutOutlet.isEnabled = true
        userLogOutOutlet.tintColor = UIColor(named: "Cornflower Blue")

        viewModel.loadUserData()
        populateUserData()
    }

    private func setFieldsVisible(_ visible: Bool) {
        firstName.isHidden = !visible
        lastName.isHidden = !visible
        email.isHidden = !visible
        phone.isHidden = !visible
        country.isHidden = !visible
        state.isHidden = !visible
        city.isHidden = !visible
        postalCode.isHidden = !visible
        address.isHidden = !visible
        firstNameOutlet.isHidden = !visible
        lastNameOutlet.isHidden = !visible
        emailOutlet.isHidden = !visible
        phoneOutlet.isHidden = !visible
        countryOutlet.isHidden = !visible
        stateOutlet.isHidden = !visible
        cityOutlet.isHidden = !visible
        postalCodeOutlet.isHidden = !visible
        addressOutlet.isHidden = !visible
    }

    private func populateUserData() {
        firstName.text = viewModel.userFirstName
        lastName.text = viewModel.userLastName
        email.text = viewModel.userEmail
        phone.text = viewModel.userPhone
        country.text = viewModel.userCountry
        state.text = viewModel.userState
        city.text = viewModel.userCity
        postalCode.text = viewModel.userPostalCode
        address.text = viewModel.userAddress
    }

    @IBAction func theEditButtonForLoginOrEdit(_ sender: Any) {
        if !viewModel.isUserLoggedIn {
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
