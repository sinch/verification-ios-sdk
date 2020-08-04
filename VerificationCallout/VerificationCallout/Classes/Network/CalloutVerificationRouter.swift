//
//  CalloutVerificationRouter.swift
//  VerificationCallout
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore
import Alamofire

enum CalloutVerificationRouter {
    case initiateVerification(data: CalloutVerificationInitiationData)
    case verifyCode(number: String, data: CalloutVerificationData)
}

extension CalloutVerificationRouter: APIRouter {
    
    public var method: HTTPMethod {
        switch self {
        case .initiateVerification:
            return .post
        case .verifyCode:
            return .put
        }
    }
    
    public var path: String {
        switch self {
        case .initiateVerification:
            return "verifications"
        case .verifyCode(let number, _):
            return "verifications/number/\(number)"
        }
    }
    
    public var encoding: ParameterEncoding {
        switch self {
        case .initiateVerification, .verifyCode:
            return JSONEncoding.default
        }
    }
    
    public var parameters: Parameters {
        let encodableData: Encodable
        switch self {
        case .initiateVerification(let data):
            encodableData = data
        case .verifyCode(_, let calloutVerificationData):
            encodableData = calloutVerificationData
        }
        return encodableData.asDictionary
    }
    
    public var headers: HTTPHeaders {
        switch self {
        case .initiateVerification, .verifyCode:
            return [:]
        }
    }
    
}
