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
            return "Ошибка сервера. Пожалуйста, попробуйте позже"
        case .responseError:
            return "ой, что-то пошло не так"
        case .internetError:
            return "Нет соединения с интернетом"
        case .userAlreadyExists:
            return "Пользователь с этим адресом уже существует"
        case .runOfSpace:
            return "Закончилось место"
        case .sessionTimedOut:
            return "Ваша сессия истекла"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .serverError:
            return "Сервер недоступен"
        case .responseError:
            return "Проверьте правильность вводимых данных"
        case .internetError:
            return "Пожалуйста, проверьте ваше интернет-соединение"
        case .userAlreadyExists:
            return "Аккаунт зарегистрирован воспользуйтесь восстановлением пароля"
        case .runOfSpace:
            return "Пожалуйста, освободите место в памяти телефона"
        case .sessionTimedOut:
            return "Не удалось получить новые аутентификационные данные"
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
