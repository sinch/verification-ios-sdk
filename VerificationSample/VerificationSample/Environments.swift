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
    Environment(domain: "https://verificationapi-v1.sinch.com/", name: "Production", appKey: "9e556452-e462-4006-aab0-8165ca04de66"),
    Environment(domain: "https://verification.api.sinch.com/", name: "Production BROK", appKey: "5d9cfc9-6eb5-4bfa-a081-21a70d99f05c"),
    Environment(domain: "https://verificationapi-v1-01.sinchlab.com/", name: "Ftest1", appKey: "de23e021-db44-4004-902c-5a7fc18e35e2"),
    Environment(domain: "https://ft1-verification.api.sinchlab.com/", name: "Ftest1 BROK", appKey: "970c0fcd-9b75-4d2c-8975-1afad4870ec0"),
    Environment(domain: "https://verificationapi-v1-02.sinchlab.com/", name: "Ftest2", appKey: "d68db53a-45f4-4b92-a9a5-1b253de3dcb8"),
    Environment(domain: "https://ft2-verification.api.sinchlab.com/", name: "Ftest2 BROK", appKey: "d68db53a-45f4-4b92-a9a5-1b253de3dcb8")
]
