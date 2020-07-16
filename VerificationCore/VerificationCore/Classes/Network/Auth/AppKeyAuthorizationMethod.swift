//
//  AppKeyAuthorizationMethod.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/**
 [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) that uses application key to authorize API requests. To get the key check your application page on
 [Sinch Dashboard](https://portal.sinch.com/)
*/
class AppKeyAuthorizationMethod {
    
    let appKey: String
    
    /// Default initializer
    /// - Parameter appKey: Application key assigned to the app.
    init(appKey: String) {
        self.appKey = appKey
    }
    
}

extension AppKeyAuthorizationMethod: AuthorizationMethod {
    
    func onAuthorize(_ urlRequest: URLRequest) -> URLRequest {
        var modifiedRequest = urlRequest
        modifiedRequest.setValue("Application \(appKey)", forHTTPHeaderField: "Authorization")
        return modifiedRequest
    }
    
}
