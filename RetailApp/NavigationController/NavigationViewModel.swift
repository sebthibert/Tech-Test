import Foundation

class NavigationViewModel {
  private let service: UserService

  init(service: UserService) {
    self.service = service
  }

  func getUser(completion: @escaping (ProductListingViewModel) -> Void) {
    service.getUser(id: "2") { result in
      do {
        let productListingService = ProductListingServiceImplementation(api: API())
        try completion(ProductListingViewModel(productListingService: productListingService, user: result.unwrapped()))
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
