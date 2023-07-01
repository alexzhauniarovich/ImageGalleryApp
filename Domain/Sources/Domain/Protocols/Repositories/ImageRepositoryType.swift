import Combine

public protocol ImageRepositoryType {
    
    func retrieveImages(page: Int, pageSize: Int) -> AnyPublisher<[ImageData], CommonError>
    
    func retrieveImageDetails(id: String) -> AnyPublisher<ImageExtendedData, CommonError>
}
