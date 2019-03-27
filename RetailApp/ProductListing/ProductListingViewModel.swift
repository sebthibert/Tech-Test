import Foundation

class ProductListingViewModel {
  private let service: ProductListingService
  private(set) var products: [ProductListingProduct] = []

  init(service: ProductListingService) {
    self.service = service
  }

  func getProducts(completion: @escaping () -> Void) {
    service.getProducts { [weak self] result in
      switch result {
      case .value(let productListing):
        self?.products = productListing.products
        completion()
      case .error(let error):
        print(error)
      }
    }
  }
}

