import UIKit

public class AppRouter {
    
    // MARK: - Private fields
    
    var window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    
    // MARK: - Public functions
    
    func startEntranceScreen() {
        let imagesGridViewController = AppDelegate
            .sharedInstance
            .appDependenciesGraph
            .prepareImagesGridViewController()
        
        let navigationController = UINavigationController(rootViewController: imagesGridViewController)
        navigationController.modalPresentationStyle = .fullScreen
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func restartApplication() {
        window.rootViewController?.dismiss(animated: true)
        startEntranceScreen()
    }
}
