import UIKit

protocol CellDescribable {
    static var identifier: String { get }
}

protocol CellBindable {
    associatedtype Item

    @discardableResult
    func bind(_ item: Item) -> Self
}

extension CellDescribable {

    static var identifier: String { String(describing: self) }
}
