import UIKit

class AccountCRUDViewController: UIViewController {

    @IBOutlet var firstName: UITextField?
    @IBOutlet var lastName: UITextField?
    @IBOutlet var email: UITextField?
    @IBOutlet var password: UITextField?
    @IBOutlet var confirmPassword: UITextField?
    @IBOutlet var phone: UITextField?
    @IBOutlet var country: UITextField?
    @IBOutlet var state: UITextField?
    @IBOutlet var city: UITextField?
    @IBOutlet var postalCode: UITextField?
    @IBOutlet var address: UITextField?
    @IBOutlet var validationStatus: UILabel?

    var userAlreadyRegistered: UIAlertController?

    @IBOutlet var editAccountFirstName: UITextField?
    @IBOutlet var editAccountLastName: UITextField?
    @IBOutlet var editAccountEmail: UITextField?
    @IBOutlet var editAccountPassword: UITextField?
    @IBOutlet var editAccountConfirmPassword: UITextField?
    @IBOutlet var editAccountPhone: UITextField?
    @IBOutlet var editAccountCountry: UITextField?
    @IBOutlet var editAccountState: UITextField?
    @IBOutlet var editAccountCity: UITextField?
    @IBOutlet var editAccountPostalCode: UITextField?
    @IBOutlet var editAccountAddress: UITextField?
    @IBOutlet var editAccountValidationStatus: UILabel?

    var registrationComplete: UIAlertController!

    private let viewModel = AccountCRUDViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        validationStatus?.isHidden = true
        editAccountValidationStatus?.isHidden = true

        let validatorObj = viewModel.validationHelper

        if let f = firstName, let vs = validationStatus {
            f.ajw_attachValidator(validatorObj.requiredMinLengthValidator("First Name is Required!", integerForMinLength: 1, minLengthErrorMessage: "It has to be something at least!", withLabelForValidationRules: vs))
        }
        if let f = editAccountFirstName, let vs = validationStatus ?? editAccountValidationStatus {
            f.ajw_attachValidator(validatorObj.requiredMinLengthValidator("First Name is Required!", integerForMinLength: 1, minLengthErrorMessage: "It has to be something at least!", withLabelForValidationRules: vs))
        }

        if let f = lastName, let vs = validationStatus {
            f.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Last Name is Required!", integerForMinLength: 1, minLengthErrorMessage: "Last Name Please!", withLabelForValidationRules: vs))
        }
        if let f = editAccountLastName, let vs = validationStatus ?? editAccountValidationStatus {
            f.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Last Name is Required!", integerForMinLength: 1, minLengthErrorMessage: "Last Name Please!", withLabelForValidationRules: vs))
        }

        if let f = phone, let vs = validationStatus {
            f.ajw_attachValidator(validatorObj.phoneValidator(vs))
        }
        if let f = editAccountPhone, let vs = validationStatus ?? editAccountValidationStatus {
            f.ajw_attachValidator(validatorObj.phoneValidator(vs))
        }

        if let f = email, let vs = validationStatus {
            f.ajw_attachValidator(validatorObj.emailValidator(vs))
        }
        if let f = editAccountEmail, let vs = validationStatus ?? editAccountValidationStatus {
            f.ajw_attachValidator(validatorObj.emailValidator(vs))
        }

        if let f = password, let vs = validationStatus {
            f.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Password is required!", integerForMinLength: 6, minLengthErrorMessage: "It must be at least 6 charecters!", withLabelForValidationRules: vs))
        }
        if let f = editAccountPassword, let vs = validationStatus ?? editAccountValidationStatus {
            f.ajw_attachValidator(validatorObj.requiredMinLengthValidator("Password is required!", integerForMinLength: 6, minLengthErrorMessage: "It must be at least 6 charecters!", withLabelForValidationRules: vs))
        }

        if let f = confirmPassword, let vs = validationStatus {
            f.ajw_attachValidator(validatorObj.requiredValidator("Required and Should be same as 'Password'", withLabelForValidationRules: vs))
        }
        if let f = editAccountConfirmPassword, let vs = validationStatus ?? editAccountValidationStatus {
            f.ajw_attachValidator(validatorObj.requiredValidator("Required and Should be same as 'Password'", withLabelForValidationRules: vs))
        }

