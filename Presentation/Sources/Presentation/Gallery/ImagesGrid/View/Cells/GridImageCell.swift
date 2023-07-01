import UIKit
import Combine
import Kingfisher

private enum Constants {
    static let favoriteIconPadding: CGFloat = 8
    static let favoriteIconSize: CGFloat = 24
}

struct GridImageCellModel {
    let image: AnyPublisher<String?, Never>
    let isFavourite: AnyPublisher<Bool, Never>
    
    let tapImageEvent: PassthroughSubject<Void, Never>
}

final class GridImageCell: UICollectionViewCell {
    
    // MARK: - Init sub-views
    
    private let containerView: UIView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let favoriteIconImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.image = AppImages.icFavorite.value
        view.layer.cornerRadius = Constants.favoriteIconSize / 2
        return view
    }()
    
    // MARK: - Private fields
    
    private var cellData: GridImageCellModel?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initialisations
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    // MARK: - Public functions
    
    func bind(cellData: GridImageCellModel) {
        self.cellData = cellData
        
        cellData.image
            .sink(receiveValue: {
                guard let stringUrl = $0, let url = URL(string: stringUrl) else { return }
                KF.url(url)
                    .placeholder(AppImages.bgImagePlaceholder.value)
                    .loadDiskFileSynchronously()
                    .fade(duration: 0.25)
                    .set(to: self.backgroundImage)
            })
            .store(in: &subscriptions)
        
        cellData.isFavourite
            .sink(receiveValue: { self.favoriteIconImage.isHidden = !$0 })
            .store(in: &subscriptions)
    }
}

// MARK: - Setup

private extension GridImageCell {
    
    func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        setupContainerView()
        setupBackgroundImage()
        setupFavoriteIconImage()
    }
    
    func setupContainerView() {
        contentView.addSubview(containerView)
        containerView
            .leadingAnchor(equalTo: contentView.leadingAnchor)
            .trailingAnchor(equalTo: contentView.trailingAnchor)
            .topAnchor(equalTo: contentView.topAnchor)
            .bottomAnchor(equalTo: contentView.bottomAnchor)
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapContainerView)))
    }
    
    func setupBackgroundImage() {
        containerView.addSubview(backgroundImage)
        backgroundImage
            .leadingAnchor(equalTo: containerView.leadingAnchor)
            .trailingAnchor(equalTo: containerView.trailingAnchor)
            .topAnchor(equalTo: containerView.topAnchor)
            .bottomAnchor(equalTo: containerView.bottomAnchor)
    }
    
    func setupFavoriteIconImage() {
        containerView.addSubview(favoriteIconImage)
        favoriteIconImage
            .trailingAnchor(equalTo: contentView.trailingAnchor, constant: -Constants.favoriteIconPadding)
            .bottomAnchor(equalTo: contentView.bottomAnchor, constant: -Constants.favoriteIconPadding)
            .heightAnchor(equalToConstant: Constants.favoriteIconSize)
            .widthAnchor(equalToConstant: Constants.favoriteIconSize)
    }
}

// MARK: - Actions

private extension GridImageCell {
    
    @objc func didTapContainerView() {
        containerView.animateTapAction()
        cellData?.tapImageEvent.send(())
    }
}
