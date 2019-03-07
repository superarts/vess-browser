#!/bin/bash

# Example: devops/create-module.sh Browser ViewController UIKit

# TODO: check if under project root directory

printf "Creating module: $1..."

# $1: ModuleName, e.g. HostList
# $2: ModuleType, e.g. ViewController
# $3: DefaultDependency, e.g. UIKit

create_swift_file () {
	printf "import $3\n\n" > VessBrowser/$1/$2/$1$2.swift
}

mkdir VessBrowser/$1
# printf "# $1 Module\n\n$2" > VessBrowser/$1/README.md

mkdir VessBrowser/$1/Storyboard
cp script/EmptyStoryboard.storyboard VessBrowser/$1/Storyboard/$1.storyboard
# printf "# $1Storyboard\n\n$2" > VessBrowser/$1/Storyboard/README.md

mkdir VessBrowser/$1/ViewController
create_swift_file $1 ViewController UIKit
# printf "# $1ViewController\n\n$2" > VessBrowser/$1/ViewController/README.md

mkdir VessBrowser/$1/ViewModel
create_swift_file $1 ViewModel Foundation
# printf "# $1ViewModel\n\n$2" > VessBrowser/$1/ViewModel/README.md

mkdir VessBrowser/$1/Model
create_swift_file $1 Model Foundation
# printf "# $1 Model(s)\n\n$2" > VessBrowser/$1/Model/README.md

mkdir VessBrowser/$1/Manager
create_swift_file $1 Manager Foundation
# printf "# $1 Manager(s)\n\n$2" > VessBrowser/$1/Manager/README.md

# TODO: add module to xcodeproj - https://github.com/CocoaPods/Xcodeproj

echo "Done. Git status:"
git status
open VessBrowser/$1