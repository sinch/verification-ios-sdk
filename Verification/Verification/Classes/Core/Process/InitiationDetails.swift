//
//  InitiationDetails.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

protocol InitiationDetails {
    
    /// Id assigned to each verification method that can be used in case of  auto verification.
    var subVerificationId: String? { get }
}
