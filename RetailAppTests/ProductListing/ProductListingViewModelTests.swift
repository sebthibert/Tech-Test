import XCTest
@testable import RetailApp

class ProductListingViewModelTests: XCTestCase {
  let productListingWithoutOffers = ProductListing(products: [ProductListingProduct(id: "1", imageKey: "image", name: "name", offerIds: [], price: Price(currentPrice: 1, originalPrice: 2, currencyCode: "GBP"))])
  let productListingWithOffers = ProductListing(products: [ProductListingProduct(id: "1", imageKey: "image", name: "name", offerIds: ["1", "2"], price: Price(currentPrice: 1, originalPrice: 2, currencyCode: "GBP"))])
    let productListingWithMoreOffers = ProductListing(products: [ProductListingProduct(id: "1", imageKey: "image", name: "name", offerIds: ["1", "2", "3"], price: Price(currentPrice: 1, originalPrice: 2, currencyCode: "GBP"))])
  let userWithOffers = User(availableBadges: "loyalty:SLOTTED,BONUS||sale:PRIORITY_ACCESS,REDUCED", offers: [Offer(id: "1", title: "title", type: "BONUS"), Offer(id: "2", title: "title", type: "REDUCED")])
  let userWithoutOffers = User(availableBadges: "", offers: [])

  func test_init_startsFetchingProductListing() {
    let mockProductListingService = MockProductListingService()
    _ = ProductListingViewModel(productListingService: mockProductListingService, user: userWithOffers)
    XCTAssertEqual(mockProductListingService.callCount, 1)
  }

  func test_productsIsUpdated_whenProductListingIsSuccessfullyFetched() {
    let mockProductListingService = MockProductListingService()
    let viewModel = ProductListingViewModel(productListingService: mockProductListingService, user: userWithOffers)
    let actionExpectation = expectation(description: "updated")
    viewModel.products.bindNoFire(self) { products in
      XCTAssertEqual(products, self.productListingWithOffers.products)
      actionExpectation.fulfill()
    }
    mockProductListingService.lastCompletion?(.value(productListingWithOffers))
    wait(for: [actionExpectation], timeout: 0.1)
  }

  func test_productOfferIds_filterWithUserOfferIds_whenUserHasOfferIds() {
    let mockProductListingService = MockProductListingService()
    let viewModel = ProductListingViewModel(productListingService: mockProductListingService, user: userWithOffers)
    let actionExpectation = expectation(description: "updated")
    viewModel.products.bindNoFire(self) { products in
      XCTAssertEqual(products, self.productListingWithOffers.products)
      actionExpectation.fulfill()
    }
    mockProductListingService.lastCompletion?(.value(productListingWithMoreOffers))
    wait(for: [actionExpectation], timeout: 0.1)
  }

  func test_productOfferIds_empty_whenUserHasNoOfferIds() {
    let mockProductListingService = MockProductListingService()
    let viewModel = ProductListingViewModel(productListingService: mockProductListingService, user: userWithoutOffers)
    let actionExpectation = expectation(description: "updated")
    viewModel.products.bindNoFire(self) { products in
      XCTAssertEqual(products, self.productListingWithoutOffers.products)
      actionExpectation.fulfill()
    }
    mockProductListingService.lastCompletion?(.value(productListingWithMoreOffers))
    wait(for: [actionExpectation], timeout: 0.1)
  }

  func test_badgeNameForOfferWithId_returnsBadgeName_whenOfferID_matchesUserOfferID() {
    let mockProductListingService = MockProductListingService()
    let viewModel = ProductListingViewModel(productListingService: mockProductListingService, user: userWithOffers)
    let badge = viewModel.badgeNameForOfferWithId("1")
    XCTAssertEqual(badge, "loyalty")
  }

  func test_badgeNameForOfferWithId_returnsNoBadgeName_whenNoOfferID_matchesUserOfferID() {
    let mockProductListingService = MockProductListingService()
    let viewModel = ProductListingViewModel(productListingService: mockProductListingService, user: userWithoutOffers)
    let badge = viewModel.badgeNameForOfferWithId(nil)
    XCTAssertEqual(badge, nil)
  }
}
