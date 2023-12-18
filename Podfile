# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Roka' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Roka
pod 'IQKeyboardManagerSwift'
pod 'Alamofire'
pod 'MBProgressHUD'
pod 'SDWebImage'
pod 'SVProgressHUD'
pod 'SwiftMessages'
pod 'CountryPickerView'
pod 'GooglePlaces'
pod 'Firebase/Analytics'
pod 'Firebase/Core'
pod 'Firebase/Crashlytics'

pod 'Firebase/Messaging'
pod 'Firebase/Auth'
pod 'FirebaseDatabase'
pod 'FirebaseFirestore'
pod 'CodableFirebase'
pod 'FMDB'

pod 'CryptoSwift', '~> 1.3.8'
pod 'TagListView'
pod "ASPVideoPlayer"
pod 'Swifter', :git => 'https://github.com/mattdonnelly/Swifter.git'

pod 'SKPhotoBrowser'

pod 'IronSourceSDK'
pod "Koloda"

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
        config.build_settings["DEVELOPMENT_TEAM"] = "XW7G622GLT"

      end
    end
  end
end
