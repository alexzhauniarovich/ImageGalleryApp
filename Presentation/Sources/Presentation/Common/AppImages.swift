import UIKit

enum AppImages {
    case bgImagePlaceholder
    case icFavorite
    case icUnfavorite
    case appLogo
}

extension AppImages {
    
    var value: UIImage {
        get {
            switch self {
            case .bgImagePlaceholder: return UIImage(named: "bg_image_placeholder") ?? UIImage()
            case .icFavorite: return UIImage(named: "ic_favorite") ?? UIImage()
            case .icUnfavorite: return UIImage(named: "ic_unfavorite") ?? UIImage()
            case .appLogo: return UIImage(named: "app_logo") ?? UIImage()
            }
        }
    }
}
