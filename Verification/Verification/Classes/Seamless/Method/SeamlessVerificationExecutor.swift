//
//  NetworkSocket.swift
//  Verification
//
//  Created by Aleksander Wojcik on 10/02/2022.
//  Copyright © 2022 Sinch. All rights reserved.
//

import Foundation
import Network

protocol SeamlessVerificationExecutorDelegate: AnyObject {
  func onSuccess(data: String)
  func onError(error: Error)
}

internal class SeamlessVerificationExecutor {
  
  private static let RESPONSE_ERROR = "ERROR"
  private static let RESPONSE_REDIRECT = "REDIRECT:"
  private static let SAFE_ENCODED_SPACE = "%20"
  
  private let dispatchQueue = DispatchQueue.global(qos: .background)
  
  weak var delegate: SeamlessVerificationExecutorDelegate?
  
  func executeGetAtTargetUrl(targetUrl: String, headers: [String: String] = [:]) {
    dispatchQueue.async { [weak self] in
      self?.executeGetAtTargetUrl_wt(targetUrl: targetUrl, headers: headers)
    }
  }
  
  private func executeGetAtTargetUrl_wt(targetUrl: String, headers: [String: String]) {
    let response = requestHelper(url: targetUrl, headers: headers)
    
    // If any internal and network errors occured in HTTPRequester.performGetRequest, the function will return "ERROR"
    if response == SeamlessVerificationExecutor.RESPONSE_ERROR {
      onDelegateThread {
        delegate?.onError(error: SDKError.unexpected(message: "Error when executing HTTP requests"))
      }
    } else {
      // Final response after redirects received
      onDelegateThread {
        delegate?.onSuccess(data: response)
      }
    }
  }
  
  /**
   Recursive function that keeps requesting a new URL with cellular data when the HTTP request returns a HTTP redirect code (3xx)
   
   - Parameter url: The URL to be requested
   - Returns: string response from the HTTP request
   */
  private func requestHelper(url: String, headers: [String: String]) -> String {
    // If the HTTP GET request returns a HTTP redirect code (3xx), HTTPRequester.performGetRequest returns a
    // formatted string that contains the redirect URL. The formatted string starts with "REDIRECT:"
    // and it's followed with the redirect URL.
    let encodedUrl = url.replacingOccurrences(of: " ", with: SeamlessVerificationExecutor.SAFE_ENCODED_SPACE)
    guard let response = HTTPRequester.performGetRequest(
      URL(string: encodedUrl),
      headers: headers.isEmpty ? nil : headers
    ) else {
      return SeamlessVerificationExecutor.RESPONSE_ERROR
    }
    
    if response.range(of:SeamlessVerificationExecutor.RESPONSE_REDIRECT) != nil {
      // 1. Get the redirect URL by getting rid of the "REDIRECT:" substring
      let redirectRange = response.index(response.startIndex, offsetBy: SeamlessVerificationExecutor.RESPONSE_REDIRECT.count)...
      let redirectLink = String(response[redirectRange])
      // 2. Make a request to the redirect URL
      return requestHelper(url: redirectLink, headers: headers)
    }
    return response
  }
  
  private func onDelegateThread(_ f: ()->Void) {
    DispatchQueue.main.sync {
      f()
    }
  }
  
}
