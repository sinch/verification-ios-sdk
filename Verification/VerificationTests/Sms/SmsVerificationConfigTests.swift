//
//  SmsVerificationConfigTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 27/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import XCTest
@testable import Verification

class SmsVerificationConfigTests: XCTestCase {
    
    let testGlobalConfig = SinchGlobalConfig.Builder.instance()
        .authorizationMethod(AppKeyAuthorizationMethod(appKey: "")).build()
    let testNumber = "+48123456789"
    let testCustom = "custom"
    let testReference = "reference"
    let honoursEarly = false
    let acceptedLanguages = [try! VerificationLanguage(language: "pl")]
    
    func testBasicBuilder() throws {
        
        let builtConfiguration = SmsVerificationConfig.Builder.instance()
            .globalConfig(testGlobalConfig)
            .number(testNumber)
            .build()
        
        let initializedConfig = SmsVerificationConfig(globalConfig: testGlobalConfig, number: testNumber)
        
        XCTAssertTrue(builtConfiguration.commonPropertiesMatch(initializedConfig))
        
    }
    
    func testFullBuilder() throws {
        
        let builtConfiguration = SmsVerificationConfig.Builder.instance()
            .globalConfig(testGlobalConfig)
            .number(testNumber)
            .acceptedLanguages(acceptedLanguages)
            .custom(testCustom)
            .honourEarlyReject(honoursEarly)
            .reference(testReference)
            .build()
        
        let initializedConfig = SmsVerificationConfig(
            globalConfig: testGlobalConfig,
            number: testNumber,
            custom: testCustom,
            reference: testReference,
            honoursEarlyReject: honoursEarly,
            acceptedLanguages: acceptedLanguages
        )
        
        XCTAssertTrue(builtConfiguration.commonPropertiesMatch(initializedConfig))
        
    }
    
    func testFullBuilderParamatersExpectations() {
        let builtConfiguration = SmsVerificationConfig.Builder.instance()
            .globalConfig(testGlobalConfig)
            .number(testNumber)
            .acceptedLanguages(acceptedLanguages)
            .custom(testCustom)
            .honourEarlyReject(honoursEarly)
            .reference(testReference)
            .build()
        
        XCTAssertEqual(builtConfiguration.number, testNumber)
        XCTAssertEqual(builtConfiguration.acceptedLanguages, acceptedLanguages)
        XCTAssertEqual(builtConfiguration.custom, testCustom)
        XCTAssertEqual(builtConfiguration.reference, testReference)
        XCTAssertEqual(builtConfiguration.honoursEarlyReject, honoursEarly)
    }
    
    func testDefaultParametersExpected() {
        let builtConfiguration = SmsVerificationConfig.Builder.instance()
            .globalConfig(testGlobalConfig)
            .number(testNumber)
            .build()
        
        XCTAssertEqual(builtConfiguration.number, testNumber)
        XCTAssertEqual(builtConfiguration.acceptedLanguages, [])
        XCTAssertEqual(builtConfiguration.custom, nil)
        XCTAssertEqual(builtConfiguration.reference, nil)
        XCTAssertEqual(builtConfiguration.honoursEarlyReject, true)
        
    }
    
}
