//
//  SeamlessVerificationMethodCreator.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

///Interface defining requirements of builder that can create Seamless Verification Method instances.
public protocol SeamlessVerificationMethodCreator {
    
    func initiationListener(_ initiationListener: SeamlessInitiationListener?) -> SeamlessVerificationMethodCreator
    
    func verificationListener(_ verificationListener: VerificationListener?) -> SeamlessVerificationMethodCreator
    
    func build() -> Verification
}
