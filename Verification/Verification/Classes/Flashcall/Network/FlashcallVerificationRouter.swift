//
//  FlashcallVerificationRouter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 29/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

enum FlashcallVerificationRouter {
    case initiateVerification(data: FlashcallVerificationInitiationData)
    case verifyCode(number: String, data: FlashcallVerificationData)
}

extension FlashcallVerificationRouter: APIRouter {
    
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
        case .initiateVerification(let data):
            encodableData = data
        case .verifyCode(_, let flashcallVerificationData):
            encodableData = flashcallVerificationData
        }
        return encodableData.asDictionary
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .initiateVerification, .verifyCode:
            return [:]
        }
    }
    
}
