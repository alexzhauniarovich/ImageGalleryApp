import Combine

public protocol FavouriteImagesRepositoryType {
    
    // Returning a list of previously saved favourite images
    func retrieveFavouritedImages() -> AnyPublisher<[String], Error>
    
    // Saving favourite image
    func addFavouriteImage(id: String)
    
    // Removing a previously added favourite image, if an image with such id exists
    func removeFavouriteImage(id: String)
}
