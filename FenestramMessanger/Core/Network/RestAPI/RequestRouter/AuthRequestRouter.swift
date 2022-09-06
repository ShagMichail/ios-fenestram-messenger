//
//  AuthRequestRouter.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation
import Alamofire

public enum AuthRequestRouter: AbstractRequestRouter {
    case sendCode(parameters: Parameters)
    case login(parameters: Parameters)
    case refresh(parameters: Parameters)
    case setFirebaseToken(parameters: Parameters)
    case deleteFirebaseToken(firebaseToken: String)
    
    var method: HTTPMethod {
        switch self {
        case .sendCode, .login, .refresh, .setFirebaseToken:
            return .post
        case .deleteFirebaseToken:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .sendCode:
            return "api/\(Constants.apiVersion)/authorization/send_code"
        case .login:
            return "api/\(Constants.apiVersion)/authorization/login"
        case .refresh:
            return "api/\(Constants.apiVersion)/authorization/refresh"
        case .setFirebaseToken:
            return "api/\(Constants.apiVersion)/authorization/firebase_token"
        case .deleteFirebaseToken(let firebaseToken):
            return "api/\(Constants.apiVersion)/authorization/firebase_token/\(firebaseToken)"
        }
    }
    
     var headers: HTTPHeaders {
        switch self {
        case .sendCode, .login, .refresh:
            return ["Content-Type": "application/json",
                    "accept": "*/*"]
        case .setFirebaseToken, .deleteFirebaseToken:
            guard let token = try? AuthController.getToken() else {
                return ["Content-Type": "application/json",
                        "accept": "*/*"]
            }
            
            return ["Content-Type": "application/json",
                    "accept": "*/*",
                    "Authorization": "Bearer \(token)"]
        }
    }
    
    struct CustomPatchEncding: ParameterEncoding {
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            let mutableRequest = try? URLEncoding().encode(urlRequest, with: parameters) as? NSMutableURLRequest
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                mutableRequest?.httpBody = jsonData
                
            } catch {
                debugPrint(error.localizedDescription)
            }
            return mutableRequest! as URLRequest
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: fullUrl)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        switch self {
        case .sendCode(let parameters), .login(let parameters), .refresh(let parameters), .setFirebaseToken(let parameters):
            urlRequest = try CustomPatchEncding().encode(urlRequest, with: parameters)
        case .deleteFirebaseToken:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        return urlRequest
    }
}
