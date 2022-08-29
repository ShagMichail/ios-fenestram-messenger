//
//  MessageEntity.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public enum MessageType: String, Codable {
    case text = "text"
}

public struct MessageResponse: Codable {
    public let message: MessageEntity
}

public struct MessageEntity: Codable, Identifiable, Equatable {
    public let id: Int
    
    public let fromUserId: Int
    public let message: String
    public let messageType: MessageType
    public let createdAt: Date?
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.fromUserId = try values.decode(Int.self, forKey: .fromUserId)
        self.message = try values.decode(String.self, forKey: .message)
        self.messageType = try values.decode(MessageType.self, forKey: .messageType)
        
        if let createdAtString = try? values.decode(String.self, forKey: .createdAt),
           let createdAt = Date.isoDateFormatter.date(from: createdAtString) {
            self.createdAt = createdAt
        } else {
            self.createdAt = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromUserId = "initiator_id"
        case message = "text"
        case messageType = "message_type"
        case createdAt = "created_at"
    }
}
