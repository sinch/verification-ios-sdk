//
//  CalloutInitiationDetails.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

/// Class containing details (returned by the API) about the initiated callout verification process.
public struct CalloutInitiationDetails: Codable, Equatable, InitiationDetails {
    let subVerificationId: String?
}
