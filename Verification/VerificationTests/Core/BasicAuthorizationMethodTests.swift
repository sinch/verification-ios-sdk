//
//  BasicAuthorizationMethodTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 13/05/2026.
//  Copyright © 2026 Sinch. All rights reserved.
//

import XCTest
@testable import Verification

class BasicAuthorizationMethodTests: XCTestCase {

    static let TEST_KEY = "key"
    static let TEST_SECRET = "secret"
    static let TEST_CREDENTIALS_BASE64 = Data("key:secret".utf8).base64EncodedString()
    static let TEST_HEADER = "Basic \(TEST_CREDENTIALS_BASE64)"

    func testAuthHeaderIncludedInRequest() throws {
        let authMethod = BasicAuthorizationMethod(
            appKey: BasicAuthorizationMethodTests.TEST_KEY,
            appSecret: BasicAuthorizationMethodTests.TEST_SECRET
        )
        let request = URLRequest(url: URL(string: "http://sinch.com")!)
        let modifiedRequest = authMethod.onAuthorize(request)
        XCTAssertTrue(modifiedRequest.allHTTPHeaderFields?.contains(where: { key, value in
            key == "Authorization" && value == BasicAuthorizationMethodTests.TEST_HEADER
        }) ?? false, "Modified request contains wrong authorization header.")
    }

    func testAuthHeaderNotIncludedInRequestIfSinchNotPresent() throws {
        let authMethod = BasicAuthorizationMethod(
            appKey: BasicAuthorizationMethodTests.TEST_KEY,
            appSecret: BasicAuthorizationMethodTests.TEST_SECRET
        )
        let request = URLRequest(url: URL(string: "http://example.com")!)
        let modifiedRequest = authMethod.onAuthorize(request)
        let allHeaders = modifiedRequest.allHTTPHeaderFields ?? [:]
        XCTAssertFalse(allHeaders.contains(where: { key, value in
            key == "Authorization" && value == BasicAuthorizationMethodTests.TEST_HEADER
        }), "Modified request contains authorization header that should not be included")
    }

    func testAuthHeaderHasCorrectBase64Encoding() throws {
        let authMethod = BasicAuthorizationMethod(appKey: "myApp", appSecret: "mySecret")
        let request = URLRequest(url: URL(string: "http://sinch.com")!)
        let modifiedRequest = authMethod.onAuthorize(request)
        let expectedBase64 = Data("myApp:mySecret".utf8).base64EncodedString()
        XCTAssertEqual(
            modifiedRequest.value(forHTTPHeaderField: "Authorization"),
            "Basic \(expectedBase64)"
        )
    }

}
