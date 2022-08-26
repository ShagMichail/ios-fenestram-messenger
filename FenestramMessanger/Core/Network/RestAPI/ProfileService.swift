//
//  ProfileService.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public class ProfileService {
    
    private static let factory = RequestFactory()
    private static var profileFactory: ProfileRequestFactory?
    
    private init() {
    }
    
    private static func sendRequest<T>(
        modelType: T.Type,
        requestOptions: ProfileRequestRouter,
        completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
            profileFactory = factory.makeProfileFactory()
            profileFactory?.sendRequest(modelType: modelType, requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    private static func sendRequest(
        requestOptions: ProfileRequestRouter,
        completion: @escaping (Result<Bool, Error>) -> Void) {
            profileFactory = factory.makeProfileFactory()
            profileFactory?.sendRequest(requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    public static func getProfile(completion: @escaping (Result<UserEntity,Error>) -> Void) {
        sendRequest(modelType: UserEntity.self, requestOptions: .getProfile) { result in
            completion(result)
        }
    }
    
    public static func updateProfile(name: String, nickname: String, email: String, birthdate: TimeInterval, avatar: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        var parameters = [
            "name": name,
            "nickname": nickname,
            "email": email,
            "birth": Int(birthdate).description,
            //"avatar": avatar
        ]
        
        if let firebaseToken = Settings.firebaseToken {
            parameters["player_id"] = firebaseToken
        }
        
        sendRequest(requestOptions: .updateProfile(parameters: parameters)) { result in
            completion(result)
        }
    }
    
    public static func getContacts(completion: @escaping (Result<[UserEntity],Error>) -> Void) {
        sendRequest(modelType: [UserEntity].self, requestOptions: .getContacts) { result in
            completion(result)
        }
    }
}
