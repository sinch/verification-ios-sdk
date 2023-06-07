//
//  SeamlessVerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire
import Combine
import Foundation
import SwiftyBeaver

/// [Verification](x-source-tag://[Verification]) that uses Seamlesss to verify user's phone number.
///
/// The code  spoken by text-to-speech must be manually typed by the user. Use [SeamlessVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: SeamlessVerificationMethod
public class SeamlessVerificationMethod: VerificationMethod {
  
  static let EXTRA_CHECK_SUCCESSFUL_KEY = "SUCCESSFUL"
  
  private var seamlessExecutor: SeamlessVerificationExecutor?
        
    override init(
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
    
    override func onVerify(_ verificationCode: String,
                           fromSource sourceType: VerificationSourceType,
                           usingMethod method: VerificationMethodType?) {
      executeSeamlessVerificationCall(targetURI: verificationCode)

    }
  
  private func executeSeamlessVerificationCall(targetURI: String) {
    guard let urlComponents = URLComponents(string: targetURI) else {
      return
    }
    seamlessExecutor = SeamlessVerificationExecutor(endpoint: urlComponents)
    seamlessExecutor?.delegate = self
    do {
      try seamlessExecutor?.connect()
    } catch {
      deinitExecutor()
      print("Error while trying to connect to executor \(error)")
    }
  }
  
  private func deinitExecutor() {
    self.seamlessExecutor = nil
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
        verify(verificationCode: data.seamlessDetails?.targetUri ?? "")
    }
    
}

extension SeamlessVerificationMethod: SeamlessVerificationExecutorDelegate {
  
  func onResponseReceived(data: Data) {
    deinitExecutor()
    let rawStringResponse = String(decoding: data, as: UTF8.self)
    log.debug("RAW targetUrl response: \(rawStringResponse)")
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
        verificationListener?.onVerificationFailed(e: SDKError.unexpected(message: "Seamless verification provider returned 200 but response body did not contain proper data"))
      }
      break
    case 300..<400:
      guard let redirectUrl = responseHandler.locationHeader else {
        verificationListener?.onVerificationFailed(e: SDKError.unexpected(message: "300 Response message did not contain Location header"))
        return
      }
      executeSeamlessVerificationCall(targetURI: redirectUrl)
      break
    default:
      //Other error
      verificationListener?.onVerificationFailed(e: SDKError.unexpected(message: "Seamless verification error while executing http request"))
    }
  }
  
  func onError(error: Error) {
    deinitExecutor()
    verificationListener?.onVerificationFailed(e: error)
  }
  
}
