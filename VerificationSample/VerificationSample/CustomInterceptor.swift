//
//  CustomInterceptor.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 29/12/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire

class CustomInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        //Example of adding cutom header
        var request = urlRequest
        request.addValue("test", forHTTPHeaderField: "customHeader")
        completion(.success(request))
    }
    
}
