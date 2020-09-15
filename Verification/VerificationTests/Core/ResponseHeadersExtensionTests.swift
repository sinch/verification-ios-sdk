//
//  ResponseHeadersExtensionTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 15/09/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import XCTest
@testable import Verification

class ResponseHeadersExtensionTests: XCTestCase {
    
    let DateHeader = "Date"
    let ContentLanguageHeader = "Content-Language"
    
    func testNoContentLanguage() throws {
        let headers: ResponseHeaders = [:]
        XCTAssertNil(headers.contentLanguage)
    }
    
    func testLanguagePresentHeader1() throws {
        let headers: ResponseHeaders = [ContentLanguageHeader: "es-ES"]
        let expectedLanguage = try VerificationLanguage(language: "es", region: "ES")
        XCTAssertEqual(headers.contentLanguage, expectedLanguage)
    }
    
    func testLanguagePresentHeaderOnlyLang() throws {
        let headers: ResponseHeaders = [ContentLanguageHeader: "pl"]
        let expectedLanguage = try VerificationLanguage(language: "pl")
        XCTAssertEqual(headers.contentLanguage, expectedLanguage)
    }
    
    func testNoGeneartionDate() throws {
        let headers: ResponseHeaders = [:]
        XCTAssertNil(headers.generationDate)
    }
    
    func testMalformedGenerationDate() throws {
        let headers: ResponseHeaders = [DateHeader: "15Sep2020"]
        XCTAssertNil(headers.generationDate)
    }
    
    func testGenerationDateMorning() throws {
        let headers: ResponseHeaders = [DateHeader: "Tue, 15 Sep 2020 08:06:35 GMT"]
        let date = Date(timeIntervalSince1970: 1600157195)
        XCTAssertEqual(headers.generationDate, date)
    }
    
    func testGenerationDate24H() throws {
        let headers: ResponseHeaders = [DateHeader: "Tue, 15 Sep 2020 15:00:00 GMT"]
        let date = Date(timeIntervalSince1970: 1600182000)
        XCTAssertEqual(headers.generationDate, date)
    }
    
    func testGenerationDateFirstOfMonth() throws {
        let headers: ResponseHeaders = [DateHeader: "Fri, 01 May 2020 01:00:00 GMT"]
        let date = Date(timeIntervalSince1970: 1588294800)
        XCTAssertEqual(headers.generationDate, date)
    }
    
    func testGenerationDateESTTimeZone() throws {
        let headers: ResponseHeaders = [DateHeader: "Wed, 02 Oct 2002 08:00:00 EST"]
        let date = Date(timeIntervalSince1970: 1033563600)
        XCTAssertEqual(headers.generationDate, date)
    }
}
