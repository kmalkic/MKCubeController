//
//  ViewController.swift
//  MKCubeControllerDemo
//
//  Created by Kevin Malkic on 28/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

import UIKit
import MKCubeController

class ViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	@IBAction func goForward() {
		
        cubeViewController?.scrollForwardAnimated(animated: true)
	}
	
	@IBAction func goBack() {
		
        cubeViewController?.scrollBackAnimated(animated: true)
	}
}

