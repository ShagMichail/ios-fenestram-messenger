//
//  RequestFactory.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation
import Alamofire

class RequestFactory {
    private var authFactory: AuthRequestFactory?
    private var profileFactory: ProfileRequestFactory?
    private var chatFactory: ChatRequestFactory?
    private var contactsFactory: ContactsRequestFactory?
    private var filesFactory: FilesRequestFactory?
    
    private let sessionManager: Session
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        self.sessionManager = Session(configuration: configuration)
    }
    
    func makeAuthFactory() -> AuthRequestFactory {
        if let factory = authFactory {
            return factory
        } else {
            let factory = AuthRequestFactory(sessionManager: sessionManager)
            authFactory = factory
            return factory
        }
    }
    
    func makeProfileFactory() -> ProfileRequestFactory {
        if let factory = profileFactory {
            return factory
        } else {
            let factory = ProfileRequestFactory(sessionManager: sessionManager)
            profileFactory = factory
            return factory
        }
    }
    
    func makeChatFactory() -> ChatRequestFactory {
        if let factory = chatFactory {
            return factory
        } else {
            let factory = ChatRequestFactory(sessionManager: sessionManager)
            chatFactory = factory
            return factory
        }
    }
    
    func makeContactsFactory() -> ContactsRequestFactory {
        if let factory = contactsFactory {
            return factory
        } else {
            let factory = ContactsRequestFactory(sessionManager: sessionManager)
            contactsFactory = factory
            return factory
        }
    }
    
    func makeFilesFactory() -> FilesRequestFactory {
        if let factory = filesFactory {
            return factory
        } else {
            let factory = FilesRequestFactory(sessionManager: sessionManager)
            filesFactory = factory
            return factory
        }
    }
}
