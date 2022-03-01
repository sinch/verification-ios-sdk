//
//  SeamlessVerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Alamofire
import Combine

/// [Verification](x-source-tag://[Verification]) that uses Seamlesss to verify user's phone number.
///
/// The code  spoken by text-to-speech must be manually typed by the user. Use [SeamlessVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: SeamlessVerificationMethod
public class SeamlessVerificationMethod: VerificationMethod {
  
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
//              self.service
//                  .request(SeamlessVerificationRouter.verify(targetUri: verificationCode))
//                  .sinchValidationResponse(VerificationApiCallback(listener: self, verificationStateListener: self))

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
  
  fileprivate func extractRedirectLocation(rawResponse: String) -> String? {
    let locationHeaderName = "Location:"
    
    let headers = rawResponse.components(separatedBy: "\n")
    let locationHeader = headers.first { item in
      item.starts(with: locationHeaderName)
    }
    
    if let locationHeader = locationHeader {
      guard let range = locationHeader.range(of: locationHeaderName) else { return nil }
      return locationHeader[range.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
    } else {
      return nil
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
    let rawStringResponse = String(decoding: data, as: UTF8.self)
    print("RAW RESPONSE START")
    print(rawStringResponse)
    print("RAW RESPONSE END")
    if let redirectUrl = extractRedirectLocation(rawResponse: rawStringResponse) {
      executeSeamlessVerificationCall(targetURI: redirectUrl)
    } else {
      let responseHandler = HttpRawResponseHandler(rawStringResponse)
      print("Error or success!!! code: \(responseHandler.responseCode)")
    }

  }
  
  func onError(error: Error) {
    print("Delegate returned error: \(error)")
    verificationListener?.onVerificationFailed(e: error)
  }
  
  
}
