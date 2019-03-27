import Foundation

protocol ProductListingService {
  func getProducts(completion: @escaping (Result<ProductListing, Error>) -> Void)
}

class ProductListingServiceImplementation: ProductListingService {
  private let api: API

  init(api: API) {
    self.api = api
  }

  func getProducts(completion: @escaping (Result<ProductListing, Error>) -> Void) {
    let resource = Resource<ProductListing>(path: "api/products")
    api.load(resource, completion: completion)
  }
}
