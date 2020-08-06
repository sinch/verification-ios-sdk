//
//  SeamlessInitiationResponseData.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

/// Class containing data returned by the API in response to seamless verification initiation request.
public struct SeamlessInitiationResponseData: InitiationResponseData, Decodable {
    
    /// Id of the verification.
    public let id: String
    
    /// Method of the verification. Always .flashcall
    public let method: VerificationMethodType = .seamless
    
    public let details: SeamlessInitiationDetails
    
    enum CodingKeys: String, CodingKey {
        case id
        case method
        case details = "seamless"
    }

}
