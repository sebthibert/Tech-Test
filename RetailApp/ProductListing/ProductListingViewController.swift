import UIKit

protocol ProductListingViewControllerDelegate: AnyObject {
  func didSelectProduct(_ product: ProductListingProduct, withImage image: UIImage?)
}

class ProductListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  @IBOutlet private var collectionView: UICollectionView!
  private let viewModel: ProductListingViewModel
  private let priceFormatter: PriceFormatter
  private weak var delegate: ProductListingViewControllerDelegate?

  init(viewModel: ProductListingViewModel, priceFormatter: PriceFormatter, delegate: ProductListingViewControllerDelegate) {
    self.viewModel = viewModel
    self.priceFormatter = priceFormatter
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Tops"
    collectionView.register(UINib(nibName: "ProductListingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductListingCollectionViewCell")
    bind()
  }

  deinit {
    viewModel.products.unbind(self)
  }

  private func bind() {
    viewModel.products.bind(self) { [weak self] _ in self?.collectionView.reloadData() }
  }

  // MARK: UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.products.value.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListingCollectionViewCell", for: indexPath) as! ProductListingCollectionViewCell
    let product = viewModel.products.value[indexPath.item]
    cell.configure(imageKey: product.imageKey, title: product.name, price: priceFormatter.formatPrice(product.price), badge: viewModel.badgeNameForOfferWithId(product.offerIds.first))
    return cell
  }

  // MARK: UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! ProductListingCollectionViewCell
    delegate?.didSelectProduct(viewModel.products.value[indexPath.item], withImage: cell.productImageView.image)
  }

  // MARK: UICollectionViewDelegateFlowLayout

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let margin: CGFloat = 10
    let columnCount: CGFloat = 2
    let marginCount = columnCount + 1
    let marginWhitespace = margin * marginCount
    let width = (collectionView.frame.width - marginWhitespace) / 2
    let height = width * 1.7
    return CGSize(width: width, height: height)
  }
}
