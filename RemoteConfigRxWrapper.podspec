#
# Be sure to run `pod lib lint RemoteConfigRxWrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RemoteConfigRxWrapper'
  s.version          = '0.2.0'
  s.summary          = 'Rx wrapper around Firebase Remoteconfig.'
  
  s.description      = <<-DESC
  Rx wrapper around Firebase Remoteconifg.
  Built to get values as observables and update them automatically.
  DESC
  
  s.homepage         = 'https://github.com/markusmattfolkstenberg/RemoteConfigRxWrapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Markus Mattfolk Stenberg' => 'markusstenberg@gmail.com' }
  s.source           = { :git => 'https://github.com/markusmattfolkstenberg/RemoteConfigRxWrapper.git', :tag => s.version.to_s }
  s.static_framework = true
  
  s.cocoapods_version = '>= 1.5.3'
  s.swift_version = '4.0'
  s.ios.deployment_target = '10.3'
  
  s.dependency 'RxSwift', '~> 4'
  s.dependency 'FirebaseRemoteConfig', '~> 3.0.1'
  s.ios.deployment_target = '10.3'
  
  s.source_files = 'RemoteConfigRxWrapper/Classes/**/*'
end
