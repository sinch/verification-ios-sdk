// swift-tools-version:5.8

import PackageDescription
let package = Package(
    name: "Verification",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "Verification", targets: ["Verification"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.4")),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", .upToNextMajor(from: "3.4.0")),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(name: "Verification", dependencies: ["Alamofire", "PhoneNumberKit", "SwiftyBeaver"], path: "Verification/Verification/Classes"),
    ]
 )
