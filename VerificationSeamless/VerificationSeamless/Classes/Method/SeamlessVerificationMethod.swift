//
//  SeamlessVerificationMethod.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore
import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses Seamlesss to verify user's phone number.
///
/// The code  spoken by text-to-speech must be manually typed by the user. Use [SeamlessVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: SeamlessVerificationMethod
public class SeamlessVerificationMethod: VerificationMethod<SeamlessInitiationResponseData> {
    
    private(set) public weak var initiationListener: SeamlessInitiationListener?
    
    private init(
        verificationMethodConfig: VerificationMethodConfiguration,
        initiationListener: SeamlessInitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        self.initiationListener = initiationListener
        super.init(verificationMethodConfig: verificationMethodConfig, verificationListener: verificationListener)
    }
    
    private var initiationData: SeamlessVerificationInitiationData {
        return SeamlessVerificationInitiationData(basedOnConfiguration: self.verificationMethodConfig)
    }
    
    public override func onInitiate() {
        self.service
            .request(SeamlessVerificationRouter.initiateVerification(data: initiationData))
            .sinchInitiationResponse(InitiationApiCallback<SeamlessInitiationResponseData>(
                    verificationStateListener: self,
                    resultCallback: { [weak self] (result: ApiResponse<SeamlessInitiationResponseData>) -> Void in
                        switch result {
                        case .success(let data, _):
                            self?.initiationListener?.onInitiated(data)
                            self?.verify(verificationCode: data.details.targetUri)
                        case .failure(let error):
                            self?.initiationListener?.onInitiationFailed(e: error)
                        }
                    }
                )
            )
    }
    
    public override func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) {
        self.service
            .request(SeamlessVerificationRouter.verify(targetUri: verificationCode))
            .sinchValidationResponse(VerificationApiCallback(listener: verificationListener, verificationStateListener: self))
    }
    
    /// Builder implementing fluent builder pattern to create [SeamlessVerificationMethod](x-source-tag://[SeamlessVerificationMethod]) objects.
    /// - TAG: SeamlessVerificationMethodBuilder
    public class Builder: SeamlessVerificationConfigSetter, SeamlessVerificationMethodCreator  {
        
        private var config: SeamlessVerificationConfig!
        
        private var initiationListener: SeamlessInitiationListener?
        private var verificationListener: VerificationListener?
        
        private init() { }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> SeamlessVerificationConfigSetter {
            return Builder()
        }
        
        /// Assigns config to the builder.
        /// - Parameter config: Reference to Seamless configuration object.
        /// - Returns: Instance of builder with assigned configuration.
        public func config(_ config: SeamlessVerificationConfig) -> SeamlessVerificationMethodCreator {
            return apply { $0.config = config }
        }
        
        /// Assigns initiation listener to the builder.
        /// - Parameter initiationListener: Listener to be notified about verification initiation result.
        /// - Returns: Instance of builder with assigned initiation listener.
        public func initiationListener(_ initiationListener: SeamlessInitiationListener?) -> SeamlessVerificationMethodCreator {
            return apply { $0.initiationListener = initiationListener }
        }
        
        /// Assigns verification listener to the builder.
        /// - Parameter verificationListener: Listener to be notified about the verification process result.
        /// - Returns: Instance of builder with assigned verification listener.
        public func verificationListener(_ verificationListener: VerificationListener?) -> SeamlessVerificationMethodCreator {
            return apply { $0.verificationListener = verificationListener }
        }
        
        /// Builds [SeamlessVerificationMethod](x-source-tag://[SeamlessVerificationMethod]) instance.
        /// - Returns: [Verification](x-source-tag://[Verification]) instance with previously defined parameters.
        public func build() -> Verification {
            return SeamlessVerificationMethod(
                verificationMethodConfig: self.config,
                initiationListener: initiationListener,
                verificationListener: verificationListener
            )
        }
        
    }
    
}

extension SeamlessVerificationMethod.Builder: HasApply {}
