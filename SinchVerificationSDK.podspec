Pod::Spec.new do |spec|

  spec.name         = "SinchVerificationSDK"
  spec.version      = "3.2.0"
  spec.summary      = "Official Sinch Verification SDK for iOS makes verifying phone numbers easy."
  spec.description  = <<-DESC
  Library allows clients to verify phone numbers via sms, flashcall, callout and seamless methods easly.
                   DESC

  spec.homepage     = "https://www.sinch.com/products/apis/verification/"
  spec.license      = "Apache 2.0"

  spec.author             = { "Aleksander Wójcik" => "aleksander.wojcik@sinch.com" }
  spec.social_media_url   = "https://twitter.com/wearesinch"

  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"
  spec.swift_version = '5.0'

  spec.source       = { :git => "https://github.com/sinch/verification-ios-sdk.git", :tag => "#{spec.version}" }

  spec.source_files  = "Verification/Verification/Classes", "Verification/Verification/Classes/**/*.{h,m,swift}"
  spec.exclude_files = "Verification/Verification/Classes/Exclude"
  
  spec.dependency "Alamofire", "~> 5.2"
  spec.dependency "ReachabilitySwift"
  spec.dependency "PhoneNumberKit", "~> 3.1"
  spec.dependency "CocoaLumberjack/Swift", "~> 3.7.0"

end
