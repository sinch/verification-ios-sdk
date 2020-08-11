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
    
    /// Default initializer.
    /// - Parameter authMethod: [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) used for veryfing API requests.
    init(authMethod: AuthorizationMethod) {
        self.authMethod = authMethod
    }
    
    /// Specific session instance that should be used for interacting with SINCH API (making HTTP calls).
    lazy var session: Session = {
        return Session(interceptor: SinchSessionHandler(authorizationMethod: authMethod), eventMonitors: [LoggingMonitor()])
    }()

}
