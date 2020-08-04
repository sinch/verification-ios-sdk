//
//  CalloutVerificationMethodCreator.swift
//  VerificationCallout
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

///Interface defining requirements of builder that can create Callout Verification Method instances.
public protocol CalloutVerificationMethodCreator {
    
    func initiationListener(_ initiationListener: CalloutInitiationListener?) -> CalloutVerificationMethodCreator
    
    func verificationListener(_ verificationListener: VerificationListener?) -> CalloutVerificationMethodCreator
    
    func build() -> Verification
}
