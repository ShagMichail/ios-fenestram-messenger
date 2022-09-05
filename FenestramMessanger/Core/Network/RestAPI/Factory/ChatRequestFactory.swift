//
//  ChatRequestFactory.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation
import Alamofire

final class ChatRequestFactory: AbstractRequestFactory {
    var sessionManager: Session
    var queue: DispatchQueue
    
    init(sessionManager: Session, queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)) {
        self.sessionManager = sessionManager
        self.queue = queue
    }
    
    public func sendRequest<T>(modelType: T.Type,
                               requestOptions: ChatRequestRouter,
                               completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
        self.request(requestOptions).response { response in
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(NetworkError.serverError))
                return
            }
            switch statusCode {
            case 200 ... 399:
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(BaseResponseEntity<T>.self, from: data)
                        
                        if let error = decodedData.error {
                            completion(.failure(error))
                        } else if let data = decodedData.data {
                            completion(.success(data))
                        } else {
                            completion(.failure(NetworkError.responseError))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            case 400...499:
                guard statusCode != 401 else {
                    AuthService.refresh { result in
                        switch result {
                        case .success(let token):
                            guard let currentUser = Settings.currentUser else {
                                try? AuthController.signOut()
                                return
                            }
                            do {
                                try AuthController.signIn(currentUser, accessToken: token.accessToken, refreshToken: token.refreshToken)
                            }
                            catch {
                                try? AuthController.signOut()
                            }
                        case .failure:
                            try? AuthController.signOut()
                        }
                    }
                    return
                }
                completion(.failure(NetworkError.responseError))
            case 500...599:
                completion(.failure(NetworkError.serverError))
            default:
                return completion(.failure(NetworkError.serverError))
            }
        }
    }
    
    public func sendPaginationRequest<T>(modelType: T.Type,
                               requestOptions: ChatRequestRouter,
                               completion: @escaping (Result<BaseResponseEntity<T>, Error>) -> Void) where T : Codable {
        self.request(requestOptions).response { response in
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(NetworkError.serverError))
                return
            }
            switch statusCode {
            case 200 ... 399:
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(BaseResponseEntity<T>.self, from: data)
                        
                        if let error = decodedData.error {
                            completion(.failure(error))
                        } else {
                            completion(.success(decodedData))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            case 400...499:
                guard statusCode != 401 else {
                    AuthService.refresh { result in
                        switch result {
                        case .success(let token):
                            guard let currentUser = Settings.currentUser else {
                                try? AuthController.signOut()
                                return
                            }
                            do {
                                try AuthController.signIn(currentUser, accessToken: token.accessToken, refreshToken: token.refreshToken)
                            }
                            catch {
                                try? AuthController.signOut()
                            }
                        case .failure:
                            try? AuthController.signOut()
                        }
                    }
                    return
                }
                completion(.failure(NetworkError.responseError))
            case 500...599:
                completion(.failure(NetworkError.serverError))
            default:
                return completion(.failure(NetworkError.serverError))
            }
        }
    }
    
    public func sendRequest(requestOptions: ChatRequestRouter,
                            completion: @escaping (Result<Bool, Error>) -> Void) {
        self.request(requestOptions).response { (response) in
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(NetworkError.serverError))
                return
            }
            switch statusCode {
            case 200 ... 399:
                completion(.success(true))
            case 400...499:
                guard statusCode != 401 else {
                    AuthService.refresh { result in
                        switch result {
                        case .success(let token):
                            guard let currentUser = Settings.currentUser else {
                                try? AuthController.signOut()
                                return
                            }
                            do {
                                try AuthController.signIn(currentUser, accessToken: token.accessToken, refreshToken: token.refreshToken)
                            }
                            catch {
                                try? AuthController.signOut()
                            }
                        case .failure:
                            try? AuthController.signOut()
                        }
                    }
                    return
                }
                completion(.failure(NetworkError.responseError))
            case 500...599:
                completion(.failure(NetworkError.serverError))
            default:
                return completion(.failure(NetworkError.serverError))
            }
        }
    }
}
