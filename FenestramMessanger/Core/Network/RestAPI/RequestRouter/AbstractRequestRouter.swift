//
//  AbstractRequestRouter.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 13.07.2022.
//

import Foundation
import Alamofire

protocol AbstractRequestRouter: URLRequestConvertible {
    var baseUrl: URL { get }
    var fullUrl: URL { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
}

extension AbstractRequestRouter {
    
    var baseUrl: URL {
        let url = Constants.baseNetworkURL
        return URL.init(string: url)!
    }
    
    var fullUrl: URL {
        return baseUrl.appendingPathComponent(path)
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
}
