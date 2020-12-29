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
    private let customInterceptors: [RequestInterceptor]
    
    /// Default initializer.
    /// - Parameter authMethod: [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) used for veryfing API requests.
    /// - Parameter customInterceptors: Additional Alamofire interceptors that can modify the request just before passed to Sinch REST API.
    init(authMethod: AuthorizationMethod, protocolClass: AnyClass? = nil, customInterceptors: [RequestInterceptor] = []) {
        self.authMethod = authMethod
        self.protocolClass = protocolClass
        self.customInterceptors = customInterceptors
    }
    
    /// Specific session instance that should be used for interacting with SINCH API (making HTTP calls).
    lazy var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        if let protocolClass = protocolClass {
            configuration.protocolClasses = [protocolClass]
        }
        return Session(configuration: configuration,
                       interceptor: Interceptor(
                            adapters: [],
                            retriers: [],
                            interceptors: [SinchSessionHandler(authorizationMethod: authMethod)] + customInterceptors
                       ),
                       eventMonitors: [AlamofireLogger()])
    }()

}

final class AlamofireLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️ Request Started: \(request)
        ⚡️ Body Data: \(body)
        """
        NSLog(message)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        let body = response.data.map { String(decoding: $0, as: UTF8.self)  } ?? "None"
        NSLog("\n⚡️ Response Received: \(response.debugDescription)")
        NSLog("\n⚡️ Response Body: \(body)")
    }
}
