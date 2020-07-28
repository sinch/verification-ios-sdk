//
//  AcceptedLanguagesTestCase.swift
//  VerificationCoreTests
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import XCTest
@testable import VerificationCore

class AcceptedLanguagesParsingTests: XCTestCase {
    
    func testSingleLanguage() throws {
        let singleLanguage = [try! VerificationLanguage(language: "pl", region: "PL")]
        XCTAssertEqual("pl-PL", singleLanguage.asLanguageString)
    }
    
    func testEmptyList() throws {
        let emptyList: [VerificationLanguage] = []
        XCTAssertEqual(nil, emptyList.asLanguageString)
    }
    
    func testMultiplLanguagesWithSomeWeights() throws {
        let list: [VerificationLanguage] =
        [
            try! VerificationLanguage(language: "pl", region: "PL"),
            try! VerificationLanguage(language: "fr", region: "CA", weight: 0.5),
            try! VerificationLanguage(language: "is", region: "IS"),
            try! VerificationLanguage(language: "pl")
        ]
        XCTAssertEqual("pl-PL,fr-CA;q=0.5,is-IS,pl", list.asLanguageString)

    }
    
    func testMultipleLanguagesWithWeights() throws {
        let list: [VerificationLanguage] =
        [
            try! VerificationLanguage(language: "pl", region: "PL", weight: 0.0),
            try! VerificationLanguage(language: "fr", region: "CA", weight: 0.5),
            try! VerificationLanguage(language: "is", region: "IS", weight: 1.0),
            try! VerificationLanguage(language: "pl", region: "DE", weight: 0.3333)
        ]
        XCTAssertEqual("pl-PL;q=0,fr-CA;q=0.5,is-IS;q=1,pl-DE;q=0.333", list.asLanguageString)
    }

}
