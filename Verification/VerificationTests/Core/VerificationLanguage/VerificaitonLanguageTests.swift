//
//  VerificaitonLanguageTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 27/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import XCTest
@testable import Verification

class VerificaitonLanguageTests: XCTestCase {

    func testLanguageOnly() throws {
        let language = "pl"
        let languageOnly = try VerificationLanguage(language: language)
        XCTAssertEqual(language, languageOnly.httpHeader)
        XCTAssertEqual(language, languageOnly.language)
        XCTAssertEqual(nil, languageOnly.region)
        XCTAssertEqual(nil, languageOnly.weight)
    }
    
    func testLanguageAndRegion() throws {
        let language = "pl"
        let region = "PL"
        let languageAndRegion = try VerificationLanguage(language: language, region: region)
        
        XCTAssertEqual("pl-PL", languageAndRegion.httpHeader)
        XCTAssertEqual(language, languageAndRegion.language)
        XCTAssertEqual(region, languageAndRegion.region)
        XCTAssertEqual(nil, languageAndRegion.weight)
    }

    func testAllLanguageOptions() throws {
        let language = "pl"
        let region = "PL"
        let weight = 0.5
        let verLanguage = try VerificationLanguage(language: language, region: region, weight: weight)
        
        XCTAssertEqual("pl-PL;q=0.5", verLanguage.httpHeader)
        XCTAssertEqual(language, verLanguage.language)
        XCTAssertEqual(region, verLanguage.region)
        XCTAssertEqual(weight, verLanguage.weight)
    }
    
    func testContentLanguageOnlyLanguage() throws {
        let header = "pl"
        let verLanguage = VerificationLanguage(contentLanguageHeader: header)
        
        XCTAssertEqual("pl", verLanguage.language)
        XCTAssertEqual(nil, verLanguage.region)
        XCTAssertEqual(nil, verLanguage.weight)
    }
    
    func testContentLanguageFull() throws {
        let header = "pl-PL"
        let verLanguage = VerificationLanguage(contentLanguageHeader: header)
        
        XCTAssertEqual("pl", verLanguage.language)
        XCTAssertEqual("PL", verLanguage.region)
        XCTAssertEqual(nil, verLanguage.weight)
    }
    
    func testWrongContentLanguageParsedAsExpected() throws {
        let header = "pl-PL-AAA"
        let verLanguage = try VerificationLanguage(contentLanguageHeader: header)
        
        XCTAssertEqual("pl", verLanguage.language)
        XCTAssertEqual("PL", verLanguage.region)
        XCTAssertEqual(nil, verLanguage.weight)
    }
    
    func testWeightDigitsMax() throws {
        let language = "pl"
        let weight = 0.3333333
        let verLanguage = try VerificationLanguage(language: language, weight: weight)
        
        XCTAssertEqual("pl;q=0.333", verLanguage.httpHeader)
        XCTAssertEqual(language, verLanguage.language)
        XCTAssertEqual(nil, verLanguage.region)
        XCTAssertEqual(weight, verLanguage.weight)
    }
    
    func testIllegalArgumentIfWeightLowerThen0() throws {
        XCTAssertThrowsError(try VerificationLanguage(language: "pl", weight: -1)) { error in
            guard case SDKError.illegalArgument = error else {
                return XCTFail()
            }
        }
    }
    
    func testIllegalArgumentIfWeightGreaterThen1() throws {
        XCTAssertThrowsError(try VerificationLanguage(language: "pl", weight: 1.1)) { error in
            guard case SDKError.illegalArgument = error else {
                return XCTFail()
            }
        }
    }
}
