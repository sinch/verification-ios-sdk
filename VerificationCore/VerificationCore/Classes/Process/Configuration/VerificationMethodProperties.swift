//
//  VerificationMethodProperties.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation

/// Base protocol for common properties of every verification method.
protocol VerificationMethodProperties {
    
    /// Number that needs be verified.
    var number: String { get }
    
    /// Custom string that is passed with the initiation request.
    var custom: String? { get }
    
    /// Custom string that can be added for verification tracking purposes.
    var reference: String? { get }
    
    /// Flag indicating if the verification process should honour early rejection rules.
    var honoursEarlyReject: Bool { get }

    /// List of languages the verification process can use during the verification process.
    var acceptedLanguages: [VerificationLanguage] { get }
}
