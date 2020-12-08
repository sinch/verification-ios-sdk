//
//  AutoVerificationRouter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

enum AutoVerificationRouter {
    case initiateVerification(data: AutoVerificationInitiationData, preferedLanguages: [VerificationLanguage])
}

extension AutoVerificationRouter: APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .initiateVerification:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .initiateVerification:
            return "verifications"
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .initiateVerification:
            return JSONEncoding.default
        }
    }
    
    var parameters: Parameters {
        let encodableData: Encodable
        switch self {
        case .initiateVerification(let data, _):
            encodableData = data
        }
        return encodableData.asDictionary
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .initiateVerification(_, let preferableLanguages):
            return ["Accept-Language": preferableLanguages.asLanguageString ?? ""]
        }
    }
    
}
