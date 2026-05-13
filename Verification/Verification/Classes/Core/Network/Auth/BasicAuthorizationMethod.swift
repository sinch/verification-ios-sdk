//
//  BasicAuthorizationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 13/05/2026.
//  Copyright © 2026 Sinch. All rights reserved.
//

import Foundation

/**
 [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) that uses application key and application secret
 to authorize API requests. To get the key and secret check your application page on
 [Sinch Dashboard](https://portal.sinch.com/)
*/
public class BasicAuthorizationMethod {

    let appKey: String
    let appSecret: String

    /// Default initializer
    /// - Parameters:
    ///   - appKey: Application key assigned to the app.
    ///   - appSecret: Application secret assigned to the app.
    public init(appKey: String, appSecret: String) {
        self.appKey = appKey
        self.appSecret = appSecret
    }

}

extension BasicAuthorizationMethod: AuthorizationMethod {

    public func onAuthorize(_ urlRequest: URLRequest) -> URLRequest {
        guard let host = urlRequest.url?.host, host.contains("sinch") else {
            return urlRequest
        }
        var modifiedRequest = urlRequest
        let credentials = "\(appKey):\(appSecret)"
        let data = Data(credentials.utf8).base64EncodedString()
        modifiedRequest.setValue("Basic \(data)", forHTTPHeaderField: "Authorization")
        return modifiedRequest
    }

}
