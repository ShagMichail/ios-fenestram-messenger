//
//  ContactsRequestRouter.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 02.09.2022.
//

import Foundation
import Alamofire

public enum ContactsRequestRouter: AbstractRequestRouter {
    case getContacts
    case postContacts(phoneNumbers: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .getContacts:
            return .get
        case .postContacts:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getContacts, .postContacts:
            return "api/\(Constants.apiVersion)/contacts"
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
        case .postContacts(let parameters):
            urlRequest = try CustomPatchEncding().encode(urlRequest, with: parameters)
        case .getContacts:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        return urlRequest
    }
}
