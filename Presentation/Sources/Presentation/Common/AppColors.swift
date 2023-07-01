import UIKit

enum AppColors {
    case appTheme
    case mainBackground
    case mainText
    case subText
}

extension AppColors {
    
    var value: UIColor {
        get {
            switch self {
            case .appTheme: return UIColor(named: "AccentColor") ?? UIColor()
            case .mainBackground: return UIColor(named: "MainBackground") ?? UIColor()
            case .mainText: return UIColor(named: "MainText") ?? UIColor()
            case .subText: return UIColor(named: "SubText") ?? UIColor()
            }
        }
    }
}
