# MKCubeController

MKCubeController is used to create a rotating 3D cube navigation in Swift 2.1. (translated from @nicklockwood CubeController)
here the link https://github.com/nicklockwood/CubeController
Pretty much the same logic.


## Requirements
- iOS 8.0+
- Xcode 7.2+

## Usage
Pretty easy !
```swift
let controller = MKCubeViewController()
controller.dataSource = self
controller.wrapEnabled = true
```

And implement MKCubeViewControllerDataSource
```swift
func numberOfViewControllersInCubeController(cubeController: MKCubeViewController) -> Int {
	
	return 3
}

func cubeController(cubeController: MKCubeViewController, viewControllerAtIndex index: Int) -> UIViewController {
	
	switch index % 3 {
	
	case 0:
		return ViewController(nibName: "RedViewController", bundle: nil)
		
	case 1:
		return ViewController(nibName: "GreenViewController", bundle: nil)
		
	case 2:
		return ViewController(nibName: "BlueViewController", bundle: nil)
		
	default:
		break

	}
	
	return ViewController()
}
```

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8.**

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build MKCubeController 1.0.2+.

To integrate MKCubeController into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'MKCubeController', '~> 1.0.2'
```

Then, run the following command:

```bash
$ pod install
```

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add MKCubeController as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/kmalkic/MKCubeController.git
```

- Open the new `MKCubeController` folder, and drag the `MKCubeController.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `MKCubeController.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `MKCubeController.xcodeproj` folders each with two different versions of the `MKCubeController.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `MKCubeController.framework`. 
    
- And that's it!

> The `MKCubeController.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

---

## Credits

Kevin Malkic

## License

MKCubeController is released under the MIT license. See LICENSE for details.