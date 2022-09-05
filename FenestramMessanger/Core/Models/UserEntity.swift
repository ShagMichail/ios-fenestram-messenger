//
//  UserEntity.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public struct TokenEntity: Codable {
    public let accessToken: String
    public let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

public struct UserWithTokenEntity: Codable, Identifiable {
    public let id: Int
    public let accessToken: String
    public let refreshToken: String
    
    public let phoneNumber: String
    
    public let name: String?
    public let nickname: String?
    public let email: String?
    public let birthdate: String?
    public var avatar: String?
    public var isOnline: Bool
    public let lastActivate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case phoneNumber = "phone"
        case name
        case nickname
        case email
        case birthdate = "birth"
        case avatar
        case isOnline = "is_online"
        case lastActivate = "last_active"
    }
}

public struct UserEntity: Codable, Identifiable, Equatable, Hashable {
    public let id: Int
    
    public let phoneNumber: String
    
    public var name: String?
    public var nickname: String?
    public var email: String?
    public var birthdate: String?
    public var avatar: String?
    public var isOnline: Bool
    public let lastActivate: String?
    
    public var birthday: Date? {
        guard let birthdate = birthdate,
              let birthdateTimeInterval = TimeInterval(birthdate) else {
            return nil
        }
        
        return Date(timeIntervalSince1970: birthdateTimeInterval)
    }
    
    public var isInfoEmpty: Bool {
        name == nil ||
        nickname == nil ||
        email == nil ||
        birthdate == nil ||
        avatar == nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber = "phone"
        case name
        case nickname
        case email
        case birthdate = "birth"
        case avatar
        case isOnline = "is_online"
        case lastActivate = "last_active"
    }
    
    init(from userWithToken: UserWithTokenEntity) {
        self.id = userWithToken.id
        self.phoneNumber = userWithToken.phoneNumber
        self.name = userWithToken.name
        self.nickname = userWithToken.nickname
        self.email = userWithToken.email
        self.birthdate = userWithToken.birthdate
        self.avatar = userWithToken.avatar
        self.isOnline = userWithToken.isOnline
        self.lastActivate = userWithToken.lastActivate
    }
}
