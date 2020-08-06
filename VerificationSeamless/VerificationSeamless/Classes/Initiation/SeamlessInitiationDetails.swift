//
//  SeamlessInitiationDetails.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class containing details (returned by the API) about the initiated seamless verification process.
public struct SeamlessInitiationDetails: Decodable {
    
    /// URI address at which the client has to make a GET call.
    let targetUri: String
}

