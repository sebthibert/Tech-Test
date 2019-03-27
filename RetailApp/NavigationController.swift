import UIKit

class NavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let service = ProductListingServiceImplementation(api: API())
    let viewModel = ProductListingViewModel(service: service)
    let viewController = ProductListingViewController(viewModel: viewModel, priceFormatter: PriceFormatterImplementation())
    navigationBar.prefersLargeTitles = true
    viewControllers = [viewController]
  }
}
