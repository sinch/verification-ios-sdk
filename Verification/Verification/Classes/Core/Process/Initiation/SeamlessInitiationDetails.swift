//
//  SeamlessInitiationDetails.swift
//  Verification
//
//  Created by Aleksander Wojcik on 07/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class containing details (returned by the API) about the initiated seamless verification process.
public struct SeamlessInitiationDetails: Codable, Equatable, InitiationDetails {
    
    let subVerificationId: String?

    /// URI address at which the client has to make a GET call.
    public let targetUri: String
}
