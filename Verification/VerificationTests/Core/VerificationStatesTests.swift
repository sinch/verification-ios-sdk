//
//  VerificationStatesTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import XCTest
@testable import Verification

class VerificationStatesTests: XCTestCase {

    func testStateStatusIsFinished() throws {
        var status: VerificationStateStatus = .ongoing
        XCTAssertFalse(status.isFinished)
        status = .success
        XCTAssertTrue(status.isFinished)
        status = .success
        XCTAssertTrue(status.isFinished)
    }
    
    func testVerificationStateCanBeInitiated() throws {
        let verificationThatCanBeInitiated: [VerificationState] = [
            .idle,
            .initialization(status: .error)
        ]
        
        let verificationThatCantBeInitiated: [VerificationState] = [
            .manuallyStopped,
            .verification(status: .error),
            .initialization(status: .ongoing)
        ]
        
        for state in verificationThatCanBeInitiated {
            XCTAssertTrue(state.canInitiate)
        }
        
        for state in verificationThatCantBeInitiated {
            XCTAssertFalse(state.canInitiate)
        }
    }
    
    func testVerificationStateCanVerify() throws {
        let verificationThatCanBeVerified: [VerificationState] = [
            .idle,
            .manuallyStopped,
            .verification(status: .error)
        ]
        
        let verificationThatCantBeVerified: [VerificationState] = [
            .verification(status: .success)
        ]
        
        for state in verificationThatCanBeVerified {
            XCTAssertTrue(state.canVerify)
        }
        
        for state in verificationThatCantBeVerified {
            XCTAssertFalse(state.canVerify)
        }
    }
    
    func testVerificationProcessFinished() throws {
        let finishedVerifications: [VerificationState] = [
            .initialization(status: .error),
            .manuallyStopped,
            .initialization(status: .error),
            .verification(status: .error)
        ]
        
        let notFinishedVerifications: [VerificationState] = [
            .idle,
            .initialization(status: .ongoing),
            .initialization(status: .success),
            .verification(status: .ongoing)
        ]
        
        for state in finishedVerifications {
            XCTAssertTrue(state.isVerificationProcessFinished)
        }
        
        for state in notFinishedVerifications {
            XCTAssertFalse(state.isVerificationProcessFinished)
        }

    }
}
