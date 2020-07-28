//
//  FlashcallVerificationMethodCreator.swift
//  VerificationFlashcall
//
//  Created by Aleksander Wojcik on 29/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

///Interface defining requirements of builder that can create Flashcall Verification Method instances.
public protocol FlashcallVerificationMethodCreator {
    
    func initiationListener(_ initiationListener: FlashcallInitiationListener?) -> FlashcallVerificationMethodCreator
    
    func verificationListener(_ verificationListener: VerificationListener?) -> FlashcallVerificationMethodCreator
    
    func build() -> Verification
}
