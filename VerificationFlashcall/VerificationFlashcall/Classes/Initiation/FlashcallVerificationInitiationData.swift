//
//  FlashcallVerificationInitiationData.swift
//  VerificationFlashcall
//
//  Created by Aleksander Wojcik on 28/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation
import VerificationCore
import MetadataCollector

/// Class containing data that is passed with the flashcall verification initiation API call.
public struct FlashcallVerificationInitiationData: VerificationInitiationData, Encodable {
    
    public let method: VerificationMethodType = .flashcall
    
    public let identity: VerificationIdentity
    public let honourEarlyReject: Bool
    public let custom: String?
    public let reference: String?
    public let metadata: PhoneMetadata?
    
    public init(identity: VerificationIdentity, honourEarlyReject: Bool, custom: String?, reference: String?, metadata: PhoneMetadata?) {
        self.identity = identity
        self.honourEarlyReject = honourEarlyReject
        self.custom = custom
        self.reference = reference
        self.metadata = metadata
    }
    
}
