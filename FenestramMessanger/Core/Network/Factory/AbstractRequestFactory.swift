//
//  AbstractRequestFactory.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation
import Alamofire

protocol AbstractRequestFactory {
    var sessionManager: Session { get }
    var queue: DispatchQueue { get }
    
    @discardableResult
    func request(_ request: URLRequestConvertible) -> DataRequest
    
    @discardableResult
    func uploadMultipartFormData(_ request: URLRequestConvertible) -> DataRequest?
    
    @discardableResult
    func downloadFile(from URL: URL, fileNamePath: String) -> DownloadRequest
}

extension AbstractRequestFactory {
    @discardableResult
    func request(_ request: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(request)
    }
    
    @discardableResult
    func uploadMultipartFormData(_ request: URLRequestConvertible) -> DataRequest? {
        guard let request = try? request.asURLRequest(),
              let url = request.url,
              let parametersData = request.httpBody,
              let parameters = try? JSONSerialization.jsonObject(with: parametersData, options: []) as? [String: Any] else { return nil }
        
        let multipartFormData = MultipartFormData()
        parameters.forEach { key, value in
            if let valueString = value as? String {
                if let valueURL = URL(string: valueString) {
                    multipartFormData.append(valueURL, withName: key)
                } else if let data = valueString.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
                return
            }
        }
        return AF.upload(multipartFormData: multipartFormData, to: url, headers: request.headers)
    }
    
    @discardableResult
    func downloadFile(from URL: URL, fileNamePath: String) -> DownloadRequest {
        print("AbstractRequestFactory downLoadFile(from URL: ", URL.absoluteString, ")")
        let destination: DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileNamePath)
            print("Try to save to documents URL: ", documentsURL, ")")
            return (documentsURL, [.removePreviousFile])
        }

        return AF.download(URL, to: destination).downloadProgress(queue: .global(qos: .background)) { progress in
            print("Download progress: ", progress.fractionCompleted,")")
        }
        
    }
}
