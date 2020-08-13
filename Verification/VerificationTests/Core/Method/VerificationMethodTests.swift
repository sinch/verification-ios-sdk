//
//  VerificationMethodTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 12/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

import XCTest
@testable import Verification

class VerificationMethodTests: XCTestCase {
    
    func testBaseStateIdle() {
        let mockedMethod = MockedVerificationMethod.instanceForTests()
        XCTAssertTrue(mockedMethod.verificationState == .idle)
    }
    
    func testInitiatingCausesStateUpdate() {
        let mockedMethod = MockedVerificationMethod.instanceForTests()
        mockedMethod.initiate()
        XCTAssertEqual(mockedMethod.verificationState, VerificationState.initialization(status: .ongoing))
    }
    
    func testInitiatingCallsOnInitate() {
        let mockedMethod = MockedVerificationMethod.instanceForTests()
        mockedMethod.initiate()
        XCTAssertTrue(mockedMethod.wasOnInitiateCalled)
    }
    
    func testVerifyCallsOnVerify() {
        let mockedMethod = MockedVerificationMethod.instanceForTests()
        mockedMethod.verify(verificationCode: "")
        XCTAssertTrue(mockedMethod.wasOnVerifyCalled)
    }
    
    func testDefaultVerifyPassesManualSource() {
        let mockedMethod = MockedVerificationMethod.instanceForTests()
        mockedMethod.verify(verificationCode: "")
        XCTAssertEqual(mockedMethod.source, VerificationSourceType.manual)
    }
    
    func testStartingVerificationCausesVerificationStateUpdate() {
        let mockedMethod = MockedVerificationMethod.instanceForTests()
        mockedMethod.verify(verificationCode: "")
        XCTAssertEqual(mockedMethod.verificationState, VerificationState.verification(status: .ongoing))
    }
    
    func testMultipleInitiateCallssOfOngoingProcessCallsOnInitiateOnce() {
        let mockedMethod = MockedVerificationMethod.instanceForTests()
        for _ in 0...3 {
            mockedMethod.initiate()
        }
        XCTAssertEqual(mockedMethod.numberOfOnInitiateCalls, 1)
    }
    
    func testMultipleVerifyCallssOfOngoingProcessCallsOnInitiateOnce() {
        let mockedMethod = MockedVerificationMethod.instanceForTests()
        for _ in 0...3 {
            mockedMethod.verify(verificationCode: "")
        }
        XCTAssertEqual(mockedMethod.numberOfOnVerifyCalls, 1)
    }
    
}
