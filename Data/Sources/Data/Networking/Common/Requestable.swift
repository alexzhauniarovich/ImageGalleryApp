import Foundation

protocol Requestable {
    var path: String { get }
    var method: HTTPMethod { get }
    var params: RequestParameter { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum RequestParameter {
    case body(Any)
    case url([String: String])
    case urlQuery([URLQueryItem])
    case none
}
