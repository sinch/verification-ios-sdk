//
//  FlashcallInitiationListener.swift
//  VerificationFlashcall
//
//  Created by Aleksander Wojcik on 28/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

public protocol FlashcallInitiationListener: InitiationListener {
    func onInitiated(_ data: FlashcallInitiationResponseData)
}

public extension FlashcallInitiationListener {
    
    func onInitiated(_ data: FlashcallInitiationResponseData) { }
    func onInitiationFailed(e: Error) { }
    
}
