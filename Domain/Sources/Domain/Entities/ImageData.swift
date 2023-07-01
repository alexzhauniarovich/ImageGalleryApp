
public struct ImageData: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id, urls
    }
    
    public let id: String?
    public let urls: ImageUrls?
    public let isFavorite: Bool
    
    // MARK: - Initialisation
    
    public init(id: String?, urls: ImageUrls?, isFavorite: Bool) {
        self.id = id
        self.urls = urls
        self.isFavorite = isFavorite
    }
    
    public init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = try? container?.decode(String.self, forKey: .id)
        urls = try? container?.decode(ImageUrls.self, forKey: .urls)
        isFavorite = false
    }
    
    // MARK: - Public functions
    
    public func encode(to encoder: Encoder) {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(id, forKey: .id)
        try? container.encode(urls, forKey: .urls)
    }
}
