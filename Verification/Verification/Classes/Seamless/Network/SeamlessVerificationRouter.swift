//
//  SeamlessVerificationRouter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

/// Body of the authenticated v2 seamless report (`PUT .../seamless-callback/aduna-v2`).
///
/// `operatorToken` is encoded as the public JSON field `OperatorToken`. The value is the
/// opaque OpenID4VP CSP response string from the App Clip callback, not the raw Aduna
/// operator token extracted later by the backend.
struct SeamlessCallbackData: Encodable {
    let state: String
    let operatorToken: String

    enum CodingKeys: String, CodingKey {
        case state
        case operatorToken = "OperatorToken"
    }
}

enum SeamlessVerificationRouter {
    case initiateVerification(data: SeamlessVerificationInitiationData)
    case verify(targetUri: String)
    case verifyWithCredential(data: SeamlessCallbackData)
}

extension SeamlessVerificationRouter: APIRouter {

    var method: HTTPMethod {
        switch self {
        case .initiateVerification:
            return .post
        case .verify:
            return .get
        case .verifyWithCredential:
            return .put
        }
    }

    var path: String {
        switch self {
        case .initiateVerification:
            return "verifications"
        case .verify(let targetUri):
            return targetUri
        case .verifyWithCredential:
            return "verifications/seamless-callback/aduna-v2"
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .initiateVerification, .verifyWithCredential:
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
        case .verifyWithCredential(let data):
            encodableData = data
        case .verify:
            return [:]
        }
        return encodableData.asDictionary
    }

    var headers: HTTPHeaders {
        switch self {
        case .initiateVerification, .verify, .verifyWithCredential:
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
