
public class CommonError: Error {
    
    // MARK: - Public fields
   
    public let errorMessage: String
    
    // MARK: - Initialisation
    
    public required init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
