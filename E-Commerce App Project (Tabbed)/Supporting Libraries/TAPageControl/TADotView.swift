import UIKit

class TADotView: TAAbstractDotView {

    private let kAnimateDuration: TimeInterval = 1
    private let activeColor = UIColor(white: 0.2, alpha: 1)
    private let inactiveColor = UIColor(white: 0.2, alpha: 0.3)

    required init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = frame.width / 2
        backgroundColor = inactiveColor
    }

    override func changeActivityState(_ active: Bool) {
        if active {
            backgroundColor = activeColor
        } else {
            backgroundColor = inactiveColor
        }
    }
}
