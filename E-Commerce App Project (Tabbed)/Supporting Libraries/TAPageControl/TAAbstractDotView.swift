import UIKit

class TAAbstractDotView: UIView {

    func changeActivityState(_ active: Bool) {
        preconditionFailure("changeActivityState: must be overridden in a subclass")
    }
}
