//
//  ContactEntity.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 02.09.2022.
//

import Foundation

public struct ContactEntity: Codable, Identifiable {
    public let id: Int
    public let phone: String
    public let name: String
    public let user: UserEntity?
}
