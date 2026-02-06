import UIKit

class AccountCRUDViewController: UIViewController {

    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var country: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var postalCode: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var validationStatus: UILabel!

    var userAlreadyRegistered: UIAlertController?

    @IBOutlet var editAccountFirstName: UITextField!
    @IBOutlet var editAccountLastName: UITextField!
    @IBOutlet var editAccountEmail: UITextField!
    @IBOutlet var editAccountPassword: UITextField!
    @IBOutlet var editAccountConfirmPassword: UITextField!
    @IBOutlet var editAccountPhone: UITextField!
    @IBOutlet var editAccountCountry: UITextField!
    @IBOutlet var editAccountState: UITextField!
    @IBOutlet var editAccountCity: UITextField!
    @IBOutlet var editAccountPostalCode: UITextField!
    @IBOutlet var editAccountAddress: UITextField!
    @IBOutlet var editAccountValidationStatus: UILabel!

    var registrationComplete: UIAlertController!

    private var accountOperationsObj: AccountOperations!
    private var validatorObj: Validation!
    private var defaults: UserDefaults!
    private var userData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        validationStatus.isHidden = true
        accountOperationsObj = AccountOperations()
        validatorObj = Validation()

        firstName.ajw_attachValidator(validatorObj.requiredMinLengthValidator("First Name is Required!", integerForMinLength: 1, minLengthErrorMessage: "It has to be something at least!", withLabelForValidationRules: validationStatus))
        editAccountFirstName.ajw_attachValidator(validatorObj.requiredMinLengthValidator("First Name is Required!", integerForMinLength: 1, minLengthErrorMessage: "It has to be something at least!", withLabelForValidationRules: validationStatus))

        lastName.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Last Name is Required!", integerForMinLength: 1, minLengthErrorMessage: "Last Name Please!", withLabelForValidationRules: validationStatus))
        editAccountLastName.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Last Name is Required!", integerForMinLength: 1, minLengthErrorMessage: "Last Name Please!", withLabelForValidationRules: validationStatus))

        phone.ajw_attachValidator(validatorObj.phoneValidator(validationStatus))
        editAccountPhone.ajw_attachValidator(validatorObj.phoneValidator(validationStatus))

        email.ajw_attachValidator(validatorObj.emailValidator(validationStatus))
        editAccountEmail.ajw_attachValidator(validatorObj.emailValidator(validationStatus))

        password.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Password is required!", integerForMinLength: 6, minLengthErrorMessage: "It must be at least 6 charecters!", withLabelForValidationRules: validationStatus))
        editAccountPassword.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Password is required!", integerForMinLength: 6, minLengthErrorMessage: "It must be at least 6 charecters!", withLabelForValidationRules: validationStatus))

        confirmPassword.ajw_attachValidator(validatorObj.requiredValidator("Required and Should be same as 'Password'", withLabelForValidationRules: validationStatus))
        editAccountConfirmPassword.ajw_attachValidator(validatorObj.requiredValidator("Required and Should be same as 'Password'", withLabelForValidationRules: validationStatus))

