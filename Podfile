# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

# Uncomment this line if you're using Swift
use_frameworks!

workspace 'verification-ios-sdk'
project 'VerificationSample/VerificationSample.xcodeproj'
project 'Verification/Verification.xcodeproj'

def verification_pods
  pod 'Alamofire', '~> 5.2'
  pod 'ReachabilitySwift'
  pod 'PhoneNumberKit', '~> 3.1'
end

target 'VerificationSample' do
  project 'VerificationSample/VerificationSample.xcodeproj'
  verification_pods
end
  
target 'Verification' do
  project 'Verification/Verification.xcodeproj'
  target 'VerificationTests' do
      inherit! :complete
      pod 'Mocker', '~> 2.2.0'
  end
  
end
