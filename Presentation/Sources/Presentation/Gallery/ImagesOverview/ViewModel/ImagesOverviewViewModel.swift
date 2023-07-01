import UIKit
import Domain
import Combine

private enum Constants {
    static let imagesPageSize = 30
}

public final class ImagesOverviewViewModel {
    
    // MARK: - Output Publishers
    
    private let contentSubject: PassthroughSubject<[OverviewImageCellModel], Never>
    let content: AnyPublisher<[OverviewImageCellModel], Never>
    
    private let contentOffsetSubject: PassthroughSubject<Int, Never>
    let contentOffset: AnyPublisher<Int, Never>
    
    // MARK: - Input Publishers
    
    let viewWillAppearEvent = PassthroughSubject<UIViewController, Never>()
    
    // MARK: - Private fields
    
    private let imageIds: [String]
    private let selectedIndex: Int
    private let imagesUseCase: ImagesUseCaseType
    private let favoriteImagesUseCase: FavoriteImagesUseCaseType
    
    private var currentPage = 1
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    public required init(
        imageIds: [String],
        selectedIndex: Int,
        imagesUseCase: ImagesUseCaseType,
        favoriteImagesUseCase: FavoriteImagesUseCaseType
    ) {
        self.imageIds = imageIds
        self.selectedIndex = selectedIndex
        self.imagesUseCase = imagesUseCase
        self.favoriteImagesUseCase = favoriteImagesUseCase
        
        contentSubject = PassthroughSubject<[OverviewImageCellModel], Never>()
        content = AnyPublisher<[OverviewImageCellModel], Never>(contentSubject)
        
        contentOffsetSubject = PassthroughSubject<Int, Never>()
        contentOffset = AnyPublisher<Int, Never>(contentOffsetSubject)
        
        subscribeToInputEvents()
    }
    
    // MARK: - Private functions
    
    private func subscribeToInputEvents() {
        viewWillAppearEvent
            .sink(receiveValue: { view in
                self.contentSubject.send(self.imageIds.map { self.mapOverviewImageCellModel(imageId: $0, for: view) })
                self.contentOffsetSubject.send(self.selectedIndex)
            })
            .store(in: &subscriptions)
        
    }
}

// MARK: - Data Mapping

private extension ImagesOverviewViewModel {
    
    private func mapOverviewImageCellModel(imageId: String, for view: UIViewController) -> OverviewImageCellModel {
        let imageDataSubject = PassthroughSubject<ImageDetailsCellModel?, Never>()
        let loadImageDataSubject = PassthroughSubject<Void, Never>()
        
        loadImageDataSubject
            .sink(receiveValue: {
                self.imagesUseCase
                    .retrieveImageDetails(id: imageId)
                    .map(self.mapOverviewImageCellModel)
                    .catch { error in
                        view.showErrorAlertMessage(message: error.errorMessage)
                        let emptyResponse: ImageDetailsCellModel? = nil
                        return Just(emptyResponse)
                    }
                    .sink(receiveValue: { imageDataSubject.send($0) })
                    .store(in: &self.subscriptions)
            })
            .store(in: &self.subscriptions)
        
        return OverviewImageCellModel(
            id: imageId,
            imageData: imageDataSubject,
            loadImageDataEvent: loadImageDataSubject
        )
    }
    
    private func mapOverviewImageCellModel(imageData: ImageExtendedData) -> ImageDetailsCellModel {
        let tapFavouriteSubject = PassthroughSubject<Bool, Never>()
        tapFavouriteSubject
            .sink(receiveValue: {
                guard let imageId = imageData.id else { return }
                if $0 {
                    self.favoriteImagesUseCase.markFavouriteImage(id: imageId)
                    
                } else {
                    self.favoriteImagesUseCase.unmarkFavouriteImage(id: imageId)
                }
                NotificationCenter.default.post(name: .userFavouritesWasChanged, object: nil)
            })
            .store(in: &subscriptions)
        
        let locationText: String = {
            var location = ""
            if let country = imageData.location?.country { location = country }
            if let city = imageData.location?.city {
                location = "\(location)\(location.isEmpty ? city : ", \(city)")"
            }
            return location
        }()
        
        return ImageDetailsCellModel(
            image: Just(imageData.urls?.full).eraseToAnyPublisher(),
            description: Just(imageData.description ?? "").eraseToAnyPublisher(),
            location: Just(locationText).eraseToAnyPublisher(),
            isFavourite: Just(imageData.isFavorite).eraseToAnyPublisher(),
            tapFavouriteEvent: tapFavouriteSubject
        )
    }
}
