# Uncomment this line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!

def shared_dependency
	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'RealmSwift'
end

target 'VessBrowser' do
	shared_dependency
end

target 'VessBrowserTests' do
	inherit!  :search_paths
	shared_dependency
end