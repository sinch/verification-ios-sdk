//
//  GlobalConfigCreator.swift
//  Verification
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire

public protocol GlobalConfigCreator {
    func interceptors(_ interceptors: [RequestInterceptor]) -> GlobalConfigCreator
    func build() -> SinchGlobalConfig
}
