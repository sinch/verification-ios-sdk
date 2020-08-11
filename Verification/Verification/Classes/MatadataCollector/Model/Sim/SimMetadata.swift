//
//  OperatorInfo.swift
//  Verification
//
//  Created by Aleksander Wojcik on 23/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Class holding metadata about network operator the sim card is assigned to.
struct SimMetadata: Encodable {
    
    /// ISO country code of sim card operator.
    let countryId: String?
    
    /// Name of the operator.
    let name: String?
    
    /// Mobile Network Code - See [wikipedia](https://en.wikipedia.org/wiki/Mobile_country_code)
    let mnc: String?
    
    /// Mobile Country Code - See [wikipedia](https://en.wikipedia.org/wiki/Mobile_country_code)
    let mcc: String?
}
