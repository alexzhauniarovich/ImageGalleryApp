import Combine

public class ImageUseCase {
    
    // MARK: - Private fields
    
    private let imageRepository: ImageRepositoryType
    private let favouriteImagesRepository: FavouriteImagesRepositoryType
    
    // MARK: - Initialisation
    
    public required init(
        imageRepository: ImageRepositoryType,
        favouriteImagesRepository: FavouriteImagesRepositoryType
    ) {
        self.imageRepository = imageRepository
        self.favouriteImagesRepository = favouriteImagesRepository
    }
}

// MARK: - Implementation of Image Repository Protocol

extension ImageUseCase: ImagesUseCaseType {
    
    public func retrieveImages(page: Int, pageSize: Int) -> AnyPublisher<[ImageData], CommonError> {
        favouriteImagesRepository
            .retrieveFavouritedImages()
            .mapError { _ in CommonError(errorMessage: "Unknown exception") }
            .zip(imageRepository.retrieveImages(page: page, pageSize: pageSize), { favouriteIds, imagesData in
                imagesData.map {
                    ImageData(
                        id: $0.id,
                        urls: $0.urls,
                        isFavorite: favouriteIds.contains($0.id ?? "")
                    )
                }
            })
            .eraseToAnyPublisher()
    }
    
    public func retrieveImageDetails(id: String) -> AnyPublisher<ImageExtendedData, CommonError> {
        favouriteImagesRepository
            .retrieveFavouritedImages()
            .mapError { _ in CommonError(errorMessage: "") }
            .zip(imageRepository.retrieveImageDetails(id: id), {
                ImageExtendedData(
                    id: $1.id,
                    description: $1.description,
                    location: $1.location,
                    urls: $1.urls,
                    isFavorite: $0.contains($1.id ?? "")
                )
            })
            .eraseToAnyPublisher()
    }
}