        country.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        state.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        city.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        postalCode.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        address.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountCountry.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountState.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountCity.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountPostalCode.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))
        editAccountAddress.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: validationStatus))

        defaults = UserDefaults.standard
        if !defaults.bool(forKey: "SeesionUserLoggedIN") {
            print("user not logged IN")
        } else {
            userData = defaults.dictionary(forKey: "LoggedInUsersDetail")
            editAccountFirstName.text = userData?["firstName"] as? String
            editAccountLastName.text = userData?["lastName"] as? String
            editAccountEmail.text = userData?["usersEmail"] as? String
            editAccountPhone.text = userData?["phone"] as? String
            editAccountCountry.text = userData?["country"] as? String
            editAccountState.text = userData?["state"] as? String
            editAccountCity.text = userData?["city"] as? String
            editAccountPostalCode.text = userData?["postalCode"] as? String
            editAccountAddress.text = userData?["address"] as? String
        }

        registrationComplete = UIAlertController(
            title: "Registered!",
            message: "You've Successfully Registered!",
            preferredStyle: .alert
        )
        let yesButton = UIAlertAction(title: "Log In!", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        registrationComplete.addAction(yesButton)
    }

    func registrationAction(_ sender: UIButton) {
        let encryptedPassword = accountOperationsObj.sha1(password.text ?? "")
        let encryptedConfirmedPassword = accountOperationsObj.sha1(confirmPassword.text ?? "")
        let secureKeyForServerAccess = "sdfsdfsd38792F423F4528482B4D6250655368566D597133743677397A24432646294A40kjsdhfkjsdhf"
        let dataToSend: [String: Any] = [
            "secureKeyForServerAccess_Enabled": secureKeyForServerAccess,
            "actionRequest": "REGISTER_USER",
            "firstName": firstName.text ?? "",
            "lastName": lastName.text ?? "",
            "email": email.text ?? "",
            "password": encryptedPassword,
            "confirmPassword": encryptedConfirmedPassword,
            "phone": phone.text ?? "",
            "country": country.text ?? "",
            "state": state.text ?? "",
            "city": city.text ?? "",
            "postalCode": postalCode.text ?? "",
            "address": address.text ?? ""
        ]
        accountOperationsObj.sendRequestToServer(dataToSend) { [weak self] error, success, customErrorMessage in
            guard let self = self else { return }
            if success {
                if customErrorMessage == "Registraition Successful" {
                    sender.setTitle("Registered", for: .normal)
                    sender.backgroundColor = .blue
                    self.present(self.registrationComplete, animated: true, completion: nil)
                } else {
                    self.generalAlerts("Alert!", withMessage: customErrorMessage ?? "", withYesActionTitle: "Cancel Registration!", withNoActionTitle: "Fix it!")
                }
            } else {
                self.generalAlerts("Alert!", withMessage: customErrorMessage ?? "", withYesActionTitle: "Cancel Registration!", withNoActionTitle: "Fix it!")
                sender.setTitle("Try Again", for: .normal)
            }
        }
    }

    @IBAction func registerAccount(_ sender: UIButton) {
        if firstName.hasText && lastName.hasText && email.hasText && password.hasText && confirmPassword.hasText && phone.hasText && country.hasText && state.hasText && city.hasText && postalCode.hasText && address.hasText {
            if accountOperationsObj.validateEmailAccount(email.text ?? "") {
                if password.text == confirmPassword.text {
                    registrationAction(sender)
                } else {
                    generalAlerts("Password Mismatch!", withMessage: "Confirm password and password Must be same", withYesActionTitle: "Log In!", withNoActionTitle: "Back To Form!")
                }
            } else {
                generalAlerts("Invalid Email!", withMessage: "Please Insert a valid email address", withYesActionTitle: "Cancel Registration!", withNoActionTitle: "Ok!")
            }
        } else {
            generalAlerts("Empty Form", withMessage: "Please complete the form!", withYesActionTitle: "Already Registered!", withNoActionTitle: "Got it!")
        }
    }

    func editAction(_ sender: UIButton) {
        let encryptedPassword = accountOperationsObj.sha1(editAccountPassword.text ?? "")
        let encryptedConfirmedPassword = accountOperationsObj.sha1(editAccountConfirmPassword.text ?? "")
        let secureKeyForServerAccess = "sdfsdfsd38792F423F4528482B4D6250655368566D597133743677397A24432646294A40kjsdhfkjsdhf"
        let dataToSend: [String: Any] = [
            "secureKeyForServerAccess_Enabled": secureKeyForServerAccess,
            "actionRequest": "EDIT_USER",
            "firstName": editAccountFirstName.text ?? "",
            "lastName": editAccountLastName.text ?? "",
            "email": (userData?["usersEmail"] as? String) ?? "",
            "password": encryptedPassword,
            "confirmPassword": encryptedConfirmedPassword,
            "phone": editAccountPhone.text ?? "",
            "country": editAccountCity.text ?? "",
            "state": editAccountState.text ?? "",
            "city": editAccountCity.text ?? "",
            "postalCode": editAccountPostalCode.text ?? "",
            "address": editAccountAddress.text ?? ""
        ]
        accountOperationsObj.sendRequestToServer(dataToSend) { [weak self] error, success, customErrorMessage in
            guard let self = self else { return }
            if success {
                if customErrorMessage == "Update Successful" {
                    sender.setTitle("Account Updated!", for: .normal)
                    sender.backgroundColor = .blue
                    self.generalAlerts("Account Updated!", withMessage: "Your Account Have Successfully Updated!", withYesActionTitle: "Log In!", withNoActionTitle: "OK")
                    self.present(self.registrationComplete, animated: true, completion: nil)
                } else {
                    self.generalAlerts("Alert!", withMessage: customErrorMessage ?? "", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Fix it!")
                }
            } else {
                self.generalAlerts("Alert!", withMessage: customErrorMessage ?? "", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Fix it!")
                sender.setTitle("Try Again", for: .normal)
                sender.backgroundColor = .red
            }
        }
    }

    @IBAction func editAccount(_ sender: UIButton) {
        if editAccountFirstName.hasText && editAccountLastName.hasText && editAccountEmail.hasText && editAccountPassword.hasText && editAccountConfirmPassword.hasText && editAccountPhone.hasText && editAccountCountry.hasText && editAccountState.hasText && editAccountCity.hasText && editAccountPostalCode.hasText && editAccountAddress.hasText {
            if accountOperationsObj.validateEmailAccount(editAccountEmail.text ?? "") {
                if editAccountPassword.text == editAccountConfirmPassword.text {
                    editAction(sender)
                } else {
                    generalAlerts("Password Mismatch!", withMessage: "Confirm password and password Must be same", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Back To Form!")
                }
            } else {
                generalAlerts("Invalid Email!", withMessage: "Please Insert a valid email address", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Ok!")
            }
        } else {
            generalAlerts("Empty Form", withMessage: "Please complete the form!", withYesActionTitle: "Cancel Updating!", withNoActionTitle: "Got it!")
        }
    }

    func generalAlerts(_ alertTitle: String, withMessage alertMessage: String, withYesActionTitle yesActionTitle: String, withNoActionTitle noActionTitle: String) {
        let generalAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: yesActionTitle, style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let noAction = UIAlertAction(title: noActionTitle, style: .default, handler: nil)
        generalAlert.addAction(yesAction)
        generalAlert.addAction(noAction)
        present(generalAlert, animated: true, completion: nil)
    }
}
