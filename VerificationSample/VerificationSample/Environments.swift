//
//  Environments.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 17/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation

struct Environment: Equatable {
    let domain: String
    let name: String
    let appKey: String
}

let Environments: [Environment] = [
    Environment(domain: "https://verification.api.sinch.com/", name: "Production", appKey: "***"),
    Environment(domain: "https://verification.api.sinch.com/", name: "Production BROK", appKey: "***"),
    Environment(domain: "https://dc-aps1-std.verification.api.sinch.com/", name: "APS1", appKey: "***"),
    Environment(domain: "https://verificationapi-v1-01.sinchlab.com/", name: "Ftest1", appKey: "***"),
    Environment(domain: "https://ft1-verification.api.sinchlab.com/", name: "Ftest1 BROK", appKey: "***"),
    Environment(domain: "https://verificationapi-v1-02.sinchlab.com/", name: "Ftest2", appKey: "***"),
    Environment(domain: "https://ft2-verification.api.sinchlab.com/", name: "Ftest2 BROK", appKey: "*** ")
]
