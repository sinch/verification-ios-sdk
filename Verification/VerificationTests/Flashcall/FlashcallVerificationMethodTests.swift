//
//  FlashcallVerificationMethodTests.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 14/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Mocker
import XCTest
@testable import Verification

class FlashcallVerificationMethodTests: XCTestCase {
    
    func testCorrectFlashcallInitiationResponseNotifiesListener() throws {
        try createHelperWithFlashcallMethod().testCorrectInitiationResponseNotifiesInitListenerWithProperData()
    }
    
    func testErrorResponseNotifiesInitListenerWithApiError() throws {
        try createHelperWithFlashcallMethod().testErrorResponseNotifiesInitListenerWithApiError()
    }
    
    func testCorrectVerificationNotifiesVerificationListener() throws {
        try createHelperWithFlashcallMethod().testCorrectVerificationNotifiesVerificationListener()
    }
    
    
    func testWrongVerificationNotifiesErrorVerificationListener() throws {
        try createHelperWithFlashcallMethod().testWrongVerificationNotifiesErrorVerificationListener()
    }
    
    private func createMethod(withHelperAsListener helper: CommonVerificationMethodsTestsHelper) -> FlashcallVerificationMethod {
        return FlashcallVerificationMethod(
            verificationMethodConfig: FlashcallVerificationConfig(globalConfig: SinchGlobalConfig.mockedManagerInstance(), number: ""),
            initiationListener: helper,
            verificationListener: helper
        )
    }
    
    private func createHelperWithFlashcallMethod() -> CommonVerificationMethodsTestsHelper {
        let helper = CommonVerificationMethodsTestsHelper(testCase: self, verificationMethodType: .flashcall)
        let method = createMethod(withHelperAsListener: helper)
        helper.method = method
        return helper
    }
}
