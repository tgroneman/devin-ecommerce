import Foundation

typealias AJWValidatorRemoteRuleCompletionHandler = (Bool, Error?) -> Void

class AJWValidatorRemoteRule: AJWValidatorRule {

    private var serviceURL: URL
    private var isWaitingForResponse: Bool = false
    private var isValidResponse: Bool = false
    private var requestCompletionHandler: AJWValidatorRemoteRuleCompletionHandler?

    private static var validatorSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        config.timeoutIntervalForRequest = 60.0
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()

    init(type: AJWValidatorRuleType, serviceURL url: URL, invalidMessage message: String?, completionHandler completion: @escaping AJWValidatorRemoteRuleCompletionHandler) {
        self.serviceURL = url
        self.requestCompletionHandler = completion
        super.init(type: type, invalidMessage: message)
    }

    func startRequestToValidateInstance(_ instance: Any?, withParams params: [String: Any]?) {
        isWaitingForResponse = true

        var requestParameters: [String: Any] = [:]
        requestParameters["instance"] = (instance as? String) ?? ""
        if let params = params {
            requestParameters["extra"] = params
        }

        guard let postData = try? JSONSerialization.data(withJSONObject: requestParameters, options: []) else { return }

        var request = URLRequest(url: serviceURL)
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = AJWValidatorRemoteRule.validatorSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.isWaitingForResponse = false

            if let error = error {
                self.isValidResponse = false
                DispatchQueue.main.async {
                    self.requestCompletionHandler?(false, error)
                }
            } else if let data = data {
                let responseString = String(data: data, encoding: .utf8) ?? ""
                let isValid = responseString == "true"
                self.isValidResponse = isValid
                DispatchQueue.main.async {
                    self.requestCompletionHandler?(isValid, nil)
                }
            }
        }
        task.resume()
    }
}
