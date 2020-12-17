//
//  FlashcallVerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 29/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses flashcalls to verify user's phone number.
///
/// The incoming phone number must be manually typed by the user. Use [FlashcallVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: FlashcallVerificationMethod
public class FlashcallVerificationMethod: VerificationMethod {
        
    override init(
        verificationMethodConfig: VerificationMethodConfiguration,
        initiationListener: InitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        super.init(verificationMethodConfig: verificationMethodConfig,
                   initiationListener: initiationListener,
                   verificationListener: verificationListener)
    }
    
    private var initiationData: FlashcallVerificationInitiationData {
        return FlashcallVerificationInitiationData(basedOnConfiguration: self.verificationMethodConfig)
    }
    
    override func onInitiate() {
        self.service
            .request(FlashcallVerificationRouter.initiateVerification(data: initiationData))
            .sinchInitiationResponse(InitiationApiCallback(
                    verificationStateListener: self,
                    initiationListener: self
                )
            )
    }
    
    override func onVerify(_ verificationCode: String,
                           fromSource sourceType: VerificationSourceType,
                           usingMethod method: VerificationMethodType?) {
        self.service
            .request(FlashcallVerificationRouter.verifyCode(
                number: initiationData.identity.endpoint,
                        data: FlashcallVerificationData(flashcallDetails: FlashcallVerificationDetails(cli: verificationCode), source: sourceType)))
            .sinchValidationResponse(VerificationApiCallback(listener: self, verificationStateListener: self))

    }
    
    /// Builder implementing fluent builder pattern to create [FlashcallVerificationMethod](x-source-tag://[FlashcallVerificationMethod]) objects.
    /// - TAG: FlashcallVerificationMethodBuilder
    public class Builder: BaseVerificationMethodBuilder, FlashcallVerificationConfigSetter {
        
        private var config: FlashcallVerificationConfig!
        
        private override init() { }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> FlashcallVerificationConfigSetter {
            return Builder()
        }
        
        /// Assigns config to the builder.
        /// - Parameter config: Reference to Flashcall configuration object.
        /// - Returns: Instance of builder with assigned configuration.
        public func config(_ config: FlashcallVerificationConfig) -> VerificationMethodCreator {
            return apply { $0.config = config }
        }
        
        /// Builds [FlashcallVerificationMethod](x-source-tag://[FlashcallVerificationMethod]) instance.
        /// - Returns: [Verification](x-source-tag://[Verification]) instance with previously defined parameters.
        public override func build() -> Verification {
            return FlashcallVerificationMethod(
                verificationMethodConfig: self.config,
                initiationListener: initiationListener,
                verificationListener: verificationListener
            )
        }
        
    }
    
}
