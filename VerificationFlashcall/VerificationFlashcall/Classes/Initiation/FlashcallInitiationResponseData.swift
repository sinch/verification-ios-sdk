//
//  FlashcallVerificationResponseData.swift
//  VerificationFlashcall
//
//  Created by Aleksander Wojcik on 28/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

/// Class containing data returned by the API in response to sms verification initiation request.
public struct FlashcallInitiationResponseData: InitiationResponseData, Decodable {
    
    /// Id of the verification.
    public let id: String
    
    /// Method of the verification. Always .flashcall
    public let method: VerificationMethodType = .flashcall

}
