//
//  FilesRequestRouter.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 05.09.2022.
//

import Foundation
import Alamofire

public enum FilesRequestRouter: AbstractRequestRouter {
    case upload(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .upload:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .upload:
            return "api/\(Constants.apiVersion)/files/upload"
        }
    }
    
    var headers: HTTPHeaders {
        guard let token = try? AuthController.getToken() else {
            return ["Content-Type": "multipart/form-data",
                    "accept": "*/*"]
        }
        
        return ["Content-Type": "multipart/form-data",
                "accept": "*/*",
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
        case .upload(let parameters):
            urlRequest = try CustomPatchEncding().encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
}
