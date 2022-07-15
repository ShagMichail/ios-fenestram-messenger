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
    
    public let name: String?
    public let nickname: String?
    public let email: String?
    public let birthdate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case accessToken = "access_token"
        case phoneNumber = "phone"
        case name
        case nickname = "login"
        case email
        case birthdate = "birth"
    }
}

public struct UserEntity: Codable, Identifiable {
    public let id: Int
    
    public let phoneNumber: String
    
    public var name: String?
    public var nickname: String?
    public var email: String?
    public var birthdate: String?
    
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
        birthdate == nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case phoneNumber = "phone"
        case name
        case nickname = "login"
        case email
        case birthdate = "birth"
    }
    
    init(from userWithToken: UserWithTokenEntity) {
        self.id = userWithToken.id
        self.phoneNumber = userWithToken.phoneNumber
        self.name = userWithToken.name
        self.nickname = userWithToken.nickname
        self.email = userWithToken.email
        self.birthdate = userWithToken.birthdate
    }
}
