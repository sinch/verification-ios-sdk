//
//  SmsVerificationMethod.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore
import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses sms messages to verify user's phone number.
///
/// The code that is received must be manually typed by the user. Use [SmsVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: SmsVerificationMethod
public class SmsVerificationMethod: VerificationMethod<SmsInitiationResponseData> {
    
    private(set) public weak var initiationListener: SmsInitiationListener?
    
    private init(
        verificationMethodConfig: VerificationMethodConfiguration,
        initiationListener: SmsInitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        self.initiationListener = initiationListener
        super.init(verificationMethodConfig: verificationMethodConfig, verificationListener: verificationListener)
    }
    
    public override func onInitiate() { }
    
    /// Builder implementing fluent builder pattern to create [SmsVerificationMethod](x-source-tag://[SmsVerificationMethod]) objects.
    /// - TAG: SmsVerificationMethodBuilder
    public class Builder: SmsVerificationConfigSetter, SmsVerificationMethodCreator  {
        
        private var config: SmsVerificationConfig!
        
        private var initiationListener: SmsInitiationListener?
        private var verificationListener: VerificationListener?
                
        private init() { }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> SmsVerificationConfigSetter {
            return Builder()
        }
        
        /// Assigns config to the builder.
        /// - Parameter config: Reference to SMS configuration object.
        /// - Returns: Instance of builder with assigned configuration.
        public func config(_ config: SmsVerificationConfig) -> SmsVerificationMethodCreator {
            return apply { $0.config = config }
        }
        
        /// Assigns initiation listener to the builder.
        /// - Parameter initiationListener: Listener to be notified about verification initiation result.
        /// - Returns: Instance of builder with assigned initiation listener.
        public func initiationListener(_ initiationListener: SmsInitiationListener?) -> SmsVerificationMethodCreator {
            return apply { $0.initiationListener = initiationListener }
        }
        
        /// Assigns verification listener to the builder.
        /// - Parameter verificationListener: Listener to be notified about the verification process result.
        /// - Returns: Instance of builder with assigned verification listener.
        public func verificationListener(_ verificationListener: VerificationListener?) -> SmsVerificationMethodCreator {
            return apply { $0.verificationListener = verificationListener }
        }
        
        /// Builds [SmsVerificationMethod](x-source-tag://[SmsVerificationMethod]) instance.
        /// - Returns: [Verification](x-source-tag://[Verification]) instance with previously defined parameters.
        public func build() -> Verification {
            return SmsVerificationMethod(
                verificationMethodConfig: self.config,
                initiationListener: initiationListener,
                verificationListener: verificationListener
            )
        }
        
    }
}

extension SmsVerificationMethod.Builder: HasApply {}
