import UIKit

// Provides an easy way to setup view constraints directly in the swift code,
// especially friendly for creating views with simple UI

extension UIView {
    
    func addConstraint(_ constraint: NSLayoutConstraint, priority: UILayoutPriority) {
        constraint.priority = priority
        constraint.isActive = true
    }
}

// MARK: - Top anchor

extension UIView {
    
    @discardableResult
    func topAnchor(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(topAnchor.constraint(equalTo: anchor, constant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func topAnchor(
        greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant), priority: priority)
        return self
    }
}

// MARK: - Bottom anchor

extension UIView {
    
    @discardableResult
    func bottomAnchor(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(bottomAnchor.constraint(equalTo: anchor, constant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func bottomAnchor(
        greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func bottomAnchor(
        lessThanOrEqualTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant), priority: priority)
        return self
    }
}

// MARK: - Leading anchor

extension UIView {
    
    @discardableResult
    func leadingAnchor(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(leadingAnchor.constraint(equalTo: anchor, constant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func leadingAnchor(
        greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant), priority: priority)
        return self
    }
}

// MARK: - Trailing anchor

extension UIView {
    
    @discardableResult
    func trailingAnchor(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(trailingAnchor.constraint(equalTo: anchor, constant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func trailingAnchor(
        greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func trailingAnchor(
        lessThanOrEqualTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant), priority: priority)
        return self
    }
}

// MARK: - Cantering anchor

extension UIView {
    
    @discardableResult
    func centerXAnchor(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(centerXAnchor.constraint(equalTo: anchor, constant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func centerYAnchor(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(centerYAnchor.constraint(equalTo: anchor, constant: constant), priority: priority)
        return self
    }
}

// MARK: - Width anchor

extension UIView {
    
    @discardableResult
    func widthAnchor(equalToConstant constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        addConstraint(widthAnchor.constraint(equalToConstant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func widthAnchor(
        equalTo anchor: NSLayoutDimension,
        multiplier m: CGFloat = 1.0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(widthAnchor.constraint(equalTo: anchor, multiplier: m), priority: priority)
        return self
    }
    
    @discardableResult
    func widthAnchor(lessThanOrEqualToConstant constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        addConstraint(widthAnchor.constraint(lessThanOrEqualToConstant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func widthAnchor(greaterThanOrEqualToConstant constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        addConstraint(widthAnchor.constraint(greaterThanOrEqualToConstant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func widthAnchor(lessThanOrEqualTo anchor: NSLayoutDimension, priority: UILayoutPriority = .required) -> Self {
        addConstraint(widthAnchor.constraint(lessThanOrEqualTo: anchor), priority: priority)
        return self
    }
    
    @discardableResult
    func widthAnchor(greaterThanOrEqualTo anchor: NSLayoutDimension, priority: UILayoutPriority = .required) -> Self {
        addConstraint(widthAnchor.constraint(greaterThanOrEqualTo: anchor), priority: priority)
        return self
    }
    
    var widthConstraintReference: NSLayoutConstraint? {
        get { constraints.first(where: { $0.firstAttribute == .width && $0.relation == .equal }) }
        set {
            guard newValue != nil else { return }
            setNeedsLayout()
        }
    }
}

// MARK: - Height anchor

extension UIView {
    
    @discardableResult
    func heightAnchor(equalToConstant constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        addConstraint(heightAnchor.constraint(equalToConstant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func heightAnchor(greaterThanOrEqualToConstant constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        addConstraint(heightAnchor.constraint(greaterThanOrEqualToConstant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func heightAnchor(lessThanOrEqualToConstant constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        addConstraint(heightAnchor.constraint(lessThanOrEqualToConstant: constant), priority: priority)
        return self
    }
    
    @discardableResult
    func heightAnchor(
        equalTo anchor: NSLayoutDimension,
        multiplier m: CGFloat = 1.0,
        priority: UILayoutPriority = .required
    ) -> Self {
        addConstraint(heightAnchor.constraint(equalTo: anchor, multiplier: m), priority: priority)
        return self
    }
    
    var heightConstraintReference: NSLayoutConstraint? {
        get { constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) }
        set {
            guard newValue != nil else { return }
            setNeedsLayout()
        }
    }
}

extension UILayoutPriority {
    static let preRequired: UILayoutPriority = UILayoutPriority(rawValue: 999)
}
