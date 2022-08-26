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
    
    private static func sendRequest(
        requestOptions: ChatRequestRouter,
        completion: @escaping (Result<Bool, Error>) -> Void) {
            chatFactory = factory.makeChatFactory()
            chatFactory?.sendRequest(requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    private static func sendRequestCustom(
        requestOptions: ChatRequestRouter,
        completion: @escaping (Result<ChatEntityResult, Error>) -> Void) {
            chatFactory = factory.makeChatFactory()
            chatFactory?.sendRequestCustom(requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    public static func getChats(page: Int, completion: @escaping (Result<ChatEntityResult, Error>) -> Void) {
        sendRequestCustom(requestOptions: .getChats(limit: String(10), page: String(page))) { result in
            completion(result)
        }
    }
    
    public static func createChat(chatName: String, usersId: [Int], completion: @escaping (Result<ChatEntity, Error>) -> Void) {
        let parameters: [String: Any] = [
            "name": chatName,
            "users": usersId
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
    
    public static func postMessage(chatId: Int, messageType: MessageType, content: String, completion: @escaping (Result<MessageEntity, Error>) -> Void) {
        let parameters: [String: Any] = [
            "message_type": messageType.rawValue,
            "text": content
        ]
        
        sendRequest(modelType: MessageEntity.self, requestOptions: .postMessage(chatId: chatId, parameters: parameters)) { result in
            completion(result)
        }
    }
}
