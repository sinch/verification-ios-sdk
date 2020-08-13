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
    
    private let testErrorData: ApiErrorData = ApiErrorData(errorCode: 500,
                                                   message: "Test error message",
                                                   reference: "Test reference")
    
    private var expectation: XCTestExpectation!
    private var onInitiatedCallback: (InitiationResponseData) -> Void = { _ in }
    private var onInitiatedFailedCallback: (Error) -> Void = { _ in }
    private var onVerifiedCallback: () -> Void = { }
    private var onVerificationFailedCallback: (Error) -> Void = { _ in }
    
    func testCorrectInitiationResponseNotifiesInitListenerWithProperData() throws {
        let expectedResponse = initiationResponse()
        
        self.expectation = expectation(description: "onInitiated listener callback called")
        self.onInitiatedCallback = { [weak self] data in
            XCTAssertEqual(expectedResponse, data)
            self?.expectation.fulfill()
        }
        
        let method = SmsVerificationMethod(
            verificationMethodConfig: SmsVerificationConfig(globalConfig: SinchGlobalConfig.mockedManagerInstance(), number: ""),
            initiationListener: self,
            verificationListener: self
        )
        
        let smsInitiationData = SmsVerificationInitiationData(basedOnConfiguration: method.verificationMethodConfig)
        let route = SmsVerificationRouter.initiateVerification(data: smsInitiationData, preferedLanguages: method.verificationMethodConfig.acceptedLanguages)
        
        Mock(url: try! route.asURLRequest().url!, dataType: .json, statusCode: 200, data: [.post: expectedResponse.asData!]).register()

        method.initiate()
        waitForExpectations(timeout: 0.5)
    }
    
    func testErrorResposneNotifiesInitListenerWithApiError() throws {
        let testErrorData = self.testErrorData
        self.expectation = expectation(description: "onInitiationFailed listener callback called")
        self.onInitiatedFailedCallback = { [weak self] error in
            if case SDKError.apiCall(let errorData) = error {
                XCTAssertEqual(errorData, testErrorData)
            } else {
                XCTFail("Wrong error passed to initiation listener")
            }
            self?.expectation.fulfill()
        }
        
        let method = SmsVerificationMethod(
            verificationMethodConfig: SmsVerificationConfig(globalConfig: SinchGlobalConfig.mockedManagerInstance(), number: ""),
            initiationListener: self,
            verificationListener: self
        )
        
        let smsInitiationData = SmsVerificationInitiationData(basedOnConfiguration: method.verificationMethodConfig)
        let route = SmsVerificationRouter.initiateVerification(data: smsInitiationData, preferedLanguages: method.verificationMethodConfig.acceptedLanguages)
        
        Mock(url: try! route.asURLRequest().url!, dataType: .json, statusCode: 400, data: [.post: testErrorData.asData!]).register()

        method.initiate()
        waitForExpectations(timeout: 0.5)
        
    }
    
    func testCorrectVerificationNotifiesVerificationListener() throws {
        self.expectation = expectation(description: "onVerified listener callback called")
        self.onVerifiedCallback = { [weak self] in
            self?.expectation.fulfill()
        }
        
        let method = SmsVerificationMethod(
            verificationMethodConfig: SmsVerificationConfig(globalConfig: SinchGlobalConfig.mockedManagerInstance(), number: ""),
            initiationListener: self,
            verificationListener: self
        )
        mockCorrectInitiation(forMethod: method)
        
        Mock(url: try verificationUrl(forNumber: ""), dataType: .json, statusCode: 200, data: [.put: VerificationResponseData.correctVerificationResponse(fromSource: .manual, method: .sms).asData!]).register()
        
        method.verify(verificationCode: "validCode")
        waitForExpectations(timeout: 0.5)
    }
    
    func testWrongVerificationNotifiesErrorVerificationListener() throws {
        let testErrorData = self.testErrorData
        
        self.expectation = expectation(description: "onVerificationFailed listener callback called")
        self.onVerificationFailedCallback = { [weak self] error in
            if case SDKError.apiCall(let errorData) = error {
                XCTAssertEqual(errorData, testErrorData)
            } else {
                XCTFail("Wrong error passed to initiation listener")
            }
            self?.expectation.fulfill()
        }

        let method = SmsVerificationMethod(
            verificationMethodConfig: SmsVerificationConfig(globalConfig: SinchGlobalConfig.mockedManagerInstance(), number: ""),
            initiationListener: self,
            verificationListener: self
        )
        mockCorrectInitiation(forMethod: method)

        Mock(url: try verificationUrl(forNumber: ""), dataType: .json, statusCode: 400, data: [.put: testErrorData.asData!]).register()

        method.verify(verificationCode: "wrongCode")
        waitForExpectations(timeout: 0.5)
    }
    
    private func verificationUrl(forNumber number: String) throws -> URL {
        return try SmsVerificationRouter.verifyCode(
            number: number,
            data: SmsVerificationData(details: SmsVerificationDetails(code: ""), source: .manual)
        ).asURLRequest().url!
    }
    
    private func initiationResponse(withContentLanguage contentLanguage: VerificationLanguage? = nil) -> InitiationResponseData {
        return InitiationResponseData(
            id: "id",
            method: .sms,
            smsDetails: SmsInitiationDetails(template: ""),
            seamlessDetails: nil,
            contentLanguage: contentLanguage
        )
    }
    
    private func mockCorrectInitiation(forMethod method: SmsVerificationMethod) {
        let smsInitiationData = SmsVerificationInitiationData(basedOnConfiguration: method.verificationMethodConfig)
        let route = SmsVerificationRouter.initiateVerification(data: smsInitiationData, preferedLanguages: method.verificationMethodConfig.acceptedLanguages)
        
        Mock(url: try! route.asURLRequest().url!, dataType: .json, statusCode: 200, data: [.post: initiationResponse().asData!]).register()
        method.initiate()
    }
    
}

extension SmsVerificationMethodTests: InitiationListener, VerificationListener {
    
    func onInitiated(_ data: InitiationResponseData) {
        onInitiatedCallback(data)
    }
    
    func onInitiationFailed(e: Error) {
        onInitiatedFailedCallback(e)
    }
    
    func onVerified() {
        onVerifiedCallback()
    }
    
    func onVerificationFailed(e: Error) {
        onVerificationFailedCallback(e)
    }
}
