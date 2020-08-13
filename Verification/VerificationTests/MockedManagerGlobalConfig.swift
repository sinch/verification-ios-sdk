//
//  MockedManagerGlobalConfig.swift
//  VerificationTests
//
//  Created by Aleksander Wojcik on 13/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

@testable import Verification
import Mocker

extension SinchGlobalConfig {
    
    static func mockedManagerInstance() -> SinchGlobalConfig {
        return SinchGlobalConfig(apiManager: ApiManager(
            authMethod: AppKeyAuthorizationMethod(appKey: ""),
            protocolClass: MockingURLProtocol.self)
        )
    }
    
}
