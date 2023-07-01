import Foundation

public class NetworkRequestBuilder {
    
    // MARK: - Initialisation
    
    public required init() { }
    
    // MARK: - Public functions
    
    func build( _ request: Requestable) -> URLRequest? {
        let endpointURLString = "\(NetworkConstants.baseHostUrl)\(request.path)"
        
        guard let endpointURL = URL(string: endpointURLString),
              var components = URLComponents(string: endpointURLString)
        else { return nil }
        
        var urlRequest = URLRequest(url: endpointURL)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Client-ID \(NetworkConstants.unsplashApiKey)"]
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = 60
        
        switch request.params {
        case .body(let parameters):
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
        case .url(let parameters):
            let queryParameters = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
            components.queryItems = queryParameters
            urlRequest.url = components.url
            
        case .urlQuery(let queryParameters):
            components.queryItems = queryParameters
            urlRequest.url = components.url
            
        default: break
        }
        return urlRequest
    }
}
