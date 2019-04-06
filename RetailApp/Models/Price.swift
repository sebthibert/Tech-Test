import Foundation

struct Price: Codable, Equatable {
  let currentPrice: Int
  let originalPrice: Int?
  let currencyCode: String
}

