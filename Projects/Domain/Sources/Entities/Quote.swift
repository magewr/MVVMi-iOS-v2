import Foundation

public struct Quote: Codable, Equatable, Identifiable {
    public let id: String
    public let content: String
    public let author: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content = "en"
        case author
    }
    
    public init(id: String, content: String, author: String) {
        self.id = id
        self.content = content
        self.author = author
    }
}