//
//  MetadataCollectorTests.swift
//  MetadataCollectorTests
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import XCTest
@testable import MetadataCollector
@testable import VerificationCore

class SimCardInfoHolderEncodingTests: XCTestCase {
    
    let countNameField = "count"
    let simNameField = "sim"
    
    func testSingleCardInfo() throws {
        let singleSimCardInfo = SimCardInfo(simInfo: SimMetadata(countryId: "pl", name: "Orange", mnc: "123", mcc: "321"))
        let singleSimHolder = SimCardsInfoHolder(info: [singleSimCardInfo])
        let json = singleSimHolder.asDictionary
        
        XCTAssertTrue(json.count == 2) //count and '1' field
        XCTAssertTrue(json[countNameField] as? Int == 1)
        guard let simInfo = json["1"] as? JSON else {
            XCTFail("SimInfo not properly encoded \(json)")
            return
        }
        XCTAssertTrue(simInfo.keys.contains(simNameField))
    }
    
    func testMultipleCardInfo() throws {
        let exampleSim = SimCardInfo(simInfo: SimMetadata(countryId: "pl", name: "Orange", mnc: "123", mcc: "321"))
        let holder = SimCardsInfoHolder(info: Array(repeating: exampleSim, count: 3))
        let json = holder.asDictionary
        
        XCTAssertTrue(json.count == 4) //count and '1' '2' '3' fields
        XCTAssertTrue(json[countNameField] as? Int == 3)
        
        guard let simInfo1 = json["1"] as? JSON, let simInfo2 = json["2"] as? JSON, let simInfo3 = json["3"] as? JSON else {
            XCTFail("SimInfo not properly encoded \(json)")
            return
        }
        [simInfo1, simInfo2, simInfo3].forEach {
            XCTAssertTrue($0.keys.contains(simNameField))
        }
    
    }
    
    func testEmptySimCardInfo() throws {
        let holder = SimCardsInfoHolder(info: [])
        let json = holder.asDictionary
        
        XCTAssertTrue(json.count == 1) //count only field
        XCTAssertTrue(json[countNameField] as? Int == 0)
    }
    
}
