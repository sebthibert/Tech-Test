import XCTest
@testable import RetailApp

class NavigationViewModelTests: XCTestCase {
  private let mockUserService = MockUserService()
  private let user = User(availableBadges: "", offers: [Offer(id: "", title: "", type: ""), Offer(id: "", title: "", type: "")])

  func test_getUser_callsCompletion() {
    let viewModel = NavigationViewModel(service: mockUserService)
    let expectation = XCTestExpectation(description: "Execute a get offers request")
    viewModel.getUser { productListingViewModel in
      XCTAssertNotNil(productListingViewModel)
      expectation.fulfill()
    }
    mockUserService.lastCompletion?(.value(user))
    wait(for: [expectation], timeout: 0.1)
    XCTAssertEqual(mockUserService.callCount, 1)
  }
}
