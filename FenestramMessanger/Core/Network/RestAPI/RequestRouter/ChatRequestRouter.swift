//
//  ChatRequestRouter.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation
import Alamofire

public enum ChatRequestRouter: AbstractRequestRouter {
    case getChats(limit: String, page: String)
    case createChat(parameters: Parameters)
    case getChat(chatId: Int)
    case postMessage(chatId: Int, parameters: Parameters)
    case getMessages(chatId: Int, limit: String, page: String)
    
    var method: HTTPMethod {
        switch self {
        case .getChats, .getChat, .getMessages:
            return .get
        case .createChat, .postMessage:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getChats, .createChat:
            return "api/\(Constants.apiVersion)/chats"
        case .getChat(let chatId):
            return "api/\(Constants.apiVersion)/chats/\(chatId)"
        case .postMessage(let chatId, _):
            return "api/\(Constants.apiVersion)/chats/message/\(chatId)"
        case .getMessages(let chatId, _, _):
            return "api/\(Constants.apiVersion)/chats/\(chatId)/messages"
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
        switch self {
        case .createChat(let parameters), .postMessage(_, let parameters):
            urlRequest = try CustomPatchEncding().encode(urlRequest, with: parameters)
        case .getChat:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .getChats(let limit, let page), .getMessages(_, let limit, let page):
            let url = getFullUrl(with: [URLQueryItem(name: "limit", value: limit),
                                        URLQueryItem(name: "page", value: page)])
            urlRequest = URLRequest(url: url)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers
        return urlRequest
    }
}

