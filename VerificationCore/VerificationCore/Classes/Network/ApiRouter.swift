//
//  ApiRouter.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//


import Alamofire

/// Protocol defining properties of each SINCH API request.
public protocol APIRouter: URLRequestConvertible {
    
    /// HTTP method used for making the request.
    var method: HTTPMethod { get }
    
    /// String concatanated to baseURL before constructing full URL of the endpoint.
    var path: String { get }
    
    /// A type used to define how parameters are applied to request.
    var encoding: ParameterEncoding { get }
    
    /// A dictionary of parameters applied to request.
    var parameters: Parameters { get }
    
    /// Additional headers passed with a request.
    var headers: HTTPHeaders { get }
    
    var appendPathToBaseUrl: Bool { get }
}

public extension APIRouter {
    
    var appendPathToBaseUrl: Bool {
        return true
    }
    
    /// Sinch API base URL (differs based on used environment).
    var baseURL: URL {
        return URL(string: "\(Constants.Api.domain)verification/\(Constants.Api.version)")!
    }
    
    /// Converts specific route to an `URLRequest`.
    /// - Throws: Any `Error` produced during converting to `URLRequest`.
    /// - Returns: `URLRequest` of given route to be proceeded by Alamofire framework.
    func asURLRequest() throws -> URLRequest {
        let url = appendPathToBaseUrl ? baseURL.appendingPathComponent(path) : URL(string: path)!
        var urlRequest = try URLRequest(url: url, method: method)
        headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.name) }
        return try encoding.encode(urlRequest, with: parameters)
    }
}
