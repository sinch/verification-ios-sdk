//
//  SmsRouter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire

enum SmsVerificationRouter {
    case initiateVerification(data: SmsVerificationInitiationData, preferedLanguages: [VerificationLanguage])
    case verifyCode(number: String, data: SmsVerificationData)
}

extension SmsVerificationRouter: APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .initiateVerification:
            return .post
        case .verifyCode:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .initiateVerification:
            return "verifications"
        case .verifyCode(let number, _):
            return "verifications/number/\(number)"
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .initiateVerification, .verifyCode:
            return JSONEncoding.default
        }
    }
    
    var parameters: Parameters {
        let encodableData: Encodable
        switch self {
        case .initiateVerification(let data, _):
            encodableData = data
        case .verifyCode(_, let smsVerificationData):
            encodableData = smsVerificationData
        }
        return encodableData.asDictionary
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .initiateVerification(_, let preferableLanguages):
            return ["Accept-Language": preferableLanguages.asLanguageString ?? ""]
        case .verifyCode:
            return [:]
        }
    }
    
}
