import UIKit
import Combine
import Kingfisher

private enum Constants {
    static let cellSize: CGFloat = 150
}

final class GridImageLoadingCell: UICollectionViewCell {
    
    // MARK: - Init sub-views
    
    private let containerView: UIView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialisations
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - Public functions
    
    func bind() {
        containerView.showActivityIndicator()
    }
}

// MARK: - Setup

private extension GridImageLoadingCell {
    
    func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        setupContainerView()
    }
    
    func setupContainerView() {
        contentView.addSubview(containerView)
        containerView
            .leadingAnchor(equalTo: contentView.leadingAnchor)
            .trailingAnchor(equalTo: contentView.trailingAnchor)
            .topAnchor(equalTo: contentView.topAnchor)
            .bottomAnchor(equalTo: contentView.bottomAnchor)
            .heightAnchor(equalToConstant: Constants.cellSize)
    }
}
