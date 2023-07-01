import Foundation
import Combine

public class NetworkRequestManager {
    
    // MARK: - Private fields
    
    private let networkRequestBuilder: NetworkRequestBuilder
    
    // MARK: - Initialisation
    
    public required init(networkRequestBuilder: NetworkRequestBuilder) {
        self.networkRequestBuilder = networkRequestBuilder
    }
    
    // MARK: - Public functions
    
    func dispatch<T: Decodable>(request: Requestable, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let urlRequest = networkRequestBuilder.build(request)
        else { return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher() }
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .receive(on: RunLoop.main)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse else { throw NetworkError.unknown }
                guard response.statusCode >= 200, response.statusCode < 300
                else {
                    if let errorDescription = try? JSONDecoder().decode(ErrorDescription.self, from: $0.data) {
                        throw NetworkError.invalidResponse(
                            statusCode: response.statusCode,
                            message: errorDescription.errors?.joined(separator: ", ")
                        )
                    } else {
                        throw NetworkError.unknown
                    }
                }
                return $0.data
            }
            .decode(type: responseType, decoder: JSONDecoder())
            .mapError {
                if let networkError = $0 as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.parsingError(message: $0.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
