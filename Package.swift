// swift-tools-version:5.8

import PackageDescription
let package = Package(
    name: "SinchVerificationSDK",
    products: [
        .library(name: "Verification", targets: ["Verification"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.4")),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.8.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.4.0"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0")
    ],
    targets: [
        .target(name: "Verification", dependencies: ["Alamofire", "CocoaLumberjack", "PhoneNumberKit", "Reachability.swift"], path: "Verification/Verification/Classes"),
    ]
 )
