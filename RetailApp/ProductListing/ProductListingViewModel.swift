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
      guard let self = self else { return }
      do {
        self.products = try self.filterProductOfferIdsWithUserOfferIds(result.unwrapped().products, user: self.user)
        completion()
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  private func filterProductOfferIdsWithUserOfferIds(_ products: [ProductListingProduct], user: User) -> [ProductListingProduct] {
    var filteredProducts: [ProductListingProduct] = []
    products.forEach {
      let offerIds = $0.offerIds.filter { user.offers.map { $0.id }.contains($0) }
      filteredProducts.append(ProductListingProduct(id: $0.id, imageKey: $0.imageKey, name: $0.name, offerIds: offerIds, price: $0.price))
    }
    return filteredProducts
  }
}

