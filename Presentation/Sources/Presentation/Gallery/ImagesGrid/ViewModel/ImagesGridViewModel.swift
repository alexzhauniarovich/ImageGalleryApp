import UIKit
import Domain
import Combine

private enum Constants {
    static let imagesPageSize = 30
}

public final class ImagesGridViewModel {
    
    // MARK: - Output Publishers
    
    private let contentSubject: PassthroughSubject<[GridImageCellModel], Never>
    let content: AnyPublisher<[GridImageCellModel], Never>
    
    private let isLoadingVisibleStateSubject: CurrentValueSubject<Bool, Never>
    let isLoadingVisibleState: AnyPublisher<Bool, Never>
    
    private let isLoadingItemVisibleStateSubject: CurrentValueSubject<Bool, Never>
    let isLoadingItemVisibleState: AnyPublisher<Bool, Never>
    
    // MARK: - Input Publishers
    
    let viewWillAppearEvent = PassthroughSubject<UIViewController, Never>()
    let loadMoreImagesEvent = PassthroughSubject<UIViewController, Never>()
    
    // MARK: - Private fields
    
    private let imagesUseCase: ImagesUseCaseType
    private let router: ImagesGridRouter
    
    private var currentPage = 1
    private var subscriptions: Set<AnyCancellable> = []
    private var loadedImages: [ImageData] = []
    private var isAllImagesLoaded = false
    
    // MARK: - Init
    
    public required init(imagesUseCase: ImagesUseCaseType, router: ImagesGridRouter) {
        self.imagesUseCase = imagesUseCase
        self.router = router
        
        contentSubject = PassthroughSubject<[GridImageCellModel], Never>()
        content = AnyPublisher<[GridImageCellModel], Never>(contentSubject)
        
        isLoadingVisibleStateSubject = CurrentValueSubject<Bool, Never>(true)
        isLoadingVisibleState = AnyPublisher<Bool, Never>(isLoadingVisibleStateSubject)
        
        isLoadingItemVisibleStateSubject = CurrentValueSubject<Bool, Never>(false)
        isLoadingItemVisibleState = AnyPublisher<Bool, Never>(isLoadingItemVisibleStateSubject)
        
        subscribeToInputEvents()
    }
    
    // MARK: - Private functions
    
    private func subscribeToInputEvents() {
        weak var view: UIViewController? = nil
        
        viewWillAppearEvent
            .sink(receiveValue: {
                view = $0
                self.retrieveImages(for: $0)
            })
            .store(in: &subscriptions)
        
        loadMoreImagesEvent
            .sink(receiveValue: {
                guard !self.isAllImagesLoaded else { return }
                self.currentPage += 1
                self.retrieveImages(for: $0)
            })
            .store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: .userFavouritesWasChanged)
            .sink(receiveValue: { _ in
                guard let view = view else { return }
                self.isLoadingVisibleStateSubject.send(true)
                self.isAllImagesLoaded = false
                self.loadedImages.removeAll()
                self.currentPage = 1
                self.retrieveImages(for: view)
            })
            .store(in: &subscriptions)
    }
    
    private func retrieveImages(for view: UIViewController) {
        imagesUseCase
            .retrieveImages(page: currentPage, pageSize: Constants.imagesPageSize)
            .catch { error in
                view.showErrorAlertMessage(message: error.errorMessage)
                let emptyResponse: [ImageData] = []
                self.isLoadingVisibleStateSubject.send(false)
                return Just(emptyResponse)
            }
            .map { imagesPage in
                self.loadedImages.append(contentsOf: imagesPage)
                return self.loadedImages.map { self.mapImageModel(imageData: $0, for: view) }
            }
            .sink(receiveValue: {
                self.isLoadingVisibleStateSubject.send(false)
                self.contentSubject.send($0)
                self.isAllImagesLoaded = $0.isEmpty
                self.isLoadingItemVisibleStateSubject.send(!$0.isEmpty)
            })
            .store(in: &subscriptions)
    }
}

// MARK: - Data Mapping

private extension ImagesGridViewModel {
    
    private func mapImageModel(imageData: ImageData, for view: UIViewController) -> GridImageCellModel {
        let imageTapSubject = PassthroughSubject<Void, Never>()
        imageTapSubject
            .sink(receiveValue: {
                self.router.showImagesOverviewScreen(
                    from: view,
                    imagesIds: self.loadedImages.compactMap { $0.id },
                    selectedIndex: self.loadedImages.firstIndex(where: { $0.id == imageData.id ?? "" }) ?? 0
                )
            })
            .store(in: &subscriptions)
        
        return GridImageCellModel(
            image: Just(imageData.urls?.small).eraseToAnyPublisher(),
            isFavourite: Just(imageData.isFavorite).eraseToAnyPublisher(),
            tapImageEvent: imageTapSubject
        )
    }
}
