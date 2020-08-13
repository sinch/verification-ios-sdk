//
//  InitiationResponseData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Interface defining common requirements for each verification method initiation response data.
public struct InitiationResponseData: Equatable, Codable {
    
    /// ID assigned to the verification.
    public let id: String
    
    /// Method of initiated verification.
    public let method: VerificationMethodType
    
    public let smsDetails: SmsInitiationDetails?
    
    public let seamlessDetails: SeamlessInitiationDetails?
    
    public let contentLanguage: VerificationLanguage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case method
        case smsDetails = "sms"
        case seamlessDetails = "seamless"
        case contentLanguage
    }
    
    func withContentLanguage(_ contentLanguage: VerificationLanguage?) -> InitiationResponseData {
        return InitiationResponseData(id: self.id, method: self.method, smsDetails: self.smsDetails, seamlessDetails: self.seamlessDetails, contentLanguage: contentLanguage)
    }

}
