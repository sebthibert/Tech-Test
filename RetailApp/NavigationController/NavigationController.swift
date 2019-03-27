import UIKit

class NavigationController: UINavigationController, ProductListingViewControllerDelegate {
  private let viewModel: NavigationViewModel

  init(viewModel: NavigationViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationBar.prefersLargeTitles = true
    viewModel.getUser { [weak self] productListingViewModel in
      guard let self = self else { return }
      let viewController = ProductListingViewController(viewModel: productListingViewModel, priceFormatter: PriceFormatterImplementation(), delegate: self)
      self.viewControllers = [viewController]
    }
  }

  // MARK: ProductListingViewControllerDelegate

  func didSelectProduct(_ product: ProductListingProduct, withImage image: UIImage?) {
    let productDetailsService = ProductDetailsServiceImplementation(api: API())
    let imageService = ImageServiceImplementation(api: API())
    let viewModel = ProductDetailsViewModel(productRequest: product, listingImage: image, productDetailsService: productDetailsService, imageService: imageService)
    let viewController = ProductDetailsViewController(viewModel: viewModel)
    pushViewController(viewController, animated: true)
  }
}
