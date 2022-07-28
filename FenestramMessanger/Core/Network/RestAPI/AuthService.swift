//
//  AuthService.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public class AuthService {
    
    private static let factory = RequestFactory()
    private static var authFactory: AuthRequestFactory?
    
    private init() {
    }
    
    private static func sendRequest<T>(
        modelType: T.Type,
        requestOptions: AuthRequestRouter,
        completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
            authFactory = factory.makeAuthFactory()
            authFactory?.sendRequest(modelType: modelType, requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    private static func sendRequest(
        requestOptions: AuthRequestRouter,
        completion: @escaping (Result<Bool, Error>) -> Void) {
            authFactory = factory.makeAuthFactory()
            authFactory?.sendRequest(requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    public static func sendCode(phoneNumber: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        let parameters: [String: Any] = [
            "phone": phoneNumber
        ]
        sendRequest(requestOptions: .sendCode(parameters: parameters)) { result in
            completion(result)
        }
    }
    
    public static func login(phoneNumber: String, oneTimeCode: String, completion: @escaping (Result<UserWithTokenEntity,Error>) -> Void) {
        let parameters = [
            "phone": phoneNumber,
            "code": oneTimeCode
        ]
        
        sendRequest(modelType: UserWithTokenEntity.self, requestOptions: .login(parameters: parameters)) { result in
            completion(result)
        }
    }
    
}
