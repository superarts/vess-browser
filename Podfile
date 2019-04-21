# Uncomment this line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!

def shared_dependency
    # ignore all warnings from all pods
    inhibit_all_warnings!

	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'RealmSwift'
	pod 'Swinject'
	pod 'SDWebImage'
	pod 'SCLAlertView'
	pod 'FavIcon'
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