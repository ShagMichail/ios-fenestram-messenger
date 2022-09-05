//
//  FilesService.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 05.09.2022.
//

import Foundation

public class FilesService {
    
    private static let factory = RequestFactory()
    private static var filesFactory: FilesRequestFactory?
    
    private init() {
    }
    
    public static func sendUpload<T>(
        modelType: T.Type,
        requestOptions: FilesRequestRouter,
        completion: @escaping (Result<T, Error>) -> Void) where T : Codable {
        filesFactory = factory.makeFilesFactory()
        filesFactory?.sendUpload(modelType: modelType, requestOptions: requestOptions, completion: { result in
            completion(result)
        })
    }
    
    public static func upload(imageURL: URL, completion: @escaping (Result<FileEntity, Error>) -> Void) {
        let parameters: [String: Any] = ["file": imageURL.absoluteString]
        sendUpload(modelType: FileEntity.self, requestOptions: .upload(parameters: parameters)) { (result) in
            completion(result)
        }
    }
}
