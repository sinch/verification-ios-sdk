//
//  VerificationRouter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

enum VerificationRouter {
    case verifyById(id: String, data: VerificationData)
}

extension VerificationRouter: APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .verifyById:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .verifyById(let id, _):
            return "verifications/id/\(id)"
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .verifyById:
            return JSONEncoding.default
        }
    }
    
    var parameters: Parameters {
        let encodableData: Encodable
        switch self {
        case .verifyById(_, let verificationData):
            encodableData = verificationData
        }
        return encodableData.asDictionary
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .verifyById:
            return [:]
        }
    }
    
}
