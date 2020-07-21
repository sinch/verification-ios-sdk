//
//  VerificationResponseData.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class holding data about the initiated verification.
public struct VerificationResponseData: Decodable {
    
    /// Id of the verification process.
    let id: String
    
    /// Source of the verification.
    let source: VerificationSourceType?
    
    /// Status of the verification.
    let status: VerificationStatus
    
    /// Method used for the verification.
    let method: VerificationMethodType
    
    /// Error message if the verification process has failed, was denied or aborted null otherwise. [See](https://developers.sinch.com/docs/verification-rest-verification-api#verification-request).
    let errorReason: String?
    
    /// Reference id that was passed (optionally) together with the verification request.
    let reference: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case source
        case status
        case method
        case errorReason = "reason"
        case reference
       }
}
