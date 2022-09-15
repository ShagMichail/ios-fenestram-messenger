//
//  NetworkError.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation

public enum NetworkError {
    // Любой 500 код
    case serverError
    // Ответ не такой, как мы ожидаем
    case responseError
    // Ответа нет, отвалились по таймауту, отсуствует сеть
    case internetError
    // User already exists
    case userAlreadyExists
    // Session timed out
    case sessionTimedOut
    
    // Ошибка от сервера, когда пользователю не хватает места в хранилище
    case runOfSpace
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serverError:
            return L10n.NetworkError.LocalizedError.ErrorDescription.serverError
        case .responseError:
            return L10n.NetworkError.LocalizedError.ErrorDescription.responseError
        case .internetError:
            return L10n.NetworkError.LocalizedError.ErrorDescription.internetError
        case .userAlreadyExists:
            return L10n.NetworkError.LocalizedError.ErrorDescription.userAlreadyExists
        case .runOfSpace:
            return L10n.NetworkError.LocalizedError.ErrorDescription.runOfSpace
        case .sessionTimedOut:
            return L10n.NetworkError.LocalizedError.ErrorDescription.sessionTimedOut
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .serverError:
            return L10n.NetworkError.LocalizedError.RecoverySuggestion.serverError
        case .responseError:
            return L10n.NetworkError.LocalizedError.RecoverySuggestion.responseError
        case .internetError:
            return L10n.NetworkError.LocalizedError.RecoverySuggestion.internetError
        case .userAlreadyExists:
            return L10n.NetworkError.LocalizedError.RecoverySuggestion.userAlreadyExists
        case .runOfSpace:
            return L10n.NetworkError.LocalizedError.RecoverySuggestion.runOfSpace
        case .sessionTimedOut:
            return L10n.NetworkError.LocalizedError.RecoverySuggestion.sessionTimedOut
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .serverError:
            return ""
        case .responseError:
            return ""
        case .internetError:
            return ""
        case .userAlreadyExists:
            return "User already exists"
        case .runOfSpace:
            return ""
        case .sessionTimedOut:
            return ""
        }
    }
}
