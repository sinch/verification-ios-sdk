//
//  MockedVerificationMethod.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 12/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

@testable import Verification

class MockedVerificationMethod: VerificationMethod {
    
    var numberOfOnVerifyCalls = 0
    var numberOfOnInitiateCalls = 0
    
    var wasOnInitiateCalled: Bool {
        return numberOfOnInitiateCalls > 0
    }

    var wasOnVerifyCalled: Bool {
        return numberOfOnVerifyCalls > 0
    }
    
    var source: VerificationSourceType? = nil
    
    static func instanceForTests(
        withInitListener initListener: InitiationListener? = nil,
        verificationListener: VerificationListener? = nil) -> MockedVerificationMethod {
        let globalConfig = SinchGlobalConfig.Builder.instance().authorizationMethod(AppKeyAuthorizationMethod(appKey: "")).build()
        return MockedVerificationMethod(
            verificationMethodConfig: VerificationMethodConfiguration(globalConfig: globalConfig, number: ""),
            initiationListener: initListener,
            verificationListener: verificationListener
        )
    }
    
    override func onInitiate() {
        numberOfOnInitiateCalls += 1
    }
    
    override func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType, usingMethod method: VerificationMethodType?) {
        numberOfOnVerifyCalls += 1
        source = sourceType
    }
    
}
