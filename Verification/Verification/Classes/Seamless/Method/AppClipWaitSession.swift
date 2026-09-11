//
//  AppClipWaitSession.swift
//  Verification
//

import Foundation
import UIKit

protocol AppClipDelayScheduling {
    func schedule(after interval: TimeInterval, execute: @escaping () -> Void) -> AppClipCancellable
}

protocol AppClipCancellable {
    func cancel()
}

extension DispatchWorkItem: AppClipCancellable {}

final class DispatchQueueAppClipDelayScheduler: AppClipDelayScheduling {

    private let queue: DispatchQueue

    init(queue: DispatchQueue = .main) {
        self.queue = queue
    }

    func schedule(after interval: TimeInterval, execute: @escaping () -> Void) -> AppClipCancellable {
        let work = DispatchWorkItem(block: execute)
        queue.asyncAfter(deadline: .now() + interval, execute: work)
        return work
    }

}

/// Waits for an App Clip callback after a successful open.
///
/// Hard-times out after `waitTimeout`. Treats a return to the foreground (after
/// the host resigned active for the App Clip) as a dismiss, with a short grace
/// so a universal-link callback that arrives on the same resume is not missed.
final class AppClipWaitSession {

    static let defaultWaitTimeout: TimeInterval = 120
    static let dismissGraceInterval: TimeInterval = 2

    enum Outcome {
        case timedOut
        case dismissed

        var asSDKError: SDKError {
            switch self {
            case .timedOut:
                return .timeoutException
            case .dismissed:
                return .appClipDismissed
            }
        }
    }

    private let notificationCenter: NotificationCenter
    private let scheduler: AppClipDelayScheduling
    private let waitTimeout: TimeInterval
    private let graceInterval: TimeInterval

    private var timeoutWork: AppClipCancellable?
    private var graceWork: AppClipCancellable?
    private var observerTokens: [NSObjectProtocol] = []
    private var didResignAfterOpen = false
    private var didFinish = true
    private var onOutcome: ((Outcome) -> Void)?

    init(
        waitTimeout: TimeInterval = AppClipWaitSession.defaultWaitTimeout,
        graceInterval: TimeInterval = AppClipWaitSession.dismissGraceInterval,
        notificationCenter: NotificationCenter = .default,
        scheduler: AppClipDelayScheduling = DispatchQueueAppClipDelayScheduler()
    ) {
        self.waitTimeout = waitTimeout
        self.graceInterval = graceInterval
        self.notificationCenter = notificationCenter
        self.scheduler = scheduler
    }

    func start(onOutcome: @escaping (Outcome) -> Void) {
        cancel()
        didFinish = false
        didResignAfterOpen = false
        self.onOutcome = onOutcome

        timeoutWork = scheduler.schedule(after: waitTimeout) { [weak self] in
            self?.finish(.timedOut)
        }

        let resignHandler: (Notification) -> Void = { [weak self] _ in
            self?.didResignAfterOpen = true
        }
        observerTokens.append(notificationCenter.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main,
            using: resignHandler
        ))
        observerTokens.append(notificationCenter.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main,
            using: resignHandler
        ))
        observerTokens.append(notificationCenter.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleDidBecomeActive()
        })
    }

    func cancel() {
        didFinish = true
        timeoutWork?.cancel()
        graceWork?.cancel()
        timeoutWork = nil
        graceWork = nil
        onOutcome = nil
        removeObservers()
        didResignAfterOpen = false
    }

    deinit {
        cancel()
    }

    private func handleDidBecomeActive() {
        guard !didFinish, didResignAfterOpen else { return }
        graceWork?.cancel()
        graceWork = scheduler.schedule(after: graceInterval) { [weak self] in
            self?.finish(.dismissed)
        }
    }

    private func finish(_ outcome: Outcome) {
        guard !didFinish else { return }
        didFinish = true
        timeoutWork?.cancel()
        graceWork?.cancel()
        timeoutWork = nil
        graceWork = nil
        removeObservers()
        let callback = onOutcome
        onOutcome = nil
        callback?(outcome)
    }

    private func removeObservers() {
        observerTokens.forEach { notificationCenter.removeObserver($0) }
        observerTokens.removeAll()
    }

}
