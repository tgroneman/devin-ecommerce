import UIKit

class TAAbstractDotView: UIView {

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func changeActivityState(_ active: Bool) {
        preconditionFailure("changeActivityState: must be overridden in a subclass")
    }
}
