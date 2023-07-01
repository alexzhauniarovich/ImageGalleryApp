import Combine

public protocol FavoriteImagesUseCaseType {
    
    func markFavouriteImage(id: String)
    
    func unmarkFavouriteImage(id: String)
}
