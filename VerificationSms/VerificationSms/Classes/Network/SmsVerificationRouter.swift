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
    case initiateVerification(data: SmsVerificationInitiationData, preferedLanguages: [VerificationLanguage])
    case verifyCode(number: String, data: SmsVerificationData)
}

extension SmsVerificationRouter: APIRouter {
    
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
        case .initiateVerification(let data, _):
            encodableData = data
        case .verifyCode(_, let smsVerificationData):
            encodableData = smsVerificationData
        }
        return encodableData.asDictionary
    }
    
    public var headers: HTTPHeaders {
        switch self {
        case .initiateVerification(_, let preferableLanguages):
            return ["Accept-Language": preferableLanguages.asLanguageString ?? ""]
        case .verifyCode:
            return [:]
        }
    }
    
}
