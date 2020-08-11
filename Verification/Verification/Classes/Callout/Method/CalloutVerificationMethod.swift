//
//  CalloutVerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses callouts to verify user's phone number.
///
/// The code  spoken by text-to-speech must be manually typed by the user. Use [CalloutVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: CalloutVerificationMethod
public class CalloutVerificationMethod: VerificationMethod {
    
    private override init(
        verificationMethodConfig: VerificationMethodConfiguration,
        initiationListener: InitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        super.init(verificationMethodConfig: verificationMethodConfig,
                   initiationListener: initiationListener,
                   verificationListener: verificationListener)
    }
    
    private var initiationData: CalloutVerificationInitiationData {
        return CalloutVerificationInitiationData(basedOnConfiguration: self.verificationMethodConfig)
    }
    
    public override func onInitiate() {
        self.service
            .request(CalloutVerificationRouter.initiateVerification(data: initiationData))
            .sinchInitiationResponse(InitiationApiCallback(
                    verificationStateListener: self,
                    initiationListener: initiationListener
                )
            )
    }
    
    public override func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) {
        self.service
            .request(CalloutVerificationRouter.verifyCode(
                number: initiationData.identity.endpoint,
                data: CalloutVerificationData(details: CalloutVerificationDetails(), source: sourceType)))
            .sinchValidationResponse(VerificationApiCallback(listener: verificationListener, verificationStateListener: self))

    }
    
    /// Builder implementing fluent builder pattern to create [CalloutVerificationMethod](x-source-tag://[CalloutVerificationMethod]) objects.
    /// - TAG: CalloutVerificationMethodBuilder
    public class Builder: BaseVerificationMethodBuilder, CalloutVerificationConfigSetter {
        
        private var config: CalloutVerificationConfig!
        
        private override init() { }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> CalloutVerificationConfigSetter {
            return Builder()
        }
        
        /// Assigns config to the builder.
        /// - Parameter config: Reference to Callout configuration object.
        /// - Returns: Instance of builder with assigned configuration.
        public func config(_ config: CalloutVerificationConfig) -> VerificationMethodCreator {
            return apply { $0.config = config }
        }
        
        /// Builds [CalloutVerificationMethod](x-source-tag://[CalloutVerificationMethod]) instance.
        /// - Returns: [Verification](x-source-tag://[Verification]) instance with previously defined parameters.
        public override func build() -> Verification {
            return CalloutVerificationMethod(
                verificationMethodConfig: self.config,
                initiationListener: initiationListener,
                verificationListener: verificationListener
            )
        }
        
    }
    
}
