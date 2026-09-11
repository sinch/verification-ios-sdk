//
//  AppClipCallbackParser.swift
//  Verification
//
//  Created by Aleksander Wojcik on 11/08/2026.
//  Copyright © 2026 Sinch. All rights reserved.
//

import Foundation

/// Extracts the seamless (v2 / App Clip) verification result from the universal link callback URL
/// that the App Clip opens once verification with the mobile network operator completes.
class AppClipCallbackParser {

  private let callbackUrl: URL

  init(callbackUrl: URL) {
    self.callbackUrl = callbackUrl
  }

  /// - Parameter queryParameterName: name of the query parameter carrying the OpenID4VP CSP
  ///   response, as returned by the API in `appCallbackQueryParameterName`.
  /// - Returns: the opaque OpenID4VP CSP response string to send as report `OperatorToken`.
  ///   The SDK does not parse the envelope; the backend extracts `data.vp_token.aduna`.
  /// - Throws: `SDKError` if the callback URL reports an error, or is missing the expected data.
  func extractOperatorToken(queryParameterName: String) throws -> String {
    guard let queryItems = URLComponents(url: callbackUrl, resolvingAgainstBaseURL: false)?.queryItems else {
      throw SDKError.illegalArgument(message: "App Clip callback URL is missing query data")
    }

    func value(forQueryItemNamed name: String) -> String? {
      queryItems.first { $0.name == name }?.value
    }

    if let error = value(forQueryItemNamed: "error") {
      let errorDescription = value(forQueryItemNamed: "error_description") ?? error
      throw SDKError.apiCall(data: ApiErrorData(errorCode: nil, message: errorDescription, reference: nil))
    }

    guard let operatorToken = value(forQueryItemNamed: queryParameterName) else {
      throw SDKError.illegalArgument(
        message: "App Clip callback URL does not contain the expected '\(queryParameterName)' query parameter"
      )
    }

    return operatorToken
  }

}
