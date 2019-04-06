import Foundation

struct ProductListingProduct: Codable, ProductRequest, Equatable {
  let id: String
  let imageKey: String
  let name: String
  let offerIds: [String]
  let price: Price
}
