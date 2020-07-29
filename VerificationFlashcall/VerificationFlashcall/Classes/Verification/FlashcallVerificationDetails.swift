//
//  FlashcallVerificationDetails.swift
//  VerificationFlashcall
//
//  Created by Aleksander Wojcik on 29/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

/// Class containing detailed information for the actual verification API request for flashcall verification.
struct FlashcallVerificationDetails: Codable {
    /// Full phone number of the incoming verification call.
    let cli: String
}
