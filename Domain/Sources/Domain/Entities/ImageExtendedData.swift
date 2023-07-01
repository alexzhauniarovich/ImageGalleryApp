import Foundation

public struct ImageExtendedData: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id, description, location, urls
    }
    
    public let id: String?
    public let description: String?
    public let location: ImageLocation?
    public let urls: ImageUrls?
    public let isFavorite: Bool
    
    // MARK: - Initialisation
    
    public init(
        id: String?,
        description: String?,
        location: ImageLocation?,
        urls: ImageUrls?,
        isFavorite: Bool
    ) {
        self.id = id
        self.description = description
        self.location = location
        self.urls = urls
        self.isFavorite = isFavorite
    }
    
    public init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? container?.decode(String.self, forKey: .id)
        description = try? container?.decode(String.self, forKey: .description)
        location = try? container?.decode(ImageLocation.self, forKey: .location)
        urls = try? container?.decode(ImageUrls.self, forKey: .urls)
        isFavorite = false
    }
    
    // MARK: - Public functions
    
    public func encode(to encoder: Encoder) {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(id, forKey: .id)
        try? container.encode(description, forKey: .description)
        try? container.encode(location, forKey: .location)
        try? container.encode(urls, forKey: .urls)
    }
}
