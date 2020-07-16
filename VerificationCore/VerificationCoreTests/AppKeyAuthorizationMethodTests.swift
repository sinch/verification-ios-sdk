//
//  VerificationCoreTests.swift
//  VerificationCoreTests
//
//  Created by Aleksander Wojcik on 08/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import XCTest
@testable import VerificationCore

class AppKeyAuthorizationMethodTests: XCTestCase {

    static let TEST_KEY = "key"
    static let TEST_KEY_HEADER = "Application \(TEST_KEY)"

    func testAuthHeaderIncludedInRequest() throws {
        let authMethod = AppKeyAuthorizationMethod(appKey: AppKeyAuthorizationMethodTests.TEST_KEY)
        let request = URLRequest(url: URL(string: "http://localhost.com")!)
        let modifiedRequest = authMethod.onAuthorize(request)
        XCTAssertTrue(modifiedRequest.allHTTPHeaderFields?.contains(where: { key, value in
            key == "Authorization" && value == AppKeyAuthorizationMethodTests.TEST_KEY_HEADER
        }) ?? false , "Modified request contains wrong authorization header.")
    }

}
