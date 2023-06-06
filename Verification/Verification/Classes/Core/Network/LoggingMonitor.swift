//
//  LoggingMonitor.swift
//  Verification
//
//  Created by Aleksander Wojcik on 16/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire
import Foundation

/// Monitor that logs each Alamofire request and response to standard output.
final class LoggingMonitor: EventMonitor {
    
    func requestDidResume(_ request: Request) {
        debugPrint("Request started: \(request)")
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "No body"
        let allHeaders = request.request.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? "None"
        debugPrint("Headers headers: \(allHeaders)")
        debugPrint("Body data: \(body)")
    }
    
    func request(_ request: Request, didCompleteTask task: URLSessionTask, with error: AFError?) {
        guard let request = request as? DataRequest else { return }
        let responseBody = request.data.map { String(decoding: $0, as: UTF8.self) } ?? "No body."
        debugPrint("[Response body]: \(responseBody)")
        debugPrint("[Response headers]: \(request.response?.headers ?? [:])")
    }
    
}
