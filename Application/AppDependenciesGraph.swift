import Foundation
import Presentation
import Domain
import Data

public class AppDependenciesGraph: AppDependenciesGraphType {
    
    // MARK: - Private fields
    
    private var persistenceStorageManager: PersistenceStorageManager?
    
    // MARK: - Public functions
    
    public func prepareImagesGridViewController() -> ImagesGridViewController {
        let imagesGridViewController = ImagesGridViewController()
        imagesGridViewController.viewModel = getImagesGridViewModel()
        return imagesGridViewController
    }
    
    public func prepareImagesOverviewViewController(imageIds: [String], selectedIndex: Int) -> ImagesOverviewViewController {
        let imagesOverviewViewController = ImagesOverviewViewController()
        imagesOverviewViewController.viewModel = getImagesOverviewViewModel(imageIds: imageIds, selectedIndex: selectedIndex)
        return imagesOverviewViewController
    }
}

// MARK: - Domain

private extension AppDependenciesGraph {
    
    private func getImagesUseCaseType() -> ImagesUseCaseType {
        ImageUseCase(imageRepository: getImageRepositoryType(), favouriteImagesRepository: getFavouriteImagesRepositoryType())
    }
    
    private func getFavoriteImagesUseCaseType() -> FavoriteImagesUseCaseType {
        FavoriteImagesUseCase(favouriteImagesRepository: getFavouriteImagesRepositoryType())
    }
}

// MARK: - Data

private extension AppDependenciesGraph {
    
    private func getImageRepositoryType() -> ImageRepositoryType {
        ImageRepository(networkRequestManager: getNetworkRequestManager())
    }
    
    private func getFavouriteImagesRepositoryType() -> FavouriteImagesRepositoryType {
        FavouriteImagesRepository(persistenceStorageManager: getPersistenceStorageManager())
    }
    
    private func getNetworkRequestManager() -> NetworkRequestManager {
        NetworkRequestManager(networkRequestBuilder: getNetworkRequestBuilder())
    }
    
    private func getPersistenceStorageManager() -> PersistenceStorageManager {
        if let persistenceStorageManager = persistenceStorageManager {
            return persistenceStorageManager
            
        } else {
            let persistenceStorageManager = PersistenceStorageManager()
            self.persistenceStorageManager = persistenceStorageManager
            return persistenceStorageManager
        }
    }
    
    private func getNetworkRequestBuilder() -> NetworkRequestBuilder {
        NetworkRequestBuilder()
    }
}

// MARK: - Presentation

private extension AppDependenciesGraph {
    
    // MARK: - Images Grid
    
    private func getImagesGridViewModel() -> ImagesGridViewModel {
        ImagesGridViewModel(imagesUseCase: getImagesUseCaseType(), router: getImagesGridRouter())
    }
    
    private func getImagesGridRouter() -> ImagesGridRouter {
        ImagesGridRouter(appDependenciesGraph: self)
    }
    
    // MARK: - Images Overview
    
    private func getImagesOverviewViewModel(imageIds: [String], selectedIndex: Int) -> ImagesOverviewViewModel {
        ImagesOverviewViewModel(
            imageIds: imageIds,
            selectedIndex: selectedIndex,
            imagesUseCase: getImagesUseCaseType(),
            favoriteImagesUseCase: getFavoriteImagesUseCaseType()
        )
    }
}
