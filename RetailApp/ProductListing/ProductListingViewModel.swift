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
    service.getProductListing { [weak self] result in
      do {
        self?.products = try result.unwrapped().products
        completion()
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}

