//
//  SeamlessVerificationMethodTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 14/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Mocker
import XCTest
@testable import Verification

class SeamlessVerificationMethodTests: XCTestCase {
    
    func testCorrectSeamlessInitiationResponseNotifiesListener() throws {
        try createHelperWithSeamlessMethod().testCorrectInitiationResponseNotifiesInitListenerWithProperData()
    }
    
    func testErrorResponseNotifiesInitListenerWithApiError() throws {
        try createHelperWithSeamlessMethod().testErrorResponseNotifiesInitListenerWithApiError()
    }
    
    func testCorrentInitiationAutomaticallyCallsVerify() throws {
        let extraVerifyExpectationCalled = expectation(description: "onVerifyCalled after initiating successfully")
        let helper = createHelperWithSeamlessMethod()
        helper.onVerifiedCallback = {
            extraVerifyExpectationCalled.fulfill()
        }
        helper.mockCorrectVerification()
        try helper.testCorrectInitiationResponseNotifiesInitListenerWithProperData()
    }
    
    private func createMethod(withHelperAsListener helper: CommonVerificationMethodsTestsHelper) -> SeamlessVerificationMethod {
        return SeamlessVerificationMethod(
            verificationMethodConfig: SeamlessVerificationConfig(globalConfig: SinchGlobalConfig.mockedManagerInstance(), number: ""),
            initiationListener: helper,
            verificationListener: helper
        )
    }
    
    private func createHelperWithSeamlessMethod() -> CommonVerificationMethodsTestsHelper {
        let helper = CommonVerificationMethodsTestsHelper(testCase: self, verificationMethodType: .seamless, verificationUrlCreator: { data in
            return URL(string: data.seamlessDetails!.targetUri)!
        })
        let method = createMethod(withHelperAsListener: helper)
        helper.method = method
        return helper
    }

}
