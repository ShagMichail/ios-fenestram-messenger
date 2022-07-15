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
    
    var method: HTTPMethod {
        switch self {
        case .sendCode, .login:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .sendCode:
            return "api/\(Constants.apiVersion)/authorization/send_code"
        case .login:
            return "api/\(Constants.apiVersion)/authorization/login"
        }
    }
    
     var headers: HTTPHeaders {
        switch self {
        case .sendCode, .login:
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
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
        case .sendCode(let parameters), .login(let parameters):
            urlRequest = try CustomPatchEncding().encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
}
