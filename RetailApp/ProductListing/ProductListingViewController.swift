import UIKit

class ProductListingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  @IBOutlet private var collectionView: UICollectionView!
  private let viewModel: ProductListingViewModel
  private let priceFormatter: PriceFormatter

  init(viewModel: ProductListingViewModel, priceFormatter: PriceFormatter) {
    self.viewModel = viewModel
    self.priceFormatter = priceFormatter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Tops"
    collectionView.register(UINib(nibName: "ProductListingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductListingCollectionViewCell")
    viewModel.getProducts { [weak self] in self?.collectionView.reloadData() }
  }

  // MARK: UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.products.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListingCollectionViewCell", for: indexPath) as! ProductListingCollectionViewCell
    let product = viewModel.products[indexPath.item]
    cell.configure(imageKey: product.imageKey, title: product.name, price: priceFormatter.formatPrice(product.price))
    return cell
  }

  // MARK: UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

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
