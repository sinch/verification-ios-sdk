//
//  ApiResponse.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 17/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

public typealias ResponseHeaders = [String: String]

/// Enumeration used for implementing API callbacks by specific verification methods after processed by Alamofire framework.
public enum ApiResponse<T: Decodable> {
    case success(T, ResponseHeaders)
    case failure(Error)
}
