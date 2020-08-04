# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

# Uncomment this line if you're using Swift
use_frameworks!

workspace 'verification-ios-sdk'
project 'VerificationSample/VerificationSample.xcodeproj'
project 'VerificationCore/VerificationCore.xcodeproj'
project 'VerificationSms/VerificationSms.xcodeproj'
project 'MetadataCollector/MetadataCollector.xcodeproj'

def verification_pods
  pod 'Alamofire', '~> 5.2'
  pod 'ReachabilitySwift'
end

target 'VerificationSample' do
  project 'VerificationSample/VerificationSample.xcodeproj'
  verification_pods
end

target 'VerificationSms' do
  project 'VerificationSms/VerificationSms.xcodeproj'
  verification_pods
  
  target 'VerificationSmsTests' do
      inherit! :complete
  end
end

target 'VerificationFlashcall' do
  project 'VerificationFlashcall/VerificationFlashcall.xcodeproj'
  verification_pods
  
  target 'VerificationFlashcallTests' do
      inherit! :complete
  end
end

target 'VerificationCallout' do
  project 'VerificationCallout/VerificationCallout.xcodeproj'
  verification_pods
  
  target 'VerificationCalloutTests' do
      inherit! :complete
  end
end

target 'VerificationCore' do
  project 'VerificationCore/VerificationCore.xcodeproj'
  verification_pods
  
  target 'VerificationCoreTests' do
      inherit! :complete
  end
end
  
target 'MetadataCollector' do
  project 'MetadataCollector/MetadataCollector.xcodeproj'
  verification_pods
  
  target 'MetadataCollectorTests' do
      inherit! :complete
  end
end
  
target 'VerificationAll' do
  project 'VerificationAll/VerificationAll.xcodeproj'
  
  target 'VerificationAllTests' do
      inherit! :complete
  end
  
end
