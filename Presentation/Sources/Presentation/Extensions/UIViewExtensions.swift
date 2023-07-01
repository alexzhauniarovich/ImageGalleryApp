import UIKit

private enum Constants {
    static let activityIndicatorTag = 100
}

// MARK: - View tap animations

extension UIView {
    
    func animateTapAction(completionHandler: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [],
            animations: { self.transform = .init(scaleX: 0.95, y: 0.95) },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0,
                    options: [],
                    animations: { self.transform = .identity },
                    completion: { _ in completionHandler?() }
                )
            }
        )
    }
}

// MARK: - Activity Indicator View

extension UIView {
    
    func removePreviousActivityIndicator() {
        if let existingIndicator = subviews.first(where: { $0.tag == Constants.activityIndicatorTag }) as? SpinnerView {
            existingIndicator.stopAnimating()
            existingIndicator.removeFromSuperview()
        }
    }
    
    func showActivityIndicator(
        size: CGSize = CGSize(width: 45, height: 45),
        topOffset: CGFloat = -40
    ) {
        removePreviousActivityIndicator()
        let activityIndicator = SpinnerView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tag = Constants.activityIndicatorTag
        
        addSubview(activityIndicator)
        activityIndicator
            .heightAnchor(equalToConstant: size.height)
            .widthAnchor(equalToConstant: size.width)
            .centerXAnchor(equalTo: centerXAnchor)
            .centerYAnchor(equalTo: centerYAnchor, constant: topOffset)
        
        bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        removePreviousActivityIndicator()
    }
}
