//
//  AutoVerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses other methods to automatically verify user's phone number.
///
/// The code that is received must be manually typed by the user. Use [AutoVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: AutoVerificationMethod
public class AutoVerificationMethod: VerificationMethod {
        
    init(
        verificationMethodConfig: AutoVerificationConfig,
        initiationListener: InitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        super.init(verificationMethodConfig: verificationMethodConfig,
                   initiationListener: initiationListener,
                   verificationListener: verificationListener)
    }
    
    private var initiationData: AutoVerificationInitiationData {
        return AutoVerificationInitiationData(basedOnConfiguration: self.verificationMethodConfig)
    }
    
    public override func onInitiate() {
        self.service
            .request(AutoVerificationRouter.initiateVerification(data: initiationData, preferedLanguages: verificationMethodConfig.acceptedLanguages))
            .sinchInitiationResponse(InitiationApiCallback(
                verificationStateListener: self,
                initiationListener: self
            )
        )
    }
    
    public override func onInitiated(_ data: InitiationResponseData) {
        super.onInitiated(data)
        tryVerifySeamlessly()
    }
    
    public override func onVerify(_ verificationCode: String,
                                  fromSource sourceType: VerificationSourceType,
                                  usingMethod method: VerificationMethodType?) {
        guard let method = method,
              let subVerificationId = self.initiationResponseData?.details(ofMethod: method)?.subVerificationId else {
            //TODO -> error message?
            return
        }
        self.verificationListener?.onVerificationEvent(
            event: AutoVerificationEvent.subMethodVerificationCallEvent(method: method)
        )
        self.service
            .request(VerificationRouter.verifyById(
                        id: subVerificationId,
                        data: verificationData(withCode: verificationCode, forMethod: method, source: sourceType)
            ))
            .sinchValidationResponse(VerificationApiCallback(listener: self, verificationStateListener: self))
    }
    
    private func tryVerifySeamlessly() {
        guard let seamlessData = self.initiationResponseData?.seamlessDetails else { return }
        self.verificationListener?.onVerificationEvent(
            event: AutoVerificationEvent.subMethodVerificationCallEvent(method: .seamless)
        )
        self.service
            .request(SeamlessVerificationRouter.verify(targetUri: seamlessData.targetUri))
            .sinchValidationResponse(VerificationApiCallback(listener: self, verificationStateListener: self))
    }
    
    private func verificationData(withCode code: String,
                                  forMethod method: VerificationMethodType,
                                  source: VerificationSourceType) -> VerificationData {
        switch method {
        case .sms:
            return SmsVerificationData(smsDetails: SmsVerificationDetails(code: code), source: source)
        case .flashcall:
            return FlashcallVerificationData(flashcallDetails: FlashcallVerificationDetails(cli: code), source: source)
        case .callout:
            return CalloutVerificationData(calloutDetails: CalloutVerificationDetails(code: code), source: source)
        default:
            fatalError("Cannon construct verification data for method \(method)")
        }
    }
    
    /// Builder implementing fluent builder pattern to create [AutoVerificationMethod](x-source-tag://[AutoVerificationMethod]) objects.
    /// - TAG: AutoVerificationMethodBuilder
    public class Builder: BaseVerificationMethodBuilder, AutoVerificationConfigSetter  {
        
        private var config: AutoVerificationConfig!
        
        private override init() { }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> AutoVerificationConfigSetter {
            return Builder()
        }
        
        /// Assigns config to the builder.
        /// - Parameter config: Reference to Auto configuration object.
        /// - Returns: Instance of builder with assigned configuration.
        public func config(_ config: AutoVerificationConfig) -> VerificationMethodCreator {
            return apply { $0.config = config }
        }
        
        /// Builds [AutoVerificationMethod](x-source-tag://[AutoVerificationMethod]) instance.
        /// - Returns: [Verification](x-source-tag://[Verification]) instance with previously defined parameters.
        public override func build() -> Verification {
            return AutoVerificationMethod(
                verificationMethodConfig: self.config,
                initiationListener: initiationListener,
                verificationListener: verificationListener
            )
        }
        
    }
}
