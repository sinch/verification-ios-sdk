//
//  BaseVerificationMethodBuilder.swift
//  Verification
//
//  Created by Aleksander Wojcik on 10/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

public class BaseVerificationMethodBuilder: VerificationMethodCreator {
    
    internal var initiationListener: InitiationListener?
    internal var verificationListener: VerificationListener?
    
    init() {}
    
    /// Assigns initiation listener to the builder.
    /// - Parameter initiationListener: Listener to be notified about verification initiation result.
    /// - Returns: Instance of builder with assigned initiation listener.
    public func initiationListener(_ initiationListener: InitiationListener?) -> VerificationMethodCreator {
        return apply { $0.initiationListener = initiationListener }
    }
    
    /// Assigns verification listener to the builder.
    /// - Parameter verificationListener: Listener to be notified about the verification process result.
    /// - Returns: Instance of builder with assigned verification listener.
    public func verificationListener(_ verificationListener: VerificationListener?) -> VerificationMethodCreator {
        return apply { $0.verificationListener = verificationListener }
    }
    
    public func build() -> Verification {
        fatalError("Specific builder should override this function and return verification instance")
    }
    
}

extension BaseVerificationMethodBuilder: HasApply {}
