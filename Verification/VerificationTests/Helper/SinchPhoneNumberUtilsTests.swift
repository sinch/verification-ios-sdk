//
//  SinchPhoneNumberUtilsTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 07/09/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import XCTest
@testable import Verification

class SinchPhoneNumberUtilsTests: XCTestCase {
    
    func testUSPhoneNumberValid() throws {
        let countryIso = "US"
        XCTAssertTrue(SinchPhoneNumberUtils.isPossiblePhoneNumber("202-555-0123", forCountryIso: countryIso))
        XCTAssertTrue(SinchPhoneNumberUtils.isPossiblePhoneNumber("+1202-555-0123", forCountryIso: countryIso))
        
        XCTAssertFalse(SinchPhoneNumberUtils.isPossiblePhoneNumber("+202-555-0123", forCountryIso: countryIso))
        XCTAssertFalse(SinchPhoneNumberUtils.isPossiblePhoneNumber("+48202-555-0123", forCountryIso: countryIso))
    }
    
    func testUKPhoneNumberValid() throws {
        let countryIso = "GB"
        XCTAssertTrue(SinchPhoneNumberUtils.isPossiblePhoneNumber("+44 117 496 0208", forCountryIso: countryIso))
        XCTAssertTrue(SinchPhoneNumberUtils.isPossiblePhoneNumber("0117 496 0208", forCountryIso: countryIso))
        XCTAssertTrue(SinchPhoneNumberUtils.isPossiblePhoneNumber("+44(0)7777666666", forCountryIso: countryIso))

        XCTAssertFalse(SinchPhoneNumberUtils.isPossiblePhoneNumber("222", forCountryIso: countryIso))
        XCTAssertFalse(SinchPhoneNumberUtils.isPossiblePhoneNumber("+101632 960983", forCountryIso: countryIso))
    }
    
    func testDEPhoneNumberValid() throws {
        let countryIso = "DE"
        XCTAssertTrue(SinchPhoneNumberUtils.isPossiblePhoneNumber("30 748325824", forCountryIso: countryIso))
        XCTAssertTrue(SinchPhoneNumberUtils.isPossiblePhoneNumber("+49 30 748325824", forCountryIso: countryIso))

        XCTAssertFalse(SinchPhoneNumberUtils.isPossiblePhoneNumber("+301 748325824", forCountryIso: countryIso))
        XCTAssertFalse(SinchPhoneNumberUtils.isPossiblePhoneNumber("", forCountryIso: countryIso))
    }
    
    func testPLPhoneNumberToE164() throws {
        let countryIso = "PL"
        XCTAssertEqual(SinchPhoneNumberUtils.formatNumberToE164("532241108", forCountryIso: countryIso), "+48532241108")
        XCTAssertEqual(SinchPhoneNumberUtils.formatNumberToE164("+48-605-5512-95", forCountryIso: countryIso), "+48605551295")
        XCTAssertEqual(SinchPhoneNumberUtils.formatNumberToE164("", forCountryIso: countryIso), nil)
    }
    
    func testUSPhoneNumberToE164() throws {
        let countryIso = "US"
        XCTAssertEqual(SinchPhoneNumberUtils.formatNumberToE164("202-555-0123", forCountryIso: countryIso), "+12025550123")
        XCTAssertEqual(SinchPhoneNumberUtils.formatNumberToE164("+12025550123", forCountryIso: countryIso), "+12025550123")
    }
    
}
