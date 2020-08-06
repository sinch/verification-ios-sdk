//
//  FlashcallVerificationMethod.swift
//  VerificationFlashcall
//
//  Created by Aleksander Wojcik on 29/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore
import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses flashcalls to verify user's phone number.
///
/// The incoming phone number must be manually typed by the user. Use [FlashcallVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: FlashcallVerificationMethod
public class FlashcallVerificationMethod: VerificationMethod<FlashcallInitiationResponseData> {
    
    private(set) public weak var initiationListener: FlashcallInitiationListener?
    
    private init(
        verificationMethodConfig: VerificationMethodConfiguration,
        initiationListener: FlashcallInitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        self.initiationListener = initiationListener
        super.init(verificationMethodConfig: verificationMethodConfig, verificationListener: verificationListener)
    }
    
    private var initiationData: FlashcallVerificationInitiationData {
        return FlashcallVerificationInitiationData(basedOnConfiguration: self.verificationMethodConfig)
    }
    
    public override func onInitiate() {
        self.service
            .request(FlashcallVerificationRouter.initiateVerification(data: initiationData))
            .sinchResponse { [weak self] (result: ApiResponse<FlashcallInitiationResponseData>) -> Void in
                switch result {
                case .success(let data, _):
                    self?.initiationListener?.onInitiated(data)
                case .failure(let error):
                    self?.initiationListener?.onInitiationFailed(e: error)
                }
        }
    }
    
    public override func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) {
        self.service
            .request(FlashcallVerificationRouter.verifyCode(
                number: initiationData.identity.endpoint,
                data: FlashcallVerificationData(details: FlashcallVerificationDetails(cli: verificationCode), source: sourceType)))
            .sinchValidationResponse(VerificationApiCallback(listener: verificationListener, verificationStateListener: self))

    }
    
    /// Builder implementing fluent builder pattern to create [FlashcallVerificationMethod](x-source-tag://[FlashcallVerificationMethod]) objects.
    /// - TAG: FlashcallVerificationMethodBuilder
    public class Builder: FlashcallVerificationConfigSetter, FlashcallVerificationMethodCreator  {
        
        private var config: FlashcallVerificationConfig!
        
        private var initiationListener: FlashcallInitiationListener?
        private var verificationListener: VerificationListener?
        
        private init() { }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> FlashcallVerificationConfigSetter {
            return Builder()
        }
        
        /// Assigns config to the builder.
        /// - Parameter config: Reference to Flashcall configuration object.
        /// - Returns: Instance of builder with assigned configuration.
        public func config(_ config: FlashcallVerificationConfig) -> FlashcallVerificationMethodCreator {
            return apply { $0.config = config }
        }
        
        /// Assigns initiation listener to the builder.
        /// - Parameter initiationListener: Listener to be notified about verification initiation result.
        /// - Returns: Instance of builder with assigned initiation listener.
        public func initiationListener(_ initiationListener: FlashcallInitiationListener?) -> FlashcallVerificationMethodCreator {
            return apply { $0.initiationListener = initiationListener }
        }
        
        /// Assigns verification listener to the builder.
        /// - Parameter verificationListener: Listener to be notified about the verification process result.
        /// - Returns: Instance of builder with assigned verification listener.
        public func verificationListener(_ verificationListener: VerificationListener?) -> FlashcallVerificationMethodCreator {
            return apply { $0.verificationListener = verificationListener }
        }
        
        /// Builds [FlashcallVerificationMethod](x-source-tag://[FlashcallVerificationMethod]) instance.
        /// - Returns: [Verification](x-source-tag://[Verification]) instance with previously defined parameters.
        public func build() -> Verification {
            return FlashcallVerificationMethod(
                verificationMethodConfig: self.config,
                initiationListener: initiationListener,
                verificationListener: verificationListener
            )
        }
        
    }
    
}

extension FlashcallVerificationMethod.Builder: HasApply {}
