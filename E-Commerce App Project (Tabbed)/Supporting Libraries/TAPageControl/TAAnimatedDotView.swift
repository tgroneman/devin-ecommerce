import UIKit

class TAAnimatedDotView: TAAbstractDotView {

    private let kAnimateDuration: TimeInterval = 1
    private let dotColor = UIColor(white: 0.2, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = frame.width / 2
        layer.borderColor = dotColor.cgColor
        layer.borderWidth = 2
    }

    override func changeActivityState(_ active: Bool) {
        if active {
            animateToActiveState()
        } else {
            animateToDeactiveState()
        }
    }

    private func animateToActiveState() {
        UIView.animate(withDuration: kAnimateDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -20, options: .curveLinear, animations: {
            self.backgroundColor = self.dotColor
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: nil)
    }

    private func animateToDeactiveState() {
        UIView.animate(withDuration: kAnimateDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.backgroundColor = .clear
            self.transform = .identity
        }, completion: nil)
    }
}
