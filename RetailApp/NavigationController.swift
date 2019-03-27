import UIKit

class NavigationController: UINavigationController, ProductListingViewControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    let service = ProductListingServiceImplementation(api: API())
    let viewModel = ProductListingViewModel(service: service)
    let viewController = ProductListingViewController(viewModel: viewModel, priceFormatter: PriceFormatterImplementation(), delegate: self)
    navigationBar.prefersLargeTitles = true
    viewControllers = [viewController]
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
