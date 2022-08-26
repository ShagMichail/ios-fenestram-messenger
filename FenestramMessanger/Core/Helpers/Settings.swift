//
//  Settings.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public final class Settings {
    
    private enum Keys: String {
        case user = "current_user"
        case firebaseToken = "firebase_token"
    }
    
    static func jsonContainer<T: Encodable>(value: T) -> [String: T] {
        return ["value": value]
    }
    
    static var currentUser: UserEntity? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.user.rawValue) else {
                return nil
            }
            return try? JSONDecoder().decode(UserEntity.self, from: data)
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: Keys.user.rawValue)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.user.rawValue)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var firebaseToken: String? {
        get {
            UserDefaults.standard.value(forKey: Keys.firebaseToken.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.firebaseToken.rawValue)
        }
    }
}
