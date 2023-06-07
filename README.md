# Sinch Verification iOS SDK

Welcome to Sinch Verification iOS SDK

Verify phone numbers and users in iOS. The Verification SDK supports the verification of phone numbers via SMS or flash calls. The SDK is also available for Android.

  - Verification of phone numbers via SMS, callout, flashcall and seamlessly.
  - Simple authentication scheme to get started quickly.

# Installation

1. Register a Sinch Developer account [here](https://portal.sinch.com/#/signup).
2. Set up a new Application using the Dashboard where you can then obtain an Application Key.
3. Enable Verification for the application by selecting: Authentication > Public under App > Settings > Verification
4. Add SinchVerificationSDK to your project.


## Adding with CocoaPods

Add below line to your Podfile

```
pod 'SinchVerificationSDK'
```

## Adding with Swift Package Manager

Add SinchVerificationSDK as depenency either with xCode UI or by defining it in your 'Package.swift' file as:

```
 dependencies: [
    .package(url: "https://github.com/sinch/verification-ios-sdk.git", .upToNextMajor(from: "3.3.0"))
]
```

# Documentation
The User Guide is available at [Sinch Portal](https://developers.sinch.com/docs/verification-for-ios)

## License
[APACHE LICENSE, VERSION 2.0](https://www.apache.org/licenses/LICENSE-2.0)
