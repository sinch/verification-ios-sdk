//
//  InitiationResponseDataTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 15/09/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import XCTest
@testable import Verification

class InitiationResponseDataTests: XCTestCase {
    
    func testNoTimeoutDate() throws {
        let initiationData = InitiationResponseData(id: "", method: .seamless, smsDetails: nil, flashcallDetails: nil, seamlessDetails: SeamlessInitiationDetails(targetUri: ""), contentLanguage: nil, dateOfGeneration: Date())
        
        XCTAssertNil(initiationData.initiationDataTimeoutDate)
    }
    
    func testFlashcallInterceptionDate() throws {
        let interceptionTimeout: TimeInterval = 59
        let flashcallDetails = FlashcallInitiationDetails(interceptionTimeout: interceptionTimeout)
        let dateOfGeneration = Date(timeIntervalSince1970: 1600160264)
        let initiationData = InitiationResponseData(id: "", method: .flashcall, smsDetails: nil, flashcallDetails: flashcallDetails, seamlessDetails: nil, contentLanguage: nil, dateOfGeneration: dateOfGeneration)
        
        XCTAssertEqual(initiationData.initiationDataTimeoutDate, dateOfGeneration.addingTimeInterval(interceptionTimeout))
    }
    
    func testSmsInterceptionDate() throws {
        let interceptionTimeout: TimeInterval = 30
        let smsDetails = SmsInitiationDetails(template: "", interceptionTimeout: interceptionTimeout)
        let dateOfGeneration = Date(timeIntervalSince1970: 1600160264)
        let initiationData = InitiationResponseData(id: "", method: .sms, smsDetails: smsDetails, flashcallDetails: nil, seamlessDetails: nil, contentLanguage: nil, dateOfGeneration: dateOfGeneration)
        
        XCTAssertEqual(initiationData.initiationDataTimeoutDate, dateOfGeneration.addingTimeInterval(interceptionTimeout))
    }
    
    func testNoInterceptionTimeoutWhenMethodsDontMatch() throws {
        let interceptionTimeout: TimeInterval = 2
        let flashcallDetails = FlashcallInitiationDetails(interceptionTimeout: interceptionTimeout)
        let dateOfGeneration = Date(timeIntervalSince1970: 1600160264)
        let initiationData = InitiationResponseData(id: "", method: .sms, smsDetails: nil, flashcallDetails: flashcallDetails, seamlessDetails: nil, contentLanguage: nil, dateOfGeneration: dateOfGeneration)
        
        XCTAssertNil(initiationData.initiationDataTimeoutDate)
    }
}
