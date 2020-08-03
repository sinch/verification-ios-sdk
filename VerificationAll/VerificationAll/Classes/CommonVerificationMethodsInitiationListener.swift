//
//  CommonVerificationMethodsInitiationListener.swift
//  VerificationAll
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationSms
import VerificationFlashcall
import VerificationCore

/// Convinient initiation listener that can be used with [CommonVerificationInitializationParameters](x-source-tag://[CommonVerificationInitializationParameters]) to handle multiple initiation responses for different verification method types.
public protocol CommonVerificationMethodsInitiationListener: SmsInitiationListener, FlashcallInitiationListener {
    func onInitiated(_ data: InitiationResponseData)
}

extension CommonVerificationMethodsInitiationListener {
    
    public func onInitiated(_ data: SmsInitiationResponseData) {
        onInitiated(data as InitiationResponseData)
    }
    
    public func onInitiated(_ data: FlashcallInitiationResponseData) {
        onInitiated(data as InitiationResponseData)
    }
    
}
