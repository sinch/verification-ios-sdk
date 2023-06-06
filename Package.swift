// swift-tools-version:5.8

import PackageDescription
let package = Package(
    name: "SinchVerificationSDK",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.4")),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.8.0"),
    ],
    products: [
        .library(name: "Verification", targets: ["Verification"])
    ],
    targets: [
        .target(name: "Verification", dependencies: ["Alamofire", "CocoaLumberjack"], path: "Verification/Verification/Classes"),
    ]
 )
