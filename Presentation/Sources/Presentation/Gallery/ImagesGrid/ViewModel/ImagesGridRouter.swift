import UIKit

public class ImagesGridRouter {
    
    // MARK: - Private fields
    
    private let appDependenciesGraph: AppDependenciesGraphType
    
    // MARK: - Initialisation
    
    public required init(appDependenciesGraph: AppDependenciesGraphType) {
        self.appDependenciesGraph = appDependenciesGraph
    }
    
    // MARK: - Private functions
    
    public func showImagesOverviewScreen(from view: UIViewController, imagesIds: [String], selectedIndex: Int) {
        let imagesOverviewViewController = appDependenciesGraph.prepareImagesOverviewViewController(
            imageIds: imagesIds,
            selectedIndex: selectedIndex
        )
        view.navigationController?.pushViewController(imagesOverviewViewController, animated: true)
    }
}
