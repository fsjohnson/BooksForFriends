# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'BookClubUpdated' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Bolts'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'

  platform :ios, '8.0'
  pod 'SDWebImage', '~>3.8'
  use_frameworks!
  pod 'DropDown'

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
