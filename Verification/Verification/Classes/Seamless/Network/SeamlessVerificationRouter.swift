//
//  SeamlessVerificationRouter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

enum SeamlessVerificationRouter {
    case initiateVerification(data: SeamlessVerificationInitiationData)
    case verify(targetUri: String)
}

extension SeamlessVerificationRouter: APIRouter {
    
    var method: HTTPMethod {
        switch self {
        case .initiateVerification:
            return .post
        case .verify:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .initiateVerification:
            return "verifications"
        case .verify(let targetUri):
            return targetUri
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .initiateVerification:
            return JSONEncoding.default
        case .verify:
            return URLEncoding.default
        }
    }
    
    var parameters: Parameters {
        let encodableData: Encodable
        switch self {
        case .initiateVerification(let data):
            encodableData = data
        case .verify:
            return [:]
        }
        return encodableData.asDictionary
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .initiateVerification, .verify:
            return [:]
        }
    }
    
    var appendPathToBaseUrl: Bool {
        switch self {
        case .verify:
            return false
        default:
            return true
        }
    }
    
}
