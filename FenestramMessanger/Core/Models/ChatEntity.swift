//
//  ChatEntity.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public struct ChatEntity: Codable, Identifiable {
    public let id: Int
    
    public let name: String
    public let usersId: [Int]
    public let isGroup: Bool
    public var messages: [MessageEntity]?
    public let createdAt: Date?
    public let avatar: String?
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.isGroup = try values.decode(Bool.self, forKey: .isGroup)
        let userIds = try values.decode([Int].self, forKey: .usersId)
        self.usersId = Array(Set(userIds))
        self.messages = try? values.decode([MessageEntity].self, forKey: .messages)
        self.avatar = try? values.decode(String.self, forKey: .avatar)
        
        if let createdAtString = try? values.decode(String.self, forKey: .createdAt),
           let createdAt = Date.isoDateFormatter.date(from: createdAtString) {
            self.createdAt = createdAt
        } else {
            self.createdAt = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isGroup = "is_group"
        case createdAt = "created_at"
        case usersId = "users"
        case messages = "message"
        case avatar
    }
}
