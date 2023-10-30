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
  
  private let dispatchQueue = DispatchQueue.global(qos: .background)
  
  weak var delegate: SeamlessVerificationExecutorDelegate?
  
  func requestEvurlWithCellularData(evurl: String) {
    dispatchQueue.async { [weak self] in
      self?.requestEvurlWithCellularData_wt(evurl: evurl)
    }
  }
  
  private func requestEvurlWithCellularData_wt(evurl: String) {
    let response = requestHelper(url: evurl)
    
    // If any internal and network errors occured in HTTPRequester.performGetRequest, the function will return "ERROR"
    if response == "ERROR" {
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
  private func requestHelper(url: String) -> String {
    // If the HTTP GET request returns a HTTP redirect code (3xx), HTTPRequester.performGetRequest returns a
    // formatted string that contains the redirect URL. The formatted string starts with "REDIRECT:"
    // and it's followed with the redirect URL.
    print("Executing GET at \(url)")
    var response = HTTPRequester.performGetRequest(URL(string: url.replacingOccurrences(of: " ", with: "%20")))
    
    if response!.range(of:"REDIRECT:") != nil {
      // 1. Get the redirect URL by getting rid of the "REDIRECT:" substring
      let redirectRange = response!.index(response!.startIndex, offsetBy: 9)...
      let redirectLink = String(response![redirectRange])
      // 2. Make a request to the redirect URL
      response = requestHelper(url: redirectLink)
    }
    
    return response!
  }
  
  private func onDelegateThread(_ f: ()->Void) {
    DispatchQueue.main.sync {
      f()
    }
  }
  
}
