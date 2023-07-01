import Combine
import Domain

public class FavouriteImagesRepository {
    
    // MARK: - Private fields
    
    private let persistenceStorageManager: PersistenceStorageManager
    
    // MARK: - Initialisation
    
    public required init(persistenceStorageManager: PersistenceStorageManager) {
        self.persistenceStorageManager = persistenceStorageManager
    }
}

// MARK: - Implementation of Image Repository Protocol

extension FavouriteImagesRepository: FavouriteImagesRepositoryType {
    
    public func retrieveFavouritedImages() -> AnyPublisher<[String], Error> {
        persistenceStorageManager.retrieveImages()
    }
    
    public func addFavouriteImage(id: String) {
        persistenceStorageManager.addImage(id: id)
    }
    
    public func removeFavouriteImage(id: String) {
        persistenceStorageManager.removeImage(id: id)
    }
}
