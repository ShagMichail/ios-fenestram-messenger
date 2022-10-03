//
//  ChatService.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public class ChatService {
    
    private static let factory = RequestFactory()
    private static var chatFactory: ChatRequestFactory?
    
    private init() {
    }
    
    private static func sendRequest<T>(
        modelType: T.Type,
        requestOptions: ChatRequestRouter,
        completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
            chatFactory = factory.makeChatFactory()
            chatFactory?.sendRequest(modelType: modelType, requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    private static func sendPaginationRequest<T>(
        modelType: T.Type,
        requestOptions: ChatRequestRouter,
        completion: @escaping (Result<BaseResponseEntity<T>, Error>) -> Void) where T : Codable {
            chatFactory = factory.makeChatFactory()
            chatFactory?.sendPaginationRequest(modelType: modelType, requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    private static func sendRequest(
        requestOptions: ChatRequestRouter,
        completion: @escaping (Result<Bool, Error>) -> Void) {
            chatFactory = factory.makeChatFactory()
            chatFactory?.sendRequest(requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    public static func getChats(searchText: String, page: Int, limit: Int = 10, completion: @escaping (Result<BaseResponseEntity<[ChatEntity]>, Error>) -> Void) {
        var queryParameters: [URLQueryItem] = [
            .init(name: "limit", value: limit.description),
            .init(name: "page", value: page.description)
        ]
        if !searchText.isEmpty {
            queryParameters.append(.init(name: "like", value: searchText))
        }
        sendPaginationRequest(modelType: [ChatEntity].self, requestOptions: .getChats(queryParameters: queryParameters)) { result in
            completion(result)
        }
    }
    
    public static func createChat(chatName: String, usersId: [Int], isGroup: Bool, completion: @escaping (Result<ChatEntity, Error>) -> Void) {
        let parameters: [String: Any] = [
            "name": chatName,
            "users": usersId,
            "is_group": isGroup
        ]
        
        sendRequest(modelType: ChatEntity.self, requestOptions: .createChat(parameters: parameters)) { result in
            completion(result)
        }
    }
    
    public static func getChat(chatId: Int, completion: @escaping (Result<ChatEntity, Error>) -> Void) {
        sendRequest(modelType: ChatEntity.self, requestOptions: .getChat(chatId: chatId)) { result in
            completion(result)
        }
    }
    
    public static func postMessage(chatId: Int, messageType: MessageType, content: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let parameters: [String: Any] = [
            "message_type": messageType.rawValue,
            "text": content
        ]
        
        sendRequest(requestOptions: .postMessage(chatId: chatId, parameters: parameters)) { result in
            completion(result)
        }
    }
    
    public static func getMessages(chatId: Int, page: Int, limit: Int, completion: @escaping (Result<BaseResponseEntity<[MessageEntity]>, Error>) -> Void) {
        let queryParameters: [URLQueryItem] = [
            .init(name: "limit", value: limit.description),
            .init(name: "page", value: page.description)
        ]
        sendPaginationRequest(modelType: [MessageEntity].self, requestOptions: .getMessages(chatId: chatId, queryParameters: queryParameters)) { result in
            completion(result)
        }
    }
    
    public static func changeChatAvatar(chatId: Int, avatarURL: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let parameters: [String: Any] = [
            "avatar": avatarURL
        ]
        
        sendRequest(requestOptions: .changeChatAvatar(chatId: chatId, parameters: parameters)) { result in
            completion(result)
        }
    }
    
    public static func changeChatName(chatId: Int, name: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let parameters: [String: Any] = [
            "name": name
        ]
        
        sendRequest(requestOptions: .changeChatName(chatId: chatId, parameters: parameters)) { result in
            completion(result)
        }
    }
}
