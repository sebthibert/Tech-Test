import Foundation

struct ProductListingProduct: Codable {
  let id: String
  let imageKey: String
  let name: String
  let offerIds: [String]
  let price: Price
}
