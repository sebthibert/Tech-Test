import Foundation

struct User: Codable {
  let availableBadges: String
  let offers: [Offer]
}
