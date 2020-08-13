//
//  ApiManager.swift
//  Verification
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire

/// Manager used for interacting with Sinch Verification API.
/// - Tag: ApiManager
class ApiManager {
    
    private let authMethod: AuthorizationMethod
    private let protocolClass: AnyClass?
    
    /// Default initializer.
    /// - Parameter authMethod: [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) used for veryfing API requests.
    init(authMethod: AuthorizationMethod, protocolClass: AnyClass? = nil) {
        self.authMethod = authMethod
        self.protocolClass = protocolClass
    }
    
    /// Specific session instance that should be used for interacting with SINCH API (making HTTP calls).
    lazy var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        if let protocolClass = protocolClass {
            configuration.protocolClasses = [protocolClass]
        }
        return Session(configuration: configuration, interceptor: SinchSessionHandler(authorizationMethod: authMethod), eventMonitors: [LoggingMonitor()])
    }()

}
