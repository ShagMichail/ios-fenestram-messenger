//
//  BaseResponseEntity.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 20.07.2022.
//

import Foundation

public struct BaseResponseEntity<T: Codable>: Codable {
    public let data: T?
    public let error: ErrorEntity?
}

public struct ErrorEntity: Codable, LocalizedError {
    public let code: Int
    public let message: String
    
    public var errorDescription: String? {
        return message
    }
}
public struct BBaseResponseEntity: Codable {
    public let data: String
    public let error: ErrorEntity?
}
