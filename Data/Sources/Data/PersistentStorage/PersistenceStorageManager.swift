import Combine
import Domain
import CoreData

private enum Constants {
    static let containerName = "FavouriteImagesStorage"
}

public class PersistenceStorageManager {
    
    // MARK: - Private fields
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    // MARK: - Initialisation
    
    public required init() {
        guard
            let objectModePath = Bundle.module.url(forResource: Constants.containerName, withExtension: "momd"),
            let objectModel = NSManagedObjectModel(contentsOf: objectModePath)
        else { fatalError("Failed to retrieve the FavouriteImagesStorage model") }
        
        persistentContainer = NSPersistentContainer(name: Constants.containerName, managedObjectModel: objectModel)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
        })
        context = persistentContainer.viewContext
    }
    
    // MARK: - Public functions
    
     func retrieveImages() -> AnyPublisher<[String], Error> {
         let imageIdsFetch: NSFetchRequest<CoreDataImage> = CoreDataImage.fetchRequest()
         return Just(try? context.fetch(imageIdsFetch))
             .tryMap {
                 guard let imagesIds = $0
                 else { throw CommonError(errorMessage: "Can't read core data context")}
                 return imagesIds.compactMap { $0.imageId }
             }
             .eraseToAnyPublisher()
    }
    
     func addImage(id: String) {
         let coreDataImage = CoreDataImage(context: context)
         coreDataImage.setValue(id, forKey: #keyPath(CoreDataImage.imageId))
         saveContext()
    }
    
     func removeImage(id: String) {
         let imageIdsFetch: NSFetchRequest<CoreDataImage> = CoreDataImage.fetchRequest()
         let predicate = NSPredicate(format: "imageId == %@", id)
         imageIdsFetch.predicate = predicate
         if let fetchResultItem = (try? context.fetch(imageIdsFetch))?.first {
             context.delete(fetchResultItem)
             saveContext()
         }
    }
    
    // MARK: - Private functions
    
    private func saveContext() {
        if context.hasChanges {
            do { try context.save() } catch { context.rollback() }
        }
    }
}
