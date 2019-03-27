import XCTest
@testable import RetailApp

class ProductListingViewModelTests: XCTestCase {
  var mockProductListingService: MockProductListingService!
  let productListing = ProductListing(products: [ProductListingProduct(id: "1", imageKey: "image", name: "name", offerIds: ["1", "2"], price: Price(currentPrice: 1, originalPrice: 2, currencyCode: "GBP"))])
  let userWithOffers = User(availableBadges: "loyalty:SLOTTED,BONUS||sale:PRIORITY_ACCESS,REDUCED", offers: [Offer(id: "1", title: "title", type: "BONUS"), Offer(id: "2", title: "title", type: "REDUCED")])
  let userWithoutOffers = User(availableBadges: "", offers: [])

  override func setUp() {
    super.setUp()
    mockProductListingService = MockProductListingService()
  }

  override func tearDown() {
    super.tearDown()
    mockProductListingService = nil
  }

  func test_getProducts_returnsProducts_withOfferIDs_whenUserHasOfferIDs() {
    let viewModel = ProductListingViewModel(service: mockProductListingService, user: userWithOffers)
    let expectation = XCTestExpectation(description: "Execute a get products request")
    viewModel.getProducts { expectation.fulfill() }
    mockProductListingService.lastCompletion?(.value(productListing))
    wait(for: [expectation], timeout: 0.1)
    XCTAssertEqual(mockProductListingService.callCount, 1)
    XCTAssertEqual(viewModel.products.count, 1)
    XCTAssertEqual(viewModel.products.first?.id, "1")
    XCTAssertEqual(viewModel.products.first?.imageKey, "image")
    XCTAssertEqual(viewModel.products.first?.name, "name")
    XCTAssertEqual(viewModel.products.first?.offerIds, ["1", "2"])
    XCTAssertEqual(viewModel.products.first?.price.currentPrice, 1)
    XCTAssertEqual(viewModel.products.first?.price.originalPrice, 2)
    XCTAssertEqual(viewModel.products.first?.price.currencyCode, "GBP")
  }

  func test_getProducts_returnsProducts_withoutOfferIDs_whenUserHasNoOfferIDs() {
    let viewModel = ProductListingViewModel(service: mockProductListingService, user: userWithoutOffers)
    let expectation = XCTestExpectation(description: "Execute a get products request")
    viewModel.getProducts { expectation.fulfill() }
    mockProductListingService.lastCompletion?(.value(productListing))
    wait(for: [expectation], timeout: 0.1)
    XCTAssertEqual(mockProductListingService.callCount, 1)
    XCTAssertEqual(viewModel.products.count, 1)
    XCTAssertEqual(viewModel.products.first?.offerIds, [])
  }

  func test_badgeNameForOfferWithId_returnsBadgeName_whenOfferID_matchesUserOfferID() {
    let viewModel = ProductListingViewModel(service: mockProductListingService, user: userWithOffers)
    let badge = viewModel.badgeNameForOfferWithId("1")
    XCTAssertEqual(badge, "loyalty")
  }

  func test_badgeNameForOfferWithId_returnsNoBadgeName_whenNoOfferID_matchesUserOfferID() {
    let viewModel = ProductListingViewModel(service: mockProductListingService, user: userWithoutOffers)
    let badge = viewModel.badgeNameForOfferWithId(nil)
    XCTAssertEqual(badge, nil)
  }
}
