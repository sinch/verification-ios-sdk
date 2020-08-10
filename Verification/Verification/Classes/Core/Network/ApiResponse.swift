//
//  ApiResponse.swift
//  Verification
//
//  Created by Aleksander Wojcik on 17/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

typealias ResponseHeaders = [String: String]

/// Enumeration used for implementing API callbacks by specific verification methods after processed by Alamofire framework.
enum ApiResponse<T: Decodable> {
    case success(T, ResponseHeaders)
    case failure(Error)
}
