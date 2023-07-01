import UIKit
import Combine
import Kingfisher

private enum Constants {
    static let layoutPadding: CGFloat = 16
    static let favoriteButtonSize: CGFloat = 54
    static let minDescriptionContainerHeight: CGFloat = 90
}

struct OverviewImageCellModel {
    let id: String
    let imageData: PassthroughSubject<ImageDetailsCellModel?, Never>
    
    let loadImageDataEvent: PassthroughSubject<Void, Never>
}

struct ImageDetailsCellModel {
    let image: AnyPublisher<String?, Never>
    let description: AnyPublisher<String, Never>
    let location: AnyPublisher<String, Never>
    let isFavourite: AnyPublisher<Bool, Never>
    
    let tapFavouriteEvent: PassthroughSubject<Bool, Never>
}

final class OverviewImageCell: UICollectionViewCell {
    
    // MARK: - Init sub-views
    
    private let containerView: UIView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundImageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumZoomScale = 1
        view.maximumZoomScale = 4
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionContainerView: UIView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blurBackgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 10
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .caption1)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = AppColors.mainText.value
        view.numberOfLines = 0
        return view
    }()
    
    private let locationLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = AppColors.subText.value
        return view
    }()
    
    private let favoriteButton: UIButton = {
        let view = UIButton()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(
            AppImages.icUnfavorite.value.resizedImage(to: CGSize(width: 30, height: 30)),
            for: .normal
        )
        view.setImage(
            AppImages.icFavorite.value.resizedImage(to: CGSize(width: 30, height: 30)),
            for: .selected
        )
        return view
    }()
    
    // MARK: - Private fields
    
    private var cellData: ImageDetailsCellModel?
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
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        backgroundImageView.image = nil
        favoriteButton.isSelected = false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard self.point(inside: point, with: event) else { return nil }
        if favoriteButton.point(inside: convert(point, to: favoriteButton), with: event) {
            return favoriteButton
            
        } else if backgroundImageScrollView.point(inside: convert(point, to: backgroundImageScrollView), with: event) {
            return backgroundImageScrollView
        }
        return super.hitTest(point, with: event)
    }
    
    // MARK: - Public functions
    
    func bind(cellData: OverviewImageCellModel) {
        containerView.showActivityIndicator()
        
        cellData.imageData
            .sink(receiveValue: {
                guard let cellDetails = $0 else { return }
                self.cellData = cellDetails
                self.bindImageDetails(cellDetailsData: cellDetails)
            })
            .store(in: &subscriptions)
        
        cellData.loadImageDataEvent.send(())
    }
    
    // MARK: - Private functions
    
    private func bindImageDetails(cellDetailsData: ImageDetailsCellModel) {
        cellDetailsData.image
            .sink(receiveValue: {
                guard let stringUrl = $0, let url = URL(string: stringUrl) else { return }
                KF.url(url)
                    .loadDiskFileSynchronously()
                    .fade(duration: 0.25)
                    .onSuccess { _ in self.containerView.hideActivityIndicator() }
                    .onFailure { _ in
                        self.containerView.hideActivityIndicator()
                        self.backgroundImageView.image = AppImages.bgImagePlaceholder.value
                    }
                    .set(to: self.backgroundImageView)
            })
            .store(in: &subscriptions)
        
        cellDetailsData.description
            .sink(receiveValue: {
                self.descriptionLabel.text = $0
                self.descriptionLabel.isHidden = $0.isEmpty
            })
            .store(in: &subscriptions)
        
        cellDetailsData.location
            .sink(receiveValue: {
                self.locationLabel.text = $0
                self.locationLabel.isHidden = $0.isEmpty
            })
            .store(in: &subscriptions)
        
        cellDetailsData.isFavourite
            .sink(receiveValue: { self.favoriteButton.isSelected = $0 })
            .store(in: &subscriptions)
    }
}

// MARK: - Setup

private extension OverviewImageCell {
    
    func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = true
        
