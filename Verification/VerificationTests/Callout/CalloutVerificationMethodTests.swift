//
//  CalloutVerificationMethodTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 14/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

import Mocker
import XCTest
@testable import Verification

class CalloutVerificationMethodTests: XCTestCase {
    
    func testCorrectCalloutInitiationResponseNotifiesListener() throws {
        try createHelperWithCalloutMethod().testCorrectInitiationResponseNotifiesInitListenerWithProperData()
    }
    
    func testErrorResponseNotifiesInitListenerWithApiError() throws {
        try createHelperWithCalloutMethod().testErrorResponseNotifiesInitListenerWithApiError()
    }
    
    func testCorrectVerificationNotifiesVerificationListener() throws {
        try createHelperWithCalloutMethod().testCorrectVerificationNotifiesVerificationListener()
    }
    
    
    func testWrongVerificationNotifiesErrorVerificationListener() throws {
        try createHelperWithCalloutMethod().testWrongVerificationNotifiesErrorVerificationListener()
    }
    
    private func createMethod(withHelperAsListener helper: CommonVerificationMethodsTestsHelper) -> CalloutVerificationMethod {
        return CalloutVerificationMethod(
            verificationMethodConfig: CalloutVerificationConfig(globalConfig: SinchGlobalConfig.mockedManagerInstance(), number: ""),
            initiationListener: helper,
            verificationListener: helper
        )
    }
    
    private func createHelperWithCalloutMethod() -> CommonVerificationMethodsTestsHelper {
        let helper = CommonVerificationMethodsTestsHelper(testCase: self, verificationMethodType: .callout)
        let method = createMethod(withHelperAsListener: helper)
        helper.method = method
        return helper
    }
}
