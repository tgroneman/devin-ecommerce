import UIKit

@objc protocol TAPageControlDelegate: AnyObject {
    @objc optional func taPageControl(_ pageControl: TAPageControl, didSelectPageAt index: Int)
}

class TAPageControl: UIControl {

    private let kDefaultSpacingBetweenDots: Int = 8
    private let kDefaultDotSize = CGSize(width: 8, height: 8)

    var dotViewClass: TAAbstractDotView.Type? = TAAnimatedDotView.self {
        didSet {
            _dotSize = .zero
            resetDotViews()
        }
    }

    var dotImage: UIImage? {
        didSet {
            resetDotViews()
            dotViewClass = nil
        }
    }

    var currentDotImage: UIImage? {
        didSet {
            resetDotViews()
            dotViewClass = nil
        }
    }

    private var _dotSize: CGSize = .zero
    var dotSize: CGSize {
        get {
            if let dotImage = dotImage, _dotSize == .zero {
                _dotSize = dotImage.size
            } else if dotViewClass != nil && _dotSize == .zero {
                _dotSize = kDefaultDotSize
                return _dotSize
            }
            return _dotSize
        }
        set {
            _dotSize = newValue
        }
    }

    var spacingBetweenDots: Int = 8 {
        didSet {
            resetDotViews()
        }
    }

    weak var delegate: TAPageControlDelegate?

    var numberOfPages: Int = 0 {
        didSet {
            resetDotViews()
        }
    }

    private var _currentPage: Int = 0
    var currentPage: Int {
        get { return _currentPage }
        set {
            if numberOfPages == 0 || newValue == _currentPage {
                _currentPage = newValue
                return
            }
            changeActivity(false, atIndex: _currentPage)
            _currentPage = newValue
            changeActivity(true, atIndex: _currentPage)
        }
    }

    var hidesForSinglePage: Bool = false
    var shouldResizeFromCenter: Bool = true

    private var dots: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        dotViewClass = TAAnimatedDotView.self
        spacingBetweenDots = kDefaultSpacingBetweenDots
        numberOfPages = 0
        _currentPage = 0
        hidesForSinglePage = false
        shouldResizeFromCenter = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view != self {
            if let index = dots.firstIndex(of: touch.view!) {
                delegate?.taPageControl?(self, didSelectPageAt: index)
            }
        }
    }

    override func sizeToFit() {
        updateFrame(true)
    }

    func sizeForNumberOfPages(_ pageCount: Int) -> CGSize {
        return CGSize(
            width: (dotSize.width + CGFloat(spacingBetweenDots)) * CGFloat(pageCount) - CGFloat(spacingBetweenDots),
            height: dotSize.height
        )
    }

    private func updateDots() {
        if numberOfPages == 0 { return }

        for i in 0..<numberOfPages {
            let dot: UIView
            if i < dots.count {
                dot = dots[i]
            } else {
                dot = generateDotView()
            }
            updateDotFrame(dot, atIndex: i)
        }

        changeActivity(true, atIndex: _currentPage)
        hideForSinglePage()
    }

    private func updateFrame(_ overrideExistingFrame: Bool) {
        let center = self.center
        let requiredSize = sizeForNumberOfPages(numberOfPages)

        if overrideExistingFrame || (frame.width < requiredSize.width || frame.height < requiredSize.height) {
            frame = CGRect(x: frame.minX, y: frame.minY, width: requiredSize.width, height: requiredSize.height)
            if shouldResizeFromCenter {
                self.center = center
            }
        }
        resetDotViews()
    }

    private func updateDotFrame(_ dot: UIView, atIndex index: Int) {
        let x = (dotSize.width + CGFloat(spacingBetweenDots)) * CGFloat(index) + ((frame.width - sizeForNumberOfPages(numberOfPages).width) / 2)
        let y = (frame.height - dotSize.height) / 2
        dot.frame = CGRect(x: x, y: y, width: dotSize.width, height: dotSize.height)
    }

    private func generateDotView() -> UIView {
        let dotView: UIView
        if let dotViewClass = dotViewClass {
            dotView = dotViewClass.init(frame: CGRect(x: 0, y: 0, width: dotSize.width, height: dotSize.height))
        } else if let dotImage = dotImage {
            let imageView = UIImageView(image: dotImage)
            imageView.frame = CGRect(x: 0, y: 0, width: dotSize.width, height: dotSize.height)
            dotView = imageView
        } else {
            dotView = UIView(frame: CGRect(x: 0, y: 0, width: dotSize.width, height: dotSize.height))
        }

        addSubview(dotView)
        dots.append(dotView)
        dotView.isUserInteractionEnabled = true

        return dotView
    }

    private func changeActivity(_ active: Bool, atIndex index: Int) {
        guard index < dots.count else { return }
        if dotViewClass != nil {
            if let abstractDotView = dots[index] as? TAAbstractDotView {
                abstractDotView.changeActivityState(active)
            }
        } else if dotImage != nil && currentDotImage != nil {
            if let dotView = dots[index] as? UIImageView {
                dotView.image = active ? currentDotImage : dotImage
            }
        }
    }

    private func resetDotViews() {
        for dotView in dots {
            dotView.removeFromSuperview()
        }
        dots.removeAll()
        updateDots()
    }

    private func hideForSinglePage() {
        if dots.count == 1 && hidesForSinglePage {
            isHidden = true
        } else {
            isHidden = false
        }
    }
}
