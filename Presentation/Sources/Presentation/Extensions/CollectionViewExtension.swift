import UIKit

extension UICollectionView: CellDescribable {
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
}
