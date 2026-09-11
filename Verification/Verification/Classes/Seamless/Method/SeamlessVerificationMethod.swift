//
//  SeamlessVerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire
import Foundation

/// [Verification](x-source-tag://[Verification]) that uses Seamlesss to verify user's phone number.
///
/// The code  spoken by text-to-speech must be manually typed by the user. Use [SeamlessVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: SeamlessVerificationMethod
public class SeamlessVerificationMethod: VerificationMethod {
  
  static let EXTRA_CHECK_SUCCESSFUL_KEY = "SUCCESSFUL"
  
  private let seamlessExecutor: SeamlessVerificationExecutor = SeamlessVerificationExecutor()
  private let appClipOpening: AppClipOpening
  private let appClipWaitSession = AppClipWaitSession()
  
  override init(
    verificationMethodConfig: VerificationMethodConfiguration,
    initiationListener: InitiationListener? = nil,
    verificationListener: VerificationListener? = nil)
  {
    self.appClipOpening = UIApplicationAppClipOpening()
    super.init(verificationMethodConfig: verificationMethodConfig,
               initiationListener: initiationListener,
               verificationListener: verificationListener)
    seamlessExecutor.delegate = self
  }

  init(
    verificationMethodConfig: VerificationMethodConfiguration,
    initiationListener: InitiationListener? = nil,
    verificationListener: VerificationListener? = nil,
    appClipOpening: AppClipOpening)
  {
    self.appClipOpening = appClipOpening
    super.init(verificationMethodConfig: verificationMethodConfig,
               initiationListener: initiationListener,
               verificationListener: verificationListener)
    seamlessExecutor.delegate = self
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
  
  override func onVerify(_ verificationCode: String,
                         fromSource sourceType: VerificationSourceType,
                         usingMethod method: VerificationMethodType?) {
    if initiationResponseData?.seamlessDetails?.isV2 == true {
      // v2 (App Clip) flow: verificationCode is the universal link callback URL opened by the App Clip.
      verifyAppClipCallback(url: verificationCode)
    } else {
      executeSeamlessVerificationCall(targetURI: verificationCode)
    }
  }

  private func verifyAppClipCallback(url callbackUrlString: String) {
    appClipWaitSession.cancel()
    guard let callbackUrl = URL(string: callbackUrlString) else {
      verificationListener?.onVerificationFailed(e: SDKError.illegalArgument(message: "App Clip callback is not a valid URL"))
      return
    }

    // Presence of appCallbackQueryParameterName is validated upfront in openAppClip.
    guard let queryParameterName = initiationResponseData?.seamlessDetails?.appCallbackQueryParameterName else {
      verificationListener?.onVerificationFailed(
        e: SDKError.unexpected(message: "v2 seamless verification response is missing appCallbackQueryParameterName")
      )
      return
    }

    do {
      let operatorToken = try AppClipCallbackParser(callbackUrl: callbackUrl).extractOperatorToken(queryParameterName: queryParameterName)
      self.service
        .request(SeamlessVerificationRouter.verifyWithCredential(
          data: SeamlessCallbackData(state: id ?? "", operatorToken: operatorToken)
        ))
        .sinchValidationResponse(VerificationApiCallback(listener: self, verificationStateListener: self))
    } catch {
      verificationListener?.onVerificationFailed(e: error)
    }
  }

  private func executeSeamlessVerificationCall(targetURI: String) {
    seamlessExecutor.executeGetAtTargetUrl(targetUrl: targetURI)
  }

  private func openAppClip(_ seamlessDetails: SeamlessInitiationDetails?) {
    guard let seamlessDetails else {
      verificationListener?.onVerificationFailed(
        e: SDKError.unexpected(message: "v2 seamless verification response is missing required App Clip invocation data (iOSAppClipUrl, appInfoJwt, appInfoJwtQueryParameterName, appCallbackQueryParameterName)")
      )
      return
    }
    AppClipLauncher.open(
      details: seamlessDetails,
      using: appClipOpening,
      onSuccess: { [weak self] in
        self?.startAppClipWaitSession()
      },
      onFailure: { [weak self] error in
        self?.verificationListener?.onVerificationFailed(e: error)
      }
    )
  }

  private func startAppClipWaitSession() {
    appClipWaitSession.start { [weak self] outcome in
      guard let self else { return }
      self.update(newState: .verification(status: .error))
      self.verificationListener?.onVerificationFailed(e: outcome.asSDKError)
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
  
  public override func onInitiated(_ data: InitiationResponseData) {
    super.onInitiated(data)
    if data.seamlessDetails?.isV2 == true {
      // v2 (App Clip) flow: open the App Clip and wait for the app to supply the operator token via verify(_:).
      openAppClip(data.seamlessDetails)
    } else {
      // v1 (cellular redirect) flow: auto-verify against the returned targetUri.
      verify(verificationCode: data.seamlessDetails?.targetUri ?? "")
    }
  }
  
}

extension SeamlessVerificationMethod: SeamlessVerificationExecutorDelegate {
  
  func onSuccess(data: String) {
    let rawStringResponse = data
    let responseHandler = HttpRawResponseHandler(rawStringResponse)
    guard let receivedCode = responseHandler.responseCode else {
      verificationListener?.onVerificationFailed(e: SDKError.unexpected(message: "HTTP response code could not been parsed"))
      return
    }
    switch receivedCode {
    case 200..<300:
      if rawStringResponse.contains(SeamlessVerificationMethod.EXTRA_CHECK_SUCCESSFUL_KEY) {
        verificationListener?.onVerified()
      } else {
        verificationListener?.onVerificationFailed(e: SDKError.unexpected(message: "Seamless verification provider returned 200 but response body did not contain proper data."))
      }
      break
    case 400:
      // Verification failure
      verificationListener?.onVerificationFailed(e: SDKError.apiCall(data: ApiErrorData(errorCode: nil, message: "Seamless verification failed to verify the number.", reference: nil)))
      break
    default:
      // Other error
      verificationListener?.onVerificationFailed(e: SDKError.unexpected(message: "Seamless verification error during the verification process."))
    }
  }
  
  func onError(error: Error) {
    verificationListener?.onVerificationFailed(e: error)
  }
  
}