        if let vs = validationStatus {
            country?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
            state?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
            city?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
            postalCode?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
            address?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
        }
        if let vs = validationStatus ?? editAccountValidationStatus {
            editAccountCountry?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
            editAccountState?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
            editAccountCity?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
            editAccountPostalCode?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
            editAccountAddress?.ajw_attachValidator(validatorObj.requiredValidator("Required!", withLabelForValidationRules: vs))
        }

        if !viewModel.isUserLoggedIn {
            print("user not logged IN")
        } else {
            viewModel.loadUserData()
            editAccountFirstName?.text = viewModel.editFirstName
            editAccountLastName?.text = viewModel.editLastName
            editAccountEmail?.text = viewModel.editEmail
            editAccountPhone?.text = viewModel.editPhone
            editAccountCountry?.text = viewModel.editCountry
            editAccountState?.text = viewModel.editState
            editAccountCity?.text = viewModel.editCity
            editAccountPostalCode?.text = viewModel.editPostalCode
            editAccountAddress?.text = viewModel.editAddress
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
        let encryptedPassword = viewModel.encryptPassword(password?.text ?? "")
        let encryptedConfirmedPassword = viewModel.encryptPassword(confirmPassword?.text ?? "")
        let keyParts = ["sdfsdfsd38792F423F4528482B4D625", "0655368566D597133743677397A244", "32646294A40kjsdhfkjsdhf"]
        let dataToSend: [String: Any] = [
            "secureKeyForServerAccess_Enabled": keyParts.joined(),
            "actionRequest": "REGISTER_USER",
            "firstName": firstName?.text ?? "",
            "lastName": lastName?.text ?? "",
            "email": email?.text ?? "",
            "password": encryptedPassword,
            "confirmPassword": encryptedConfirmedPassword,
            "phone": phone?.text ?? "",
            "country": country?.text ?? "",
            "state": state?.text ?? "",
            "city": city?.text ?? "",
            "postalCode": postalCode?.text ?? "",
            "address": address?.text ?? ""
        ]
        viewModel.accountOps.sendRequestToServer(dataToSend) { [weak self] error, success, customErrorMessage in
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
        guard let fn = firstName, let ln = lastName, let em = email, let pw = password, let cp = confirmPassword, let ph = phone, let co = country, let st = state, let ci = city, let pc = postalCode, let ad = address else { return }
        if fn.hasText && ln.hasText && em.hasText && pw.hasText && cp.hasText && ph.hasText && co.hasText && st.hasText && ci.hasText && pc.hasText && ad.hasText {
            if viewModel.validateEmail(em.text ?? "") {
                if pw.text == cp.text {
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
        let encryptedPassword = viewModel.encryptPassword(editAccountPassword?.text ?? "")
        let encryptedConfirmedPassword = viewModel.encryptPassword(editAccountConfirmPassword?.text ?? "")
        let keyParts = ["sdfsdfsd38792F423F4528482B4D625", "0655368566D597133743677397A244", "32646294A40kjsdhfkjsdhf"]
        let dataToSend: [String: Any] = [
            "secureKeyForServerAccess_Enabled": keyParts.joined(),
            "actionRequest": "EDIT_USER",
            "firstName": editAccountFirstName?.text ?? "",
            "lastName": editAccountLastName?.text ?? "",
            "email": viewModel.storedUserEmail,
            "password": encryptedPassword,
            "confirmPassword": encryptedConfirmedPassword,
            "phone": editAccountPhone?.text ?? "",
            "country": editAccountCity?.text ?? "",
            "state": editAccountState?.text ?? "",
            "city": editAccountCity?.text ?? "",
            "postalCode": editAccountPostalCode?.text ?? "",
            "address": editAccountAddress?.text ?? ""
        ]
        viewModel.accountOps.sendRequestToServer(dataToSend) { [weak self] error, success, customErrorMessage in
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
        guard let fn = editAccountFirstName, let ln = editAccountLastName, let em = editAccountEmail, let pw = editAccountPassword, let cp = editAccountConfirmPassword, let ph = editAccountPhone, let co = editAccountCountry, let st = editAccountState, let ci = editAccountCity, let pc = editAccountPostalCode, let ad = editAccountAddress else { return }
        if fn.hasText && ln.hasText && em.hasText && pw.hasText && cp.hasText && ph.hasText && co.hasText && st.hasText && ci.hasText && pc.hasText && ad.hasText {
            if viewModel.validateEmail(em.text ?? "") {
                if pw.text == cp.text {
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
