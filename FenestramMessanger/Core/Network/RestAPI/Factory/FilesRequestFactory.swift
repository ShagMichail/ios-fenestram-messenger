//
//  FilesRequestFactory.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 05.09.2022.
//

import Foundation
import Alamofire

final class FilesRequestFactory: AbstractRequestFactory {
    var sessionManager: Session
    var queue: DispatchQueue
    
    init(sessionManager: Session, queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)) {
        self.sessionManager = sessionManager
        self.queue = queue
    }
    
    public func sendUpload<T>(
        modelType: T.Type,
        requestOptions: FilesRequestRouter,
        completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
            guard let uploadTask = self.uploadMultipartFormData(requestOptions) else {
                print("Upload failure")
                return
            }
            
            uploadTask.response { (response) in
                guard let statusCode = response.response?.statusCode else {
                    if case let .failure(error) = response.result, let urlError = error.underlyingError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet:
                            completion(.failure(NetworkError.internetError))
                        case URLError.Code.init(rawValue: -1020):
                            completion(.failure(NetworkError.internetError))
                        default:
                            completion(.failure(NetworkError.serverError))
                        }
                    } else {
                        completion(.failure(NetworkError.serverError))
                    }
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
                        AuthService.refresh { [weak self] result in
                            switch result {
                            case .success(let token):
                                guard let currentUser = Settings.currentUser else {
                                    try? AuthController.signOut()
                                    return
                                }
                                do {
                                    try AuthController.signIn(currentUser, accessToken: token.accessToken, refreshToken: token.refreshToken)
                                    self?.sendUpload(modelType: modelType, requestOptions: requestOptions, completion: completion)
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
