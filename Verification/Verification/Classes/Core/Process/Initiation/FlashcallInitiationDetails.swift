//
//  FlashcallInitiationDetails.swift
//  Verification
//
//  Created by Aleksander Wojcik on 14/09/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class containing details (returned by the API) about the initiated flashcall verification process.
public struct FlashcallInitiationDetails: Codable, Equatable {
    let interceptionTimeout: TimeInterval
}
