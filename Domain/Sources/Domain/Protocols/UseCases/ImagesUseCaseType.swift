import Combine

public protocol ImagesUseCaseType {
    
    // Request the list of images with pagination
    func retrieveImages(page: Int, pageSize: Int) -> AnyPublisher<[ImageData], CommonError>
    
    // Request full description of the particular image
    func retrieveImageDetails(id: String) -> AnyPublisher<ImageExtendedData, CommonError>
}
