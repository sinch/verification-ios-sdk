//
//  InitiationResponseData.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Interface defining common requirements for each verification method initiation response data.
protocol InitiationResponseData {
    
    /// ID assigned to the verification.
    var id: String { get }
    
    /// Method of initiated verification.
    var method: VerificationMethodType { get }
}
