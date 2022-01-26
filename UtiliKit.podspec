#
# Be sure to run `pod lib lint UtiliKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'UtiliKit'
s.version          = '1.8.0'
s.summary          = 'All the things you are tired of writing.'

s.description      = <<-DESC
This framework is a collection of subspecs designed to be used to facilitate simpler, cleaner code. These classes and extensions are common cases.
DESC

s.homepage          = 'https://github.com/BottleRocketStudios/iOS-UtiliKit'
s.license           = { :type => 'Apache 2.0', :file => 'LICENSE' }
s.author            = { 'Bottle Rocket Studios' => 'wilson.turner@bottlerocketstudios.com' }
s.source            = { :git => 'https://github.com/bottlerocketstudios/iOS-UtiliKit.git', :tag => s.version.to_s }
s.source_files      = 'Sources/**/*'
s.ios.deployment_target = '10.0'
s.swift_version = '5.5'

s.default_subspec = 'Core'

s.subspec 'Core' do |core|
core.dependency 'UtiliKit/Instantiation'
core.dependency 'UtiliKit/General'
end

s.subspec 'Instantiation' do |instantiation|
instantiation.source_files = 'Sources/Instantiation/*.swift'
end

s.subspec 'TimelessDate' do |timeless|
timeless.source_files = 'Sources/TimelessDate/*.swift'
end

s.subspec 'General' do |general|
general.source_files = 'Sources/General/*.swift'
end

s.subspec 'Version' do |version|
version.source_files = 'Sources/Version/*.swift'
end

s.subspec 'Container' do |container|
container.source_files = 'Sources/Container/**/*.swift'
end

s.subspec 'ActiveLabel' do |activeLabel|
activeLabel.source_files = 'Sources/ActiveLabel/*.swift'
end

s.subspec 'Obfuscation' do |obfuscation|
obfuscation.source_files = 'Sources/Obfuscation/*.swift'
end

s.subspec 'ScrollingPageControl' do |pagecontrol|
pagecontrol.dependency 'UtiliKit/General'
pagecontrol.source_files = 'Sources/ScrollingPageControl/*.swift'
end

end
