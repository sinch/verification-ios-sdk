//
//  SmsRouter.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore
import Alamofire

public enum SmsVerificationRouter {
    case initiateVerification(data: SmsVerificationInitiationData)
}

extension SmsVerificationRouter: APIRouter {
    
    public var method: HTTPMethod {
        switch self {
        case .initiateVerification:
            return .post
        }
    }
    
    public var path: String {
        switch self {
        case .initiateVerification:
            return "verifications"
        }
    }
    
    public var encoding: ParameterEncoding {
        switch self {
        case .initiateVerification:
            return JSONEncoding.default
        }
    }
    
    public var parameters: Parameters {
        switch self {
        case .initiateVerification(let data):
            return data.asDictionary
        }
    }
    
    public var headers: HTTPHeaders {
        switch self {
        case .initiateVerification:
            return [:]
        }
    }
    
}
