import UIKit
import Combine
import Kingfisher

public class ImagesOverviewViewController: UIViewController {
    
    public var viewModel: ImagesOverviewViewModel?
    
    // MARK: - Init sub-views
    
    private let contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Private fields
    
    private var subscriptions: Set<AnyCancellable> = []
    private var images: [OverviewImageCellModel] = []
    private var contentOffset: Int?
    
    // MARK: - Lifecycle
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let contentOffset = contentOffset, contentCollectionView.frame.size.width != 0 {
            contentCollectionView.setContentOffset(
                CGPoint(x: contentOffset * Int(contentCollectionView.frame.size.width), y: 0),
                animated: false
            )
            self.contentOffset = nil
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppearEvent.send(self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        images.removeAll()
        contentCollectionView.reloadData()
        
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
}

// MARK: - Setup ViewModel

private extension ImagesOverviewViewController {
    
    func setupViewModel() {
        viewModel?.content
            .sink(receiveValue: {
                self.images.append(contentsOf: $0)
                self.contentCollectionView.reloadData()
            })
            .store(in: &subscriptions)
        
        viewModel?.contentOffset
            .sink(receiveValue: { self.contentOffset = $0 })
            .store(in: &subscriptions)
    }
}

// MARK: - Setup

private extension ImagesOverviewViewController {
    
    func setup() {
        view.backgroundColor = AppColors.mainBackground.value
        title = "Image Gallery"
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(contentCollectionView)
        contentCollectionView
            .leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .topAnchor(equalTo: view.topAnchor)
            .bottomAnchor(equalTo: view.bottomAnchor)
        
        contentCollectionView.dataSource = self
        contentCollectionView.delegate = self
        contentCollectionView.register(OverviewImageCell.self, forCellWithReuseIdentifier: OverviewImageCell.identifier)
    }
}

// MARK: - Implementation Content Collection Data Source

extension ImagesOverviewViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(OverviewImageCell.self, for: indexPath)
        cell.bind(cellData: images[indexPath.row])
        return cell
    }
}

// MARK: - Implementation Content Collection Data Delegate

extension ImagesOverviewViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        collectionView.frame.size
    }
}
