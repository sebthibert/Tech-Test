import Foundation

class ProductListingViewModel {
  private let service: ProductListingService
  private let user: User
  private(set) var products: [ProductListingProduct] = []

  init(service: ProductListingService, user: User) {
    self.service = service
    self.user = user
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

