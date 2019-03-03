# Uncomment this line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!

def shared_dependency
	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'RealmSwift'
	pod 'Swinject'
	pod 'SDWebImage'
	pod 'SCLAlertView'
end

target 'VessBrowser' do
	shared_dependency
end

target 'VessBrowserTests' do
	inherit!  :search_paths
	shared_dependency
	pod 'Quick'
	pod 'Nimble'
end