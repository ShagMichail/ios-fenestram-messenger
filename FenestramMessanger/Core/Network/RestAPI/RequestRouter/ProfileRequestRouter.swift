//
//  ProfileRequestRouter.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation
import Alamofire

public enum ProfileRequestRouter: AbstractRequestRouter {
    case getProfile
    case updateProfile(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        case .updateProfile:
            return .patch
        }
    }
    
    var path: String {
        switch self {
        case .getProfile, .updateProfile:
            return "api/\(Constants.apiVersion)/profile"
        }
    }
    
    var headers: HTTPHeaders {
        guard let token = try? AuthController.getToken() else {
            return ["Content-Type": "application/json",
                    "Accept": "application/json"]
        }
        
        return ["Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(token)"]
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
        case .updateProfile(let parameters):
            urlRequest = try CustomPatchEncding().encode(urlRequest, with: parameters)
        case .getProfile:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        return urlRequest
    }
}
