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
    
    public let flashcallDetails: FlashcallInitiationDetails?
    
    public let seamlessDetails: SeamlessInitiationDetails?
    
    public let contentLanguage: VerificationLanguage?
    
    let dateOfGeneration: Date?
    
    var interceptionTimeout: TimeInterval? {
        switch self.method {
        case .sms:
            return smsDetails?.interceptionTimeout
        case .flashcall:
            return flashcallDetails?.interceptionTimeout
        default:
            return nil
        }
    }
    
    var initiationDataTimeoutDate: Date? {
        guard let interceptionTimeout = interceptionTimeout else { return nil }
        return dateOfGeneration?.addingTimeInterval(interceptionTimeout)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case method
        case smsDetails = "sms"
        case seamlessDetails = "seamless"
        case flashcallDetails = "flashCall"
        case contentLanguage
        case dateOfGeneration
    }
    
    func withHeadersData(contentLanguage: VerificationLanguage?, dateOfGeneration: Date) -> InitiationResponseData {
        return InitiationResponseData(id: self.id, method: self.method, smsDetails: self.smsDetails,
                                      flashcallDetails: self.flashcallDetails, seamlessDetails: self.seamlessDetails, contentLanguage: contentLanguage, dateOfGeneration: dateOfGeneration)
    }

}
