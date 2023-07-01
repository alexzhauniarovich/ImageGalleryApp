import UIKit

extension UITableViewCell {
    static var identifier: String { String(describing: self) }
}

extension UICollectionReusableView {
    static var identifier: String { String(describing: self) }
}
