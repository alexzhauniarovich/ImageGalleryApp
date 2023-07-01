import Combine

public class FavoriteImagesUseCase {
    
    // MARK: - Private fields
    
    private let favouriteImagesRepository: FavouriteImagesRepositoryType
    
    // MARK: - Initialisation
    
    public required init(favouriteImagesRepository: FavouriteImagesRepositoryType) {
        self.favouriteImagesRepository = favouriteImagesRepository
    }
}

// MARK: - Implementation of Image Repository Protocol

extension FavoriteImagesUseCase: FavoriteImagesUseCaseType {
    
    public func markFavouriteImage(id: String) {
        favouriteImagesRepository.addFavouriteImage(id: id)
    }
    
    public func unmarkFavouriteImage(id: String) {
        favouriteImagesRepository.removeFavouriteImage(id: id)
    }
}
