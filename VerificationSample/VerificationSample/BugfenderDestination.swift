//
//  BugfenderDestination.swift
//  VerificationSample
//
//  Created by Aleksander Wójcik on 16/07/2026.
//  Copyright © 2026 Aleksander Wojcik. All rights reserved.
//

import Foundation
import SwiftyBeaver
import BugfenderSDK

/// SwiftyBeaver destination that forwards every log entry to Bugfender,
/// mapping SwiftyBeaver levels onto their `BFLogLevel` equivalents.
class BugfenderDestination: BaseDestination {

    override func send(_ level: SwiftyBeaver.Level, msg: String, thread: String, file: String, function: String, line: Int, context: Any? = nil) -> String? {

        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)

        Bugfender.log(
            lineNumber: line,
            method: function,
            file: file,
            level: bugfenderLevel(for: level),
            tag: nil,
            message: formattedString ?? msg
        )

        return formattedString
    }

    private func bugfenderLevel(for level: SwiftyBeaver.Level) -> BFLogLevel {
        switch level {
        case .verbose:
            return .trace
        case .debug:
            return .default
        case .info:
            return .info
        case .warning:
            return .warning
        case .error:
            return .error
        @unknown default:
            return .default
        }
    }
}