        setupContainerView()
        setupBackgroundImageScrollView()
        setupBackgroundImageView()
        setupDescriptionContainerView()
        setupBlurBackgroundView()
        setupFavoriteButton()
        setupLabelsStackView()
    }
    
    func setupContainerView() {
        contentView.addSubview(containerView)
        containerView
            .leadingAnchor(equalTo: contentView.leadingAnchor)
            .trailingAnchor(equalTo: contentView.trailingAnchor)
            .topAnchor(equalTo: contentView.topAnchor)
            .bottomAnchor(equalTo: contentView.bottomAnchor)
    }
    
    func setupBackgroundImageScrollView() {
        containerView.addSubview(backgroundImageScrollView)
        backgroundImageScrollView
            .leadingAnchor(equalTo: containerView.leadingAnchor)
            .trailingAnchor(equalTo: containerView.trailingAnchor)
            .topAnchor(equalTo: containerView.topAnchor)
            .bottomAnchor(equalTo: containerView.bottomAnchor)
        
        backgroundImageScrollView.delegate = self
    }
    
    func setupBackgroundImageView() {
        backgroundImageScrollView.addSubview(backgroundImageView)
        backgroundImageView
            .centerXAnchor(equalTo: backgroundImageScrollView.centerXAnchor)
            .centerYAnchor(equalTo: backgroundImageScrollView.centerYAnchor, constant: -(Constants.minDescriptionContainerHeight / 2))
            .widthAnchor(equalTo: backgroundImageScrollView.widthAnchor)
            .heightAnchor(equalTo: backgroundImageScrollView.heightAnchor)
    }
    
    func setupDescriptionContainerView() {
        containerView.addSubview(descriptionContainerView)
        descriptionContainerView
            .leadingAnchor(equalTo: containerView.leadingAnchor)
            .trailingAnchor(equalTo: containerView.trailingAnchor)
            .bottomAnchor(equalTo: containerView.bottomAnchor, constant: -(Constants.layoutPadding * 4))
            .heightAnchor(greaterThanOrEqualToConstant: Constants.minDescriptionContainerHeight)
    }
    
    func setupBlurBackgroundView() {
        containerView.addSubview(blurBackgroundView)
        blurBackgroundView
            .leadingAnchor(equalTo: containerView.leadingAnchor)
            .trailingAnchor(equalTo: containerView.trailingAnchor)
            .bottomAnchor(equalTo: containerView.bottomAnchor)
            .topAnchor(equalTo: descriptionContainerView.topAnchor)
        
        containerView.bringSubviewToFront(descriptionContainerView)
    }
    
    func setupFavoriteButton() {
        descriptionContainerView.addSubview(favoriteButton)
        favoriteButton
            .trailingAnchor(equalTo: descriptionContainerView.trailingAnchor, constant: -Constants.layoutPadding)
            .centerYAnchor(equalTo: descriptionContainerView.centerYAnchor)
            .heightAnchor(equalToConstant: Constants.favoriteButtonSize)
            .widthAnchor(equalToConstant: Constants.favoriteButtonSize)
        
        favoriteButton.addTarget(self, action: #selector(didTapFavouriteButton), for: .touchUpInside)
    }
    
    func setupLabelsStackView() {
        descriptionContainerView.addSubview(labelsStackView)
        labelsStackView
            .leadingAnchor(equalTo: descriptionContainerView.leadingAnchor, constant: Constants.layoutPadding)
            .trailingAnchor(equalTo: favoriteButton.leadingAnchor, constant: -Constants.layoutPadding)
            .bottomAnchor(equalTo: descriptionContainerView.bottomAnchor, constant: -Constants.layoutPadding)
            .topAnchor(equalTo: descriptionContainerView.topAnchor, constant: Constants.layoutPadding)
        
        labelsStackView.addArrangedSubview(descriptionLabel)
        labelsStackView.addArrangedSubview(locationLabel)
    }
}

// MARK: - Implementation Scroll View Delegate

extension OverviewImageCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        backgroundImageView
    }
}

// MARK: - Actions

private extension OverviewImageCell {
    
    @objc func didTapFavouriteButton() {
        favoriteButton.animateTapAction()
        favoriteButton.isSelected = !favoriteButton.isSelected
        cellData?.tapFavouriteEvent.send(favoriteButton.isSelected)
    }
}
