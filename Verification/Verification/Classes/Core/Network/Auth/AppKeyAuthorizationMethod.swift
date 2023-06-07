//
//  AppKeyAuthorizationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation

/**
 [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) that uses application key to authorize API requests. To get the key check your application page on
 [Sinch Dashboard](https://portal.sinch.com/)
*/
public class AppKeyAuthorizationMethod {
    
    let appKey: String
    
    /// Default initializer
    /// - Parameter appKey: Application key assigned to the app.
    public init(appKey: String) {
        self.appKey = appKey
    }
    
}

extension AppKeyAuthorizationMethod: AuthorizationMethod {
    
    public func onAuthorize(_ urlRequest: URLRequest) -> URLRequest {
      guard let host = urlRequest.url?.host, host.contains("sinch") else {
        return urlRequest
      }
        var modifiedRequest = urlRequest
        modifiedRequest.setValue("Application \(appKey)", forHTTPHeaderField: "Authorization")
        return modifiedRequest
    }
    
}
