import Foundation
@testable import RetailApp

class MockUserService: UserService {
  private(set) var lastCompletion: ((Result<User, Error>) -> Void)? = nil
  var callCount = 0
  func getUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
    lastCompletion = completion
    callCount += 1
  }
}
