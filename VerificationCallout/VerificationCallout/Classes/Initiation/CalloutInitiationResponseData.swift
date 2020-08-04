//
//  CalloutInitiationResponseData.swift
//  VerificationCallout
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

/// Class containing data returned by the API in response to callout verification initiation request.
public struct CalloutInitiationResponseData: InitiationResponseData, Decodable {
    
    /// Id of the verification.
    public let id: String
    
    /// Method of the verification. Always .flashcall
    public let method: VerificationMethodType = .callout

}
