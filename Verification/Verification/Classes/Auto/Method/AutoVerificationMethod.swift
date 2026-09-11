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

    private let appClipOpening: AppClipOpening
    private let appClipWaitSession = AppClipWaitSession()
        
    init(
        verificationMethodConfig: AutoVerificationConfig,
        initiationListener: InitiationListener? = nil,
        verificationListener: VerificationListener? = nil,
        appClipOpening: AppClipOpening = UIApplicationAppClipOpening())
    {
        self.appClipOpening = appClipOpening
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
        if shouldHandleAppClipCallback(method: method) {
            verifyAppClipCallback(url: verificationCode)
            return
        }
        guard let method = method,
              let subVerificationId = self.initiationResponseData?.details(ofMethod: method)?.subVerificationId else {
            verificationListener?.onVerificationFailed(
                e: SDKError.illegalArgument(message: "Auto verification is missing a method or sub-verification id")
            )
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
        if seamlessData.isV2 {
            AppClipLauncher.open(
                details: seamlessData,
                using: appClipOpening,
                onSuccess: { [weak self] in
                    self?.appClipWaitSession.start { [weak self] outcome in
                        self?.handleSeamlessAppClipUnavailable(error: outcome.asSDKError)
                    }
                },
                onFailure: { [weak self] error in
                    self?.handleSeamlessAppClipUnavailable(error: error)
                }
            )
            return
        }
        self.service
            .request(SeamlessVerificationRouter.verify(targetUri: seamlessData.targetUri ?? ""))
            .sinchValidationResponse(VerificationApiCallback(listener: self, verificationStateListener: self))
    }

    private func shouldHandleAppClipCallback(method: VerificationMethodType?) -> Bool {
        guard initiationResponseData?.seamlessDetails?.isV2 == true else { return false }
        return method == nil || method == .seamless
    }

    private func handleSeamlessAppClipUnavailable(error: Error) {
        verificationListener?.onVerificationEvent(
            event: AutoVerificationEvent.subMethodFailedEvent(method: .seamless, e: error)
        )
    }

    private func verifyAppClipCallback(url callbackUrlString: String) {
        appClipWaitSession.cancel()
        guard let callbackUrl = URL(string: callbackUrlString) else {
            verificationListener?.onVerificationFailed(e: SDKError.illegalArgument(message: "App Clip callback is not a valid URL"))
            return
        }

        guard let queryParameterName = initiationResponseData?.seamlessDetails?.appCallbackQueryParameterName else {
            verificationListener?.onVerificationFailed(
                e: SDKError.unexpected(message: "v2 seamless verification response is missing appCallbackQueryParameterName")
            )
            return
        }

        guard let childId = initiationResponseData?.seamlessDetails?.subVerificationId, !childId.isEmpty else {
            verificationListener?.onVerificationFailed(
                e: SDKError.unexpected(message: "v2 auto seamless verification response is missing subVerificationId")
            )
            return
        }

        do {
            let operatorToken = try AppClipCallbackParser(callbackUrl: callbackUrl).extractOperatorToken(queryParameterName: queryParameterName)
            self.service
                .request(SeamlessVerificationRouter.verifyWithCredential(
                    data: SeamlessCallbackData(state: childId, operatorToken: operatorToken)
                ))
                .sinchValidationResponse(VerificationApiCallback(listener: self, verificationStateListener: self))
        } catch {
            verificationListener?.onVerificationFailed(e: error)
        }
    }

    override func onStop() {
        appClipWaitSession.cancel()
    }

    public override func onVerified() {
        appClipWaitSession.cancel()
        super.onVerified()
    }

    public override func onVerificationFailed(e: Error) {
        appClipWaitSession.cancel()
        super.onVerificationFailed(e: e)
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
