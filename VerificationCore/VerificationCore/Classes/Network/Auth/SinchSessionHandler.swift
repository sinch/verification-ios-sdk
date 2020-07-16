//
//  SinchSessionHandler.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire

/// Alamofire Interceptor used for modyfing API calls executed by  [ApiManager](x-source-tag://[ApiManager])
class SinchSessionHandler {
    
    let authorizationMethod: AuthorizationMethod
    
    /// Default initializer.
    /// - Parameter authorizationMethod: [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) used for veryfing API requests.
    init(authorizationMethod: AuthorizationMethod) {
        self.authorizationMethod = authorizationMethod
    }
    
}

extension SinchSessionHandler: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(authorizationMethod.onAuthorize(urlRequest)))
    }
    
}

