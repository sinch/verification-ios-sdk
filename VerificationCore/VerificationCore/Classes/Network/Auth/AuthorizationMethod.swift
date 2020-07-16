//
//  AuthorizationMethod.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/**
 General interface used for implementing different kind of ways to authorize Sinch API requests.
  - Tag: AuthorizationMethod
*/
protocol AuthorizationMethod {
    
    /// Method invoked each time API call is made. Implementation should modify and return authorized version of the request.
    /// - Parameter urlRequest: Unauthorized request.
    /// - Returns: An authorized version of the request.
    func onAuthorize(_ urlRequest: URLRequest) -> URLRequest
    
}
