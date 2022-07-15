//
//  AuthController.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public final class AuthController {
    static let serviceTokenName = "FenestramMessangerTokenService"
    
    public static var isSignedIn: Bool {
        return Settings.currentUser != nil
    }
    
    public class func getToken() throws -> String {
        guard let currentUser = Settings.currentUser else {
            return ""
        }
        return try KeychainPasswordItem(service: serviceTokenName, account: currentUser.phoneNumber).readPassword()
    }
    
    public class func signIn(_ user: UserEntity, token: String) throws {
        try KeychainPasswordItem(service: serviceTokenName, account: user.phoneNumber).savePassword(token)
        
        Settings.currentUser = user
        
        NotificationCenter.default.post(name: .loginStatusChanged, object: nil)
    }
    
    public class func signOut() throws {
        guard let currentUser = Settings.currentUser else {
            return
        }
        
        try KeychainPasswordItem(service: serviceTokenName, account: currentUser.phoneNumber).deleteItem()
        
        Settings.currentUser = nil
        NotificationCenter.default.post(name: .loginStatusChanged, object: nil)
    }
}
