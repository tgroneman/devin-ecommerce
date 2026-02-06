import Foundation
import CommonCrypto

class AccountOperations: NSObject {
    @objc static let sharedInstance = AccountOperations()

    private var itemArray: [Any] = []

    override init() {
        super.init()
    }

    @objc func sha1(_ str: String) -> String {
        let data = Data(str.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private static var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()

    @objc func getURLSession() -> URLSession {
        return AccountOperations.urlSession
    }

    @objc func sendRequestToServer(_ dataToSend: [String: Any], callback: @escaping (Error?, Bool, String?) -> Void) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }

        guard let requestData = jsonString.data(using: .utf8),
              let url = URL(string: "https://apiforios.appendtech.com/urltosendrequestwithdata.php?InitialSecureKey:ououhkju59703373367639792F423F4528482B4D6251655468576D5A7134743777217A25iuiu") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("theHeaderString", forHTTPHeaderField: "AmrLagto")
        request.setValue("\(requestData.count)", forHTTPHeaderField: "Content-Length")
        request.httpBody = requestData

        let task = getURLSession().dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                var customErrorMessage: String?
                if let error = error {
                    customErrorMessage = "Something Went Wrong! Please try again after Sometime"
                    callback(error, true, customErrorMessage)
                } else if let data = data {
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                          let responseDictionary = jsonObject as? [String: Any],
                          let httpResponse = response as? HTTPURLResponse else {
                        let anotherCustomErrorMessage = "Server Busy! Please Come Back After Some Time"
                        callback(error, false, anotherCustomErrorMessage)
                        return
                    }

                    let defaults = UserDefaults.standard
                    if httpResponse.statusCode == 200,
                       (responseDictionary["RequestExecuted"] as? String) == "TRUE" {

                        if (responseDictionary["actionRequest"] as? String) == "REGISTER_USER" {
                            if (responseDictionary["NullFieldsFound"] as? String) == "TRUE" {
                                customErrorMessage = "Every Form Field is required for Successful purchase"
                                callback(error, true, customErrorMessage)
                            } else if (responseDictionary["userRegistrationPassMisMatch"] as? String) == "YES" {
                                customErrorMessage = "Password and Confirm Password must be same!"
                                callback(error, true, customErrorMessage)
                            } else if (responseDictionary["userAlreadyRegistered"] as? String) == "YES" {
                                customErrorMessage = "This email is already registered"
                                callback(error, true, customErrorMessage)
                            } else {
                                customErrorMessage = "Registraition Successful"
                                callback(error, true, customErrorMessage)
                            }
                        } else if (responseDictionary["actionRequest"] as? String) == "CHECK_USER_LOGIN" {
                            if (responseDictionary["userExist"] as? String) == "TRUE" {
                                defaults.set(true, forKey: "SeesionUserLoggedIN")
                                defaults.set(responseDictionary["usersEmail"], forKey: "SessionLoggedInuserEmail")
                                defaults.set(responseDictionary, forKey: "LoggedInUsersDetail")
                                defaults.synchronize()
                                customErrorMessage = "Login Successful"
                                callback(error, true, customErrorMessage)
                            } else if (responseDictionary["passwordMismatch"] as? String) == "YES" {
                                defaults.set(false, forKey: "SeesionUserLoggedIN")
                                defaults.set("", forKey: "SessionLoggedInuserEmail")
                                defaults.synchronize()
                                customErrorMessage = "Wrong Password!"
                                callback(error, true, customErrorMessage)
                            } else {
                                defaults.set(false, forKey: "SeesionUserLoggedIN")
                                defaults.set("", forKey: "SessionLoggedInuserEmail")
                                defaults.synchronize()
                                customErrorMessage = "User Does Not Exist!"
                                callback(error, true, customErrorMessage)
                            }
                        } else if (responseDictionary["actionRequest"] as? String) == "EDIT_USER" {
                            if (responseDictionary["NullFieldsFound"] as? String) == "TRUE" {
                                customErrorMessage = "Every Field is Required!"
                                callback(error, true, customErrorMessage)
                            } else if (responseDictionary["userUpdatePassMisMatch"] as? String) == "YES" {
                                customErrorMessage = "Password and Confirm Password must be same!"
                                callback(error, true, customErrorMessage)
                            } else {
                                customErrorMessage = "Update Successful"
                                callback(error, true, customErrorMessage)
                            }
                        } else {
                            customErrorMessage = "Check Your Request!"
                            callback(error, true, customErrorMessage)
                        }
                    } else {
                        let anotherCustomErrorMessage = "Server Busy! Please Come Back After Some Time"
                        callback(error, false, anotherCustomErrorMessage)
                    }
                }
            }
        }
        task.resume()
    }

    @objc func validateEmailAccount(_ checkString: String) -> Bool {
        let laxString = ".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", laxString)
        return emailTest.evaluate(with: checkString)
    }
}
