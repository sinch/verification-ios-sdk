//
//  AppClipOpening.swift
//  Verification
//

import UIKit

/// Seam for opening the carrier App Clip invocation URL.
protocol AppClipOpening {
    func open(_ url: URL, completion: @escaping (Bool) -> Void)
}

/// Production adapter that opens URLs through `UIApplication`.
final class UIApplicationAppClipOpening: AppClipOpening {

    func open(_ url: URL, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }

}

enum AppClipLauncher {

    static func open(
        details: SeamlessInitiationDetails,
        using opener: AppClipOpening,
        onSuccess: @escaping () -> Void = {},
        onFailure: @escaping (Error) -> Void
    ) {
        do {
            let url = try AppClipInvocationUrlBuilder.build(from: details)
            log.debug("openAppClip invoked with url: \(url.absoluteString)")
            opener.open(url) { success in
                if success {
                    log.debug("openAppClip: system accepted the URL \(url.absoluteString)")
                    onSuccess()
                } else {
                    log.warning("openAppClip: system refused to open the URL \(url.absoluteString)")
                    onFailure(SDKError.unexpected(message: "System refused to open the App Clip URL"))
                }
            }
        } catch {
            onFailure(error)
        }
    }

}
