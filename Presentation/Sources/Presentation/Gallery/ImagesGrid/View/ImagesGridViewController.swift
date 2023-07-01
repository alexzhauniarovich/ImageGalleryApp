import UIKit
import Combine

private enum Constants {
    static let contentItemHeight: CGFloat = 150
    static let contentSectionMargin: CGFloat = 16
    static let contentItemMargin: CGFloat = 8
}

public class ImagesGridViewController: UIViewController {
    
    public var viewModel: ImagesGridViewModel?
    
    // MARK: - Init sub-views
    
    private let contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(
            top: Constants.contentSectionMargin,
            left: Constants.contentSectionMargin,
            bottom: Constants.contentSectionMargin,
            right: Constants.contentSectionMargin
        )
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = Constants.contentSectionMargin
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Private fields
    
    private var subscriptions: Set<AnyCancellable> = []
    private var images: [GridImageCellModel] = []
    private var isLoadingItemVisibleState = false
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppearEvent.send(self)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            subscriptions.forEach { $0.cancel() }
            subscriptions.removeAll()
        }
    }
}

// MARK: - Setup ViewModel

private extension ImagesGridViewController {
    
    func setupViewModel() {
        viewModel?.content
            .sink(receiveValue: {
                self.images = $0
                self.contentCollectionView.reloadData()
            })
            .store(in: &subscriptions)
        
        viewModel?.isLoadingVisibleState
            .sink(receiveValue: {
                if $0 {
                    self.view.showActivityIndicator()
                } else {
                    self.view.hideActivityIndicator()
                }
                self.contentCollectionView.isHidden = $0
            })
            .store(in: &subscriptions)
        
        viewModel?.isLoadingItemVisibleState
            .sink(receiveValue: { self.isLoadingItemVisibleState = $0 })
            .store(in: &subscriptions)
    }
}

// MARK: - Setup

private extension ImagesGridViewController {
    
    func setup() {
        view.backgroundColor = AppColors.mainBackground.value
        title = "Recent uploads"
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(contentCollectionView)
        contentCollectionView
            .leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .topAnchor(equalTo: view.topAnchor)
            .bottomAnchor(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        contentCollectionView.dataSource = self
        contentCollectionView.delegate = self
        contentCollectionView.register(GridImageCell.self, forCellWithReuseIdentifier: GridImageCell.identifier)
        contentCollectionView.register(GridImageLoadingCell.self, forCellWithReuseIdentifier: GridImageLoadingCell.identifier)
    }
    
}

// MARK: - Implementation Content Collection Data Source

extension ImagesGridViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isLoadingItemVisibleState ? images.count + 1 : images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == images.count {
            let cell = collectionView.dequeueReusableCell(GridImageLoadingCell.self, for: indexPath)
            cell.bind()
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(GridImageCell.self, for: indexPath)
            cell.bind(cellData: images[indexPath.row])
            return cell
        }
    }
}

// MARK: - Implementation Content Collection Data Delegate

extension ImagesGridViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.row == images.count - 1 {
            viewModel?.loadMoreImagesEvent.send(self)
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.row == images.count {
            return CGSize(width: collectionView.contentSize.width, height: Constants.contentItemHeight)
            
        } else {
            return CGSize(
                width: collectionView.contentSize.width / 2 - Constants.contentSectionMargin - Constants.contentItemMargin,
                height: Constants.contentItemHeight
            )
        }
        
    }
}
