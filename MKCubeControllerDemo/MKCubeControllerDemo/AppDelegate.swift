//
//  AppDelegate.swift
//  MKCubeControllerDemo
//
//  Created by Kevin Malkic on 28/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

import UIKit
import MKCubeController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MKCubeViewControllerDataSource {

	var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let controller = MKCubeViewController()
        controller.dataSource = self
        controller.wrapEnabled = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = controller
        window!.makeKeyAndVisible()
        
        return true
    }
    
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
}

