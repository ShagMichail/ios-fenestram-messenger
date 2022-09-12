//
//  ContactsService.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 02.09.2022.
//

import Foundation

public class ContactsService {
    
    private static let factory = RequestFactory()
    private static var contactsFactory: ContactsRequestFactory?
    
    private init() {
    }
    
    private static func sendRequest<T>(
        modelType: T.Type,
        requestOptions: ContactsRequestRouter,
        completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
            contactsFactory = factory.makeContactsFactory()
            contactsFactory?.sendRequest(modelType: modelType, requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    private static func sendRequest(
        requestOptions: ContactsRequestRouter,
        completion: @escaping (Result<Bool, Error>) -> Void) {
            contactsFactory = factory.makeContactsFactory()
            contactsFactory?.sendRequest(requestOptions: requestOptions, completion: { result in
                completion(result)
            })
        }
    
    public static func getContacts(completion: @escaping (Result<[ContactEntity], Error>) -> Void) {
        sendRequest(modelType: [ContactEntity].self, requestOptions: .getContacts) { result in
            completion(result)
        }
    }
    
    public static func postContacts(contacts: [PhoneBookEntity], completion: @escaping (Result<Bool, Error>) -> Void) {
        var contactsAPI: [[String: Any]] = []
        contacts.forEach { contact in
            contact.phoneNumbers.forEach { phoneNumber in
                contactsAPI.append([
                    "name": "\(contact.givenName) \(contact.familyName)",
                    "phone": phoneNumber
                ])
            }
        }
        
        let parameters: [String: Any] = [
            "contacts": contactsAPI
        ]
        
        if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
            print("post contacts parameters:")
            print(String(bytes: prettyPrintedData, encoding: String.Encoding.utf8) ?? "NIL")
        }
        
        sendRequest(requestOptions: .postContacts(phoneNumbers: parameters)) { result in
            completion(result)
        }
    }
    
    public static func postContacts(name: String, phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let parameters: [String: Any] = [
            "contacts": [
                [
                    "name": name,
                    "phone": phoneNumber
                ]
            ]
        ]
        
        if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
            print("post contacts parameters:")
            print(String(bytes: prettyPrintedData, encoding: String.Encoding.utf8) ?? "NIL")
        }
        
        sendRequest(requestOptions: .postContacts(phoneNumbers: parameters)) { result in
            completion(result)
        }
    }
}
