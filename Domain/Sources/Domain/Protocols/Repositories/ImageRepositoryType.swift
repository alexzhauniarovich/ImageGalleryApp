import Combine

public protocol ImageRepositoryType {
    
    // Returning the list of images, supporting pagination
    func retrieveImages(page: Int, pageSize: Int) -> AnyPublisher<[ImageData], CommonError>
    
    // Returning full description of the particular image
    func retrieveImageDetails(id: String) -> AnyPublisher<ImageExtendedData, CommonError>
}
