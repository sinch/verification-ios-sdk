//
//  SceneDelegate.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 07/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import UIKit
import SwiftyBeaver

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let log = SwiftyBeaver.self

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        // App launched cold from a universal link (associated domain).
        if let userActivity = connectionOptions.userActivities.first(where: {
            $0.activityType == NSUserActivityTypeBrowsingWeb
        }) {
            handleUniversalLink(userActivity)
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // App already running (foreground or background) when a universal link is opened.
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else { return }
        handleUniversalLink(userActivity)
    }

    private func handleUniversalLink(_ userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL else {
            log.warning("Universal link received without a webpageURL: \(userActivity.activityType)")
            return
        }
        log.info("Universal link opened for associated domain: \(url.absoluteString)")
        showLinkAlert(for: url)

        guard let verificationController = window?.rootViewController as? VerificationController else {
            log.warning("Universal link received but root view controller is not a VerificationController")
            return
        }
        verificationController.handleUniversalLinkCallback(url)
    }

    private func showLinkAlert(for url: URL) {
        let alert = UIAlertController(
            title: "Associated Domain Opened",
            message: "Host: \(url.host ?? "unknown")\n\nURL: \(url.absoluteString)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        // Present from the top-most view controller so it works regardless of what's on screen.
        guard var top = window?.rootViewController else { return }
        while let presented = top.presentedViewController {
            top = presented
        }
        top.present(alert, animated: true)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

