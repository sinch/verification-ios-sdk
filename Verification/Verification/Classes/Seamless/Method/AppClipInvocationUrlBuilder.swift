//
//  AppClipInvocationUrlBuilder.swift
//  Verification
//

import Foundation

/// Builds the carrier App Clip invocation URL from v2 seamless initiation details.
enum AppClipInvocationUrlBuilder {

    static func build(from details: SeamlessInitiationDetails) throws -> URL {
        guard let appClipUrl = details.iOSAppClipUrl,
              let appInfoJwt = details.appInfoJwt,
              let appInfoJwtQueryParameterName = details.appInfoJwtQueryParameterName,
              details.appCallbackQueryParameterName != nil,
              var components = URLComponents(string: appClipUrl) else {
            throw SDKError.unexpected(
                message: "v2 seamless verification response is missing required App Clip invocation data (iOSAppClipUrl, appInfoJwt, appInfoJwtQueryParameterName, appCallbackQueryParameterName)"
            )
        }

        var queryItems = components.queryItems ?? []
        if let existingIndex = queryItems.firstIndex(where: { $0.name == appInfoJwtQueryParameterName }) {
            queryItems[existingIndex] = URLQueryItem(name: appInfoJwtQueryParameterName, value: appInfoJwt)
        } else {
            queryItems.append(URLQueryItem(name: appInfoJwtQueryParameterName, value: appInfoJwt))
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            throw SDKError.unexpected(message: "v2 seamless verification response contains an invalid iOSAppClipUrl")
        }

        return url
    }

}
