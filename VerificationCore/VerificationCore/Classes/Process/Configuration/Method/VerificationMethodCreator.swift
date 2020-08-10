//
//  VerificationMethodCreator.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 10/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//


///Interface defining requirements of builder that can create verification methods instances.
public protocol VerificationMethodCreator {
    
    func initiationListener(_ initiationListener: InitiationListener?) -> VerificationMethodCreator
    
    func verificationListener(_ verificationListener: VerificationListener?) -> VerificationMethodCreator
    
    func build() -> Verification
}
