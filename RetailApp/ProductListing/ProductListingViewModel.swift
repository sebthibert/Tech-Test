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

  func badgeNameForOfferWithId(_ id: String?) -> String? {
    guard let offer = user.offers.first(where: { $0.id == id }) else { return nil }
    let badges = user.availableBadges.replacingOccurrences(of: "||", with: " ").split(separator: " ").map { $0.split(separator: ":") }
    guard let badge = badges.first(where: { $0[1].contains(offer.type) }) else { return nil }
    return String(badge[0])
  }
}

