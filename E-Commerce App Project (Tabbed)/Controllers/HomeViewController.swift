import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, TAPageControlDelegate {

    private let viewModel = HomeViewModel()

    @IBOutlet var tvCollectionView: UICollectionView!
    @IBOutlet var laptopCollectionView: UICollectionView!
    @IBOutlet var desktopCollectionView: UICollectionView!
    @IBOutlet var mobileCollectionView: UICollectionView!
    @IBOutlet var tabletCollectionView: UICollectionView!

    @IBOutlet var sliderScrollView: UIScrollView!
    var sliderTimer: Timer?
    var sliderCustomPageControl: TAPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        sliderScrollView.delegate = self
        for i in 0..<viewModel.sliderImageNames.count {
            let imageView = UIImageView(frame: CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: sliderScrollView.frame.height))
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: viewModel.sliderImageNames[i])
            sliderScrollView.addSubview(imageView)
        }
        viewModel.sliderIndex = 0

        sliderCustomPageControl = TAPageControl(frame: CGRect(x: 20, y: sliderScrollView.frame.origin.y + sliderScrollView.frame.size.height, width: sliderScrollView.frame.size.width, height: 40))
        sliderCustomPageControl.delegate = self
        sliderCustomPageControl.numberOfPages = viewModel.sliderImageNames.count
        sliderCustomPageControl.dotSize = CGSize(width: 20, height: 20)
        sliderScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(viewModel.sliderImageNames.count), height: sliderScrollView.frame.height)
        sliderScrollView.addSubview(sliderCustomPageControl)

        tvCollectionView.dataSource = self
        tvCollectionView.delegate = self

        laptopCollectionView.dataSource = self
        laptopCollectionView.delegate = self

        desktopCollectionView.dataSource = self
        desktopCollectionView.delegate = self

        mobileCollectionView.dataSource = self
        mobileCollectionView.delegate = self

        tabletCollectionView.dataSource = self
        tabletCollectionView.delegate = self

        viewModel.loadCategories()
    }

    private func collectionViewTag(for collectionView: UICollectionView) -> Int {
        if collectionView == tvCollectionView { return 0 }
        if collectionView == laptopCollectionView { return 1 }
        if collectionView == desktopCollectionView { return 2 }
        if collectionView == mobileCollectionView { return 3 }
        return 4
    }

    private func cellIdentifier(for collectionView: UICollectionView) -> String {
        if collectionView == tvCollectionView { return "tvCellIdentifier" }
        if collectionView == laptopCollectionView { return "laptopCellIdentifier" }
        if collectionView == desktopCollectionView { return "desktopCellIdentifier" }
        if collectionView == mobileCollectionView { return "mobileCellIdentifiernow" }
        return "tabletCellIdentifier"
    }

    private func cellImageTag(for collectionView: UICollectionView) -> Int {
        if collectionView == tvCollectionView { return 101 }
        if collectionView == laptopCollectionView { return 201 }
        if collectionView == desktopCollectionView { return 301 }
        if collectionView == mobileCollectionView { return 401 }
        return 501
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = collectionViewTag(for: collectionView)
        let individualData = viewModel.item(forCollectionViewTag: tag, at: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier(for: collectionView), for: indexPath)

        let baseTag = cellImageTag(for: collectionView)
        let itemImage = cell.viewWithTag(baseTag) as? UIImageView
        let itemNameLabel = cell.viewWithTag(baseTag + 1) as? UILabel
        let itemPriceLabel = cell.viewWithTag(baseTag + 2) as? UILabel

        if let url = URL(string: individualData.photoURL), let data = try? Data(contentsOf: url) {
            itemImage?.image = UIImage(data: data)
        }
        itemNameLabel?.text = individualData.itemName
        itemPriceLabel?.text = viewModel.formatPrice(individualData.price)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tag = collectionViewTag(for: collectionView)
        return viewModel.numberOfItems(forCollectionViewTag: tag)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleItemView = storyboard?.instantiateViewController(withIdentifier: "singleItemViewStoryBoardIdentifier") as? SingleItemViewController else { return }

        let tag = collectionViewTag(for: collectionView)
        let individualData = viewModel.item(forCollectionViewTag: tag, at: indexPath.row)

        singleItemView.itemObjectReceived = individualData
        if let url = URL(string: individualData.photoURL) {
            singleItemView.setItemImageData = try? Data(contentsOf: url)
        }
        singleItemView.setItemName = individualData.itemName
        singleItemView.setItemCategory = individualData.itemCategory
        singleItemView.setItemID = individualData.ID
        singleItemView.setItemPrice = NSNumber(value: individualData.price)
        singleItemView.setItemBrand = individualData.brand
        singleItemView.setItemQuality = individualData.quality

        navigationController?.pushViewController(singleItemView, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sliderTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runImages), userInfo: nil, repeats: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let timer = sliderTimer {
            timer.invalidate()
            sliderTimer = nil
        }
    }

    @objc func runImages() {
        sliderCustomPageControl.currentPage = viewModel.sliderIndex
        viewModel.advanceSliderIndex()
        taPageControl(sliderCustomPageControl, didSelectPageAt: viewModel.sliderIndex)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        sliderCustomPageControl.currentPage = pageIndex
        viewModel.sliderIndex = pageIndex
    }

    func taPageControl(_ pageControl: TAPageControl, didSelectPageAt currentIndex: Int) {
        viewModel.sliderIndex = currentIndex
        sliderScrollView.scrollRectToVisible(CGRect(x: view.frame.width * CGFloat(currentIndex), y: 0, width: view.frame.width, height: sliderScrollView.frame.height), animated: true)
    }

    @IBAction func televisionCategoryButton(_ sender: UIButton) {
        navigateToCategory(tag: 0)
    }

    @IBAction func laptopCategoryButton(_ sender: UIButton) {
        navigateToCategory(tag: 1)
    }

    @IBAction func desktopCategoryButton(_ sender: UIButton) {
        navigateToCategory(tag: 2)
    }

    @IBAction func mobileCategoryButton(_ sender: UIButton) {
        navigateToCategory(tag: 3)
    }

    @IBAction func tabletCategoryButton(_ sender: UIButton) {
        navigateToCategory(tag: 4)
    }

    private func navigateToCategory(tag: Int) {
        guard let categoryItemsView = storyboard?.instantiateViewController(withIdentifier: "categoryItemViewStoryBoardIdentifier") as? CategoryItemsViewController else { return }
        categoryItemsView.receivedCategoryItemsList = viewModel.categoryItems(forCollectionViewTag: tag)
        categoryItemsView.receivedCategoryName = viewModel.categoryName(forCollectionViewTag: tag)
        navigationController?.pushViewController(categoryItemsView, animated: true)
    }
}
