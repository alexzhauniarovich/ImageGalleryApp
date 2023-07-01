import Combine

public protocol ImagesUseCaseType {
    
    func retrieveImages(page: Int, pageSize: Int) -> AnyPublisher<[ImageData], CommonError>
    
    func retrieveImageDetails(id: String) -> AnyPublisher<ImageExtendedData, CommonError>
}
