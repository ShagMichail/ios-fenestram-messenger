//
//  AuthController.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public final class AuthController {
    static let serviceTokenName = "FenestramMessangerTokenService"
    static let serviceRefreshTokenName = "FenestramMessangerRefreshTokenService"
    
    public static var isSignedIn: Bool {
        return Settings.currentUser != nil
    }
    
    public class func getToken() throws -> String {
        guard let currentUser = Settings.currentUser else {
            return ""
        }
        return try KeychainPasswordItem(service: serviceTokenName, account: currentUser.phoneNumber).readPassword()
    }
    
    public class func getRefreshToken() throws -> String {
        guard let currentUser = Settings.currentUser else {
            return ""
        }
        return try KeychainPasswordItem(service: serviceRefreshTokenName, account: currentUser.phoneNumber).readPassword()
    }
    
    public class func signIn(_ user: UserEntity, accessToken: String, refreshToken: String) throws {
        try KeychainPasswordItem(service: serviceTokenName, account: user.phoneNumber).savePassword(accessToken)
        try KeychainPasswordItem(service: serviceRefreshTokenName, account: user.phoneNumber).savePassword(refreshToken)
        
        Settings.currentUser = user
        
        if let firebaseToken = Settings.firebaseToken {
            AuthService.setFirebaseToken(firebaseToken: firebaseToken) { result in
                switch result {
                case .success:
                    print("set firebase token success")
                case .failure(let error):
                    print("set firebase token failure with error: ", error.localizedDescription)
                }
            }
        }
        
        ContactsService.postContacts(contacts: PhoneBookEntity.generateModelArray()) { result in
            switch result {
            case .success:
                print("post contacts success")
            case .failure(let error):
                print("post contacts failure with error: ", error.localizedDescription)
            }
            
            NotificationCenter.default.post(name: .loginStatusChanged, object: nil)
        }
    }
    
    public class func signOut() throws {
        guard let currentUser = Settings.currentUser else {
            return
        }
        
        if let firebaseToken = Settings.firebaseToken {
            AuthService.deleteFirebaseToken(firebaseToken: firebaseToken) { result in
                switch result {
                case .success:
                    print("delete firebase token success")
                    Settings.firebaseToken = nil
                case .failure(let error):
                    print("delete firebase token failure with error: ", error.localizedDescription)
                }
            }
        }
        
        try KeychainPasswordItem(service: serviceTokenName, account: currentUser.phoneNumber).deleteItem()
        try KeychainPasswordItem(service: serviceRefreshTokenName, account: currentUser.phoneNumber).deleteItem()
        
        Settings.currentUser = nil
        NotificationCenter.default.post(name: .loginStatusChanged, object: nil)
    }
}
