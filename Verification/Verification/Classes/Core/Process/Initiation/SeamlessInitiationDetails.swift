//
//  SeamlessInitiationDetails.swift
//  Verification
//
//  Created by Aleksander Wojcik on 07/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class containing details (returned by the API) about the initiated seamless verification process.
public struct SeamlessInitiationDetails: Codable, Equatable, InitiationDetails {

    let subVerificationId: String?

    /// URI address at which the client has to make a GET call. Present only for the legacy (v1) seamless flow.
    public let targetUri: String?

    /// App Clip URL that the SDK opens automatically for the v2 seamless flow.
    public let iOSAppClipUrl: String?

    /// JWT that must be appended to `iOSAppClipUrl` for the App Clip to receive the app's invocation info.
    public let appInfoJwt: String?

    /// Name of the query parameter under which `appInfoJwt` must be appended to `iOSAppClipUrl`.
    public let appInfoJwtQueryParameterName: String?

    /// Name of the query parameter under which the OpenID4VP CSP response is returned in the App Clip's universal link callback.
    public let appCallbackQueryParameterName: String?

    /// Version of the seamless flow returned by the API. `"v2"` denotes the App Clip based flow.
    let version: String?

    /// Flag indicating whether the API returned the v2 (App Clip) seamless flow.
    var isV2: Bool { version == "v2" }
}
