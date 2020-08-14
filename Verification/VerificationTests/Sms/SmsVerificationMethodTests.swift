//
//  SmsVerificationMethodTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 13/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Mocker
import XCTest
@testable import Verification

class SmsVerificationMethodTests: XCTestCase {
    
    func testCorrectSmsInitiationResponseNotifiesListener() throws {
        try createHelperWithSmsMethod().testCorrectInitiationResponseNotifiesInitListenerWithProperData()
    }
    
    func testErrorResponseNotifiesInitListenerWithApiError() throws {
        try createHelperWithSmsMethod().testErrorResponseNotifiesInitListenerWithApiError()
    }
    
    func testCorrectVerificationNotifiesVerificationListener() throws {
        try createHelperWithSmsMethod().testCorrectVerificationNotifiesVerificationListener()
    }
    
    
    func testWrongVerificationNotifiesErrorVerificationListener() throws {
        try createHelperWithSmsMethod().testWrongVerificationNotifiesErrorVerificationListener()
    }
    
    private func createMethod(withHelperAsListener helper: CommonVerificationMethodsTestsHelper) -> SmsVerificationMethod {
        return SmsVerificationMethod(
            verificationMethodConfig: SmsVerificationConfig(globalConfig: SinchGlobalConfig.mockedManagerInstance(), number: ""),
            initiationListener: helper,
            verificationListener: helper
        )
    }
    
    private func createHelperWithSmsMethod() -> CommonVerificationMethodsTestsHelper {
        let helper = CommonVerificationMethodsTestsHelper(testCase: self, verificationMethodType: .sms)
        let method = createMethod(withHelperAsListener: helper)
        helper.method = method
        return helper
    }
}
