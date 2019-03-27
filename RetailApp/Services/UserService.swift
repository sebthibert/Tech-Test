import Foundation

protocol UserService {
  func getUser(id: String, completion: @escaping(Result<User, Error>) -> Void)
}

class UserServiceImplementation: UserService {
  private let api: API

  init(api: API) {
    self.api = api
  }

  func getUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
    let resource = Resource<User>(path: "api/user/\(id)/offers")
    api.load(resource, completion: completion)
  }
}

