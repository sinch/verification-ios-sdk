# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

# Uncomment this line if you're using Swift
#use_frameworks!

workspace 'verification-ios-sdk'
project 'VerificationSample/VerificationSample.xcodeproj'
project 'VerificationCore/VerificationCore.xcodeproj'
project 'VerificationSms/VerificationSms.xcodeproj'

#def controller_pods
#pod 'Reachability'
#end

target 'VerificationSample' do
  project 'VerificationSample/VerificationSample.xcodeproj'
end

target 'VerificationSms' do
  project 'VerificationSms/VerificationSms.xcodeproj'
end

target 'VerificationCore' do
  project 'VerificationCore/VerificationCore.xcodeproj'
  pod 'Alamofire', '~> 5.2'
  
  target 'VerificationCoreTests' do
      inherit! :search_paths
  end
  
end
