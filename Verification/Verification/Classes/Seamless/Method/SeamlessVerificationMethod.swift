//
//  SeamlessVerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses Seamlesss to verify user's phone number.
///
/// The code  spoken by text-to-speech must be manually typed by the user. Use [SeamlessVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: SeamlessVerificationMethod
public class SeamlessVerificationMethod: VerificationMethod {
        
    private override init(
        verificationMethodConfig: VerificationMethodConfiguration,
        initiationListener: InitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        super.init(verificationMethodConfig: verificationMethodConfig,
                   initiationListener: initiationListener,
                   verificationListener: verificationListener)
    }
    
    private var initiationData: SeamlessVerificationInitiationData {
        return SeamlessVerificationInitiationData(basedOnConfiguration: self.verificationMethodConfig)
    }
    
    override func onInitiate() {
        self.service
            .request(SeamlessVerificationRouter.initiateVerification(data: initiationData))
            .sinchInitiationResponse(InitiationApiCallback(
                    verificationStateListener: self,
                    initiationListener: self
                )
            )
    }
    
    override func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) {
        self.service
            .request(SeamlessVerificationRouter.verify(targetUri: verificationCode))
            .sinchValidationResponse(VerificationApiCallback(listener: verificationListener, verificationStateListener: self))
    }
    
    /// Builder implementing fluent builder pattern to create [SeamlessVerificationMethod](x-source-tag://[SeamlessVerificationMethod]) objects.
    /// - TAG: SeamlessVerificationMethodBuilder
    public class Builder: BaseVerificationMethodBuilder, SeamlessVerificationConfigSetter {
        
        private var config: SeamlessVerificationConfig!
        
        private override init() { }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> SeamlessVerificationConfigSetter {
            return Builder()
        }
        
        /// Assigns config to the builder.
        /// - Parameter config: Reference to Seamless configuration object.
        /// - Returns: Instance of builder with assigned configuration.
        public func config(_ config: SeamlessVerificationConfig) -> VerificationMethodCreator {
            return apply { $0.config = config }
        }
        
        /// Builds [SeamlessVerificationMethod](x-source-tag://[SeamlessVerificationMethod]) instance.
        /// - Returns: [Verification](x-source-tag://[Verification]) instance with previously defined parameters.
        public override func build() -> Verification {
            return SeamlessVerificationMethod(
                verificationMethodConfig: self.config,
                initiationListener: initiationListener,
                verificationListener: verificationListener
            )
        }
        
    }
    
}

extension SeamlessVerificationMethod: InitiationListener {
    
    public func onInitiated(_ data: InitiationResponseData) {
        initiationListener?.onInitiated(data)
        verify(verificationCode: data.seamlessDetails?.targetUri ?? "")
    }
    
    public func onInitiationFailed(e: Error) {
        initiationListener?.onInitiationFailed(e: e)
    }
}
