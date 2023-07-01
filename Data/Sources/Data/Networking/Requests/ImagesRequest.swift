import Foundation

enum ImagesRequest: Requestable {
    
    case requestImages(page: Int, pageSize: Int)
    case requestImageDetails(imageId: String)
    
    var path: String {
        switch self {
        case .requestImages: return "photos"
        case .requestImageDetails(let imageId): return "photos/\(imageId)"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var params: RequestParameter {
        switch self {
        case .requestImages(let page, let pageSize):
            return .urlQuery([
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(pageSize))
            ])
            
        case .requestImageDetails:
            return .none
        }
    }
}
