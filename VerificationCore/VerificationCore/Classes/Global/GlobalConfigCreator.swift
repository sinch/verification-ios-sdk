//
//  GlobalConfigCreator.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation

public protocol GlobalConfigCreator {
    func build() -> SinchGlobalConfig
}
