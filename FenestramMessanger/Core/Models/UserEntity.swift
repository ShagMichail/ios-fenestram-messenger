//
//  UserEntity.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public struct UserWithTokenEntity: Codable, Identifiable {
    public let id: Int
    public let accessToken: String
    
    public let phoneNumber: String
    
    public let name: String
    public let login: String
    public let email: String
    public let birthdate: String
    public let playerId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case accessToken = "access_token"
        case phoneNumber = "phone"
        case name
        case login
        case email
        case birthdate = "birth"
        case playerId = "player_id"
    }
}

public struct UserEntity: Codable, Identifiable {
    public let id: Int
    
    public let phoneNumber: String
    
    public let name: String
    public let login: String
    public let email: String
    public let birthdate: String
    public let playerId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber = "phone"
        case name
        case login
        case email
        case birthdate = "birth"
        case playerId = "player_id"
    }
    
    init(from userWithToken: UserWithTokenEntity) {
        self.id = userWithToken.id
        self.phoneNumber = userWithToken.phoneNumber
        self.name = userWithToken.name
        self.login = userWithToken.login
        self.email = userWithToken.email
        self.birthdate = userWithToken.birthdate
        self.playerId = userWithToken.playerId
    }
}
