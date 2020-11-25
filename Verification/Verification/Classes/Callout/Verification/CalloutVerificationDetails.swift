//
//  CalloutVerificationDetails.swift
//  Verification
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

/// Class containing detailed information for the actual verification API request for callout verification.
struct CalloutVerificationDetails: Codable {
    
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
    }
    
}
