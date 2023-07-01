import Combine

public protocol FavoriteImagesUseCaseType {
    
    // Make image favourite
    func markFavouriteImage(id: String)
    
    // Remove image from favourites
    func unmarkFavouriteImage(id: String)
}
