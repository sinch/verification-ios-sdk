//
//  SmsVerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses sms messages to verify user's phone number.
///
/// The code that is received must be manually typed by the user. Use [SmsVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: SmsVerificationMethod
public class SmsVerificationMethod: VerificationMethod {
        
    init(
        verificationMethodConfig: SmsVerificationConfig,
        initiationListener: InitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        super.init(verificationMethodConfig: verificationMethodConfig,
                   initiationListener: initiationListener,
                   verificationListener: verificationListener)
    }
    
    private var initiationData: SmsVerificationInitiationData {
        return SmsVerificationInitiationData(basedOnConfiguration: self.verificationMethodConfig)
    }
    
    public override func onInitiate() {
        self.service
            .request(SmsVerificationRouter.initiateVerification(data: initiationData, preferedLanguages: verificationMethodConfig.acceptedLanguages))
            .sinchInitiationResponse(InitiationApiCallback(
                verificationStateListener: self,
                initiationListener: self
            )
        )
    }
    
    public override func onVerify(_ verificationCode: String,
                                  fromSource sourceType: VerificationSourceType,
                                  usingMethod method: VerificationMethodType?) {
        self.service
            .request(SmsVerificationRouter.verifyCode(
                number: initiationData.identity.endpoint,
                        data: SmsVerificationData(smsDetails: SmsVerificationDetails(code: verificationCode), source: sourceType)))
            .sinchValidationResponse(VerificationApiCallback(listener: self, verificationStateListener: self))
    }
    
    /// Builder implementing fluent builder pattern to create [SmsVerificationMethod](x-source-tag://[SmsVerificationMethod]) objects.
    /// - TAG: SmsVerificationMethodBuilder
    public class Builder: BaseVerificationMethodBuilder, SmsVerificationConfigSetter  {
        
        private var config: SmsVerificationConfig!
        
        private override init() { }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> SmsVerificationConfigSetter {
            return Builder()
        }
        
        /// Assigns config to the builder.
        /// - Parameter config: Reference to SMS configuration object.
        /// - Returns: Instance of builder with assigned configuration.
        public func config(_ config: SmsVerificationConfig) -> VerificationMethodCreator {
            return apply { $0.config = config }
        }
        
        
        /// Builds [SmsVerificationMethod](x-source-tag://[SmsVerificationMethod]) instance.
        /// - Returns: [Verification](x-source-tag://[Verification]) instance with previously defined parameters.
        public override func build() -> Verification {
            return SmsVerificationMethod(
                verificationMethodConfig: self.config,
                initiationListener: initiationListener,
                verificationListener: verificationListener
            )
        }
        
    }
}
