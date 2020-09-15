//
//  CommonVerificationMethodsTestsHelper.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 14/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Mocker
import XCTest
@testable import Verification

class CommonVerificationMethodsTestsHelper {
    
    static var defaultTestInitURL: URL {
        return URL(string: "\(Constants.Api.domain)verification/\(Constants.Api.version)/verifications")!
    }
    
    static var defaultTestVerificationURL: URL {
        return URL(string: "\(Constants.Api.domain)verification/\(Constants.Api.version)/verifications/number/")!
    }
    
    private let testCase: XCTestCase
    private let verificationMethodType: VerificationMethodType
    private let initiationUrlCreator: () -> URL
    private let verificationUrlCreator: (InitiationResponseData) -> URL
        
    private let testErrorData: ApiErrorData = ApiErrorData(errorCode: 500,
                                                   message: "Test error message",
                                                   reference: "Test reference")
    
    private var expectation: XCTestExpectation!
    
    var onInitiatedCallback: (InitiationResponseData) -> Void = { _ in }
    var onInitiatedFailedCallback: (Error) -> Void = { _ in }
    var onVerifiedCallback: () -> Void = { }
    var onVerificationFailedCallback: (Error) -> Void = { _ in }
    
    var method: VerificationMethod!
    
    init(testCase: XCTestCase,
         verificationMethodType: VerificationMethodType,
         initiationUrlCreator: @escaping () -> URL = { return CommonVerificationMethodsTestsHelper.defaultTestInitURL },
         verificationUrlCreator: @escaping (InitiationResponseData) -> URL = { _ in return CommonVerificationMethodsTestsHelper.defaultTestVerificationURL }) {
        self.testCase = testCase
        self.verificationMethodType = verificationMethodType
        self.initiationUrlCreator = initiationUrlCreator
        self.verificationUrlCreator = verificationUrlCreator
    }
    
    func testCorrectInitiationResponseNotifiesInitListenerWithProperData() throws {
        let expectedResponse = initiationResponse()
        self.expectation = testCase.expectation(description: "onInitiated listener callback called")
        
        self.onInitiatedCallback = { [weak self] data in
            XCTAssertEqual(expectedResponse, data)
            self?.expectation.fulfill()
        }
        
        Mock(url: initiationUrlCreator(), dataType: .json, statusCode: 200, data: [.post: expectedResponse.asData!]).register()

        method?.initiate()
        testCase.waitForExpectations(timeout: 0.5)
    }
    
    func testErrorResponseNotifiesInitListenerWithApiError() throws {
        let testErrorData = self.testErrorData
        self.expectation = testCase.expectation(description: "onInitiationFailed listener callback called")
        self.onInitiatedFailedCallback = { [weak self] error in
            if case SDKError.apiCall(let errorData) = error {
                XCTAssertEqual(errorData, testErrorData)
            } else {
                XCTFail("Wrong error passed to initiation listener")
            }
            self?.expectation.fulfill()
        }
        
        Mock(url: initiationUrlCreator(), dataType: .json, statusCode: 400, data: [.post: testErrorData.asData!]).register()

        method?.initiate()
        testCase.waitForExpectations(timeout: 0.5)
    }
    
    func testCorrectVerificationNotifiesVerificationListener() throws {
        self.expectation = testCase.expectation(description: "onVerified listener callback called")
        self.onVerifiedCallback = { [weak self] in
            self?.expectation.fulfill()
        }
        
        mockCorrectInitiation()
        
        Mock(url: verificationUrlCreator(initiationResponse()), dataType: .json, statusCode: 200,
             data: [.put: VerificationResponseData.correctVerificationResponse(fromSource: .manual, method: .sms).asData!])
            .register()
        
        method?.verify(verificationCode: "validCode")
        testCase.waitForExpectations(timeout: 0.5)
    }
    
    func testWrongVerificationNotifiesErrorVerificationListener() throws {
        let testErrorData = self.testErrorData
        
        self.expectation = testCase.expectation(description: "onVerificationFailed listener callback called")
        self.onVerificationFailedCallback = { [weak self] error in
            if case SDKError.apiCall(let errorData) = error {
                XCTAssertEqual(errorData, testErrorData)
            } else {
                XCTFail("Wrong error passed to initiation listener")
            }
            self?.expectation.fulfill()
        }
        
        mockCorrectInitiation()

        Mock(url: verificationUrlCreator(initiationResponse()), dataType: .json, statusCode: 400, data: [.put: testErrorData.asData!]).register()

        method.verify(verificationCode: "wrongCode")
        testCase.waitForExpectations(timeout: 0.5)
    }
    
    private func initiationResponse(withContentLanguage contentLanguage: VerificationLanguage? = nil) -> InitiationResponseData {
        return InitiationResponseData(
            id: "id",
            method: self.verificationMethodType,
            smsDetails: SmsInitiationDetails(template: "", interceptionTimeout: 60),
            flashcallDetails: FlashcallInitiationDetails(interceptionTimeout: 60),
            seamlessDetails: SeamlessInitiationDetails(targetUri: "http://example.com"),
            contentLanguage: contentLanguage,
            dateOfGeneration: Date()
        )
    }
    
    private func mockCorrectInitiation() {
        Mock(url: initiationUrlCreator(), dataType: .json, statusCode: 200, data: [.post: initiationResponse().asData!]).register()
        method.initiate()
    }
    
    func mockCorrectVerification() {
        let returnedData = VerificationResponseData.correctVerificationResponse(fromSource: .manual, method: .sms).asData!
        Mock(url: verificationUrlCreator(initiationResponse()), dataType: .json,
             statusCode: 200, data: [.put: returnedData, .get: returnedData]).register()
    }
    
}

extension CommonVerificationMethodsTestsHelper: InitiationListener, VerificationListener {
    
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

extension CommonVerificationMethodsTestsHelper: HasApply {}
