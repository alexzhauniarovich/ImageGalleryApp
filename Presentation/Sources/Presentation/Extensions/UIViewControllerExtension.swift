import UIKit

extension UIViewController {
    
    func showErrorAlertMessage(message: String) {
        #if DEBUG
            let alertController = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        #endif
    }
}
