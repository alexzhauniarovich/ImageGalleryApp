import Combine
import Domain

public class ImageRepository {
    
    // MARK: - Private fields
    
    private let networkRequestManager: NetworkRequestManager
    
    // MARK: - Initialisation
    
    public required init(networkRequestManager: NetworkRequestManager) {
        self.networkRequestManager = networkRequestManager
    }
    
    // MARK: - Private functions
    
    public func mapNetworkError(_ networkError: NetworkError) -> CommonError {
        switch networkError {
        case .unknown:
            return CommonError(errorMessage: "Unknown error")
            
        case .invalidURL:
            return CommonError(errorMessage: "Invalid request URL")
            
        case .parsingError(let message):
            return CommonError(errorMessage: "Parsing response error:\n\(message ?? "")")
            
        case .invalidResponse(let statusCode, let message):
            return CommonError(errorMessage: "Error response with code \(statusCode):\n\(message ?? "")")
        }
    }
}

// MARK: - Implementation of Image Repository Protocol

extension ImageRepository: ImageRepositoryType {
    
    public func retrieveImages(page: Int, pageSize: Int) -> AnyPublisher<[ImageData], CommonError> {
        networkRequestManager
            .dispatch(
                request: ImagesRequest.requestImages(page: page, pageSize: pageSize),
                responseType: [ImageData].self
            )
            .mapError(mapNetworkError)
            .eraseToAnyPublisher()
    }
    
    public func retrieveImageDetails(id: String) -> AnyPublisher<ImageExtendedData, CommonError> {
        networkRequestManager
            .dispatch(
                request: ImagesRequest.requestImageDetails(imageId: id),
                responseType: ImageExtendedData.self
            )
            .mapError(mapNetworkError)
            .eraseToAnyPublisher()
    }
}
