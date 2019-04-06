import Foundation

class ProductListingViewModel {
  private let productListingService: ProductListingService
  private let user: User

  let products: Observable<[ProductListingProduct]>

  private var productListing: ProductListing? {
    didSet {
      guard let value = productListing else {
        return
      }
      updateObservables(productListing: value)
    }
  }

  init(productListingService: ProductListingService, user: User) {
    self.productListingService = productListingService
    self.user = user
    self.products = Observable<[ProductListingProduct]>([])
    getProducts()
  }

  private func updateObservables(productListing: ProductListing) {
    products.value = filterProductOfferIdsWithUserOfferIds(productListing.products, user: user)
  }

  private func getProducts() {
    productListingService.getProductListing { [weak self] result in
      do {
        self?.productListing = try result.unwrapped()
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

