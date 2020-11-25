//
//  VerificationMethodConfigCreatorParameters.swift
//  Verification
//
//  Created by Aleksander Wojcik on 16/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Protocol defining verification method config builders optional parameteres that can be passed to every verification method.
public protocol VerificationMethodConfigCreatorParameters {
    
    /// Assigns honourEarlyReject flag to the builder.
    /// - Parameter honourEarlyReject: Flag indicating if the verification process should honour early rejection rules.
    /// - Returns: Instance of builder with assigned honourEarlyReject flag.
    func honourEarlyReject(_ honourEarlyReject: Bool) -> Self
    
    /// Assigns custom string to the builder.
    /// - Parameter custom: Custom string that is passed with the initiation request.
    /// - Returns: Instance of builder with assigned custom field.
    func custom(_ custom: String?) -> Self
    
    /// Assigns reference string to the builder.
    /// - Parameter reference: Reference string that is passed with the initiation request for tracking purposes.
    /// - Returns: Instance of builder with assigned reference field.
    func reference(_ reference: String?) -> Self
    
    /// Assigns acceptedLanguages value to the builder.
    /// - Parameter acceptedLanguages: List of languages the sms message with the verification code will be written in. Backend chooses the first one it can handle.
    /// - Returns: Instance of builder with assigned acceptedLanguages field.
    func acceptedLanguages(_ acceptedLanguages: [VerificationLanguage]) -> Self
    
}
