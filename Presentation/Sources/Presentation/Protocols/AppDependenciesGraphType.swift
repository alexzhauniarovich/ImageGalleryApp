import Foundation

public protocol AppDependenciesGraphType {
    
    func prepareImagesGridViewController() -> ImagesGridViewController
    
    func prepareImagesOverviewViewController(imageIds: [String], selectedIndex: Int) -> ImagesOverviewViewController
}
