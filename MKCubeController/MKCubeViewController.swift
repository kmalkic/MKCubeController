//
//  MKCubeViewController.swift
//  MKCubeController
//
//  Created by Kevin Malkic on 27/01/2016.
//  Copyright © 2016 Kevin Malkic. All rights reserved.
//

import UIKit

public protocol MKCubeViewControllerDataSource: NSObjectProtocol {

    func numberOfViewControllersInCubeController(cubeController: MKCubeViewController) -> Int
    func cubeController(cubeController: MKCubeViewController, viewControllerAtIndex index: Int) -> UIViewController
}

@objc public protocol MKCubeViewControllerDelegate: NSObjectProtocol {
    
    @objc optional func cubeControllerDidScroll(cubeController: MKCubeViewController)
    @objc optional func cubeControllerCurrentViewControllerIndexWillChange(cubeController: MKCubeViewController)
    @objc optional func cubeControllerCurrentViewControllerIndexDidChange(cubeController: MKCubeViewController)
    @objc optional func cubeControllerWillBeginDragging(cubeController: MKCubeViewController)
    @objc optional func cubeControllerDidEndDragging(cubeController: MKCubeViewController, willDecelerate decelerate: Bool)
    @objc optional func cubeControllerWillBeginDecelerating(cubeController: MKCubeViewController)
    @objc optional func cubeControllerDidEndDecelerating(cubeController: MKCubeViewController)
    @objc optional func cubeControllerDidEndScrollingAnimation(cubeController: MKCubeViewController)
}

public class MKCubeViewController: UIViewController, UIScrollViewDelegate {

    public weak var dataSource: MKCubeViewControllerDataSource?
    public weak var delegate: MKCubeViewControllerDelegate?
    
    private var controllers = [Int: UIViewController]()
    private var scrollOffset: CGFloat = 0
    private var previousOffset: CGFloat = 0
    private var suppressScrollEvent: Bool = false
    
    public lazy var scrollView: UIScrollView = {
    
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.autoresizesSubviews = false
        scrollView.delegate = self
        
        return scrollView
    }()
    
    private(set) public var numberOfViewControllers: Int = 0
	
    private(set) public var currentViewControllerIndex: Int = 0
	
	public func setCurrentIndex(index: Int) {
		
		currentViewControllerIndex = index
        scrollToViewControllerAtIndex(index: currentViewControllerIndex, animated: false)
	}
	
    public var wrapEnabled: Bool = false {
    
        didSet {
        
            view.layoutIfNeeded()
        }
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
		
        view.addSubview(scrollView)
        
        reloadData()
    }
    
    public override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
		
		scrollView.frame = view.bounds
		
        var pages = CGFloat(numberOfViewControllers)
        
        if wrapEnabled && numberOfViewControllers > 1 {
            
            pages += 2
        }
        
        suppressScrollEvent = true
        scrollView.contentSize = CGSize(width: view.bounds.width * pages, height: view.bounds.height)
        suppressScrollEvent = false
        
        updateContentOffset()
        loadUnloadControllers()
        updateLayout()
        updateInteraction()
    }
    
    public func reloadViewControllerAtIndex(index: Int, animated: Bool) {
        
        if let controller = controllers[index] {
            
            let transform: CATransform3D = controller.view.layer.transform
            
            let center: CGPoint = controller.view.center
            
            if animated {
                
                let animation: CATransition = CATransition()
                animation.type = kCATransitionFade
                scrollView.layer.add(animation, forKey: nil)
            }
            
            controller.view!.removeFromSuperview()
            controller.removeFromParentViewController()
            
            if let newController = dataSource?.cubeController(cubeController: self, viewControllerAtIndex: index) {
                
                controllers[index] = newController
                newController.view.layer.isDoubleSided = false
                
                addChildViewController(newController)
                scrollView.addSubview(newController.view!)
                
                newController.view.layer.transform = transform
                newController.view.center = center
                
                newController.view.isUserInteractionEnabled = (index == currentViewControllerIndex)
            }
        }
    }
    
    public func scrollToViewControllerAtIndex(index: Int, animated: Bool) {
        
        var offset = index
        
        if wrapEnabled {
            
            //using > here instead of >= may look like a fencepost bug, but it isn't
            if offset > numberOfViewControllers {
                
                offset = Int(offset) % numberOfViewControllers
            }
            
            offset = max(-1, offset) + 1
            
        } else if animated && scrollView.bounces {
            
            offset = Int( max(-0.1, min( CGFloat(offset), CGFloat(numberOfViewControllers) - 0.9)))
            
        } else {
            
            offset = max(0, min(offset, numberOfViewControllers - 1))
        }
        
        scrollView.setContentOffset(CGPoint(x: view.bounds.width * CGFloat(offset), y: 0), animated: animated)
    }
    
    public func scrollForwardAnimated(animated: Bool) {
        
        scrollToViewControllerAtIndex(index: currentViewControllerIndex + 1, animated: animated)
    }
    
    public func scrollBackAnimated(animated: Bool) {
        
        scrollToViewControllerAtIndex(index: currentViewControllerIndex - 1, animated: animated)
    }
    
    public func reloadData() {
        
        for (_, controller) in controllers {
        
            controller.viewWillDisappear(false)
            controller.view!.removeFromSuperview()
            controller.removeFromParentViewController()
            controller.viewDidDisappear(false)
        }
        
        controllers.removeAll()
        numberOfViewControllers = dataSource?.numberOfViewControllersInCubeController(cubeController: self) ?? 0
        view.layoutIfNeeded()
    }
    
    // MARK: private
    
    private func updateContentOffset() {
        
        var offset: CGFloat = scrollOffset
        
        if wrapEnabled && numberOfViewControllers > 1 {
            
            offset += 1.0
            
            while offset < 1.0 {
                
                offset += 1
            }
            
            while offset >= CGFloat(numberOfViewControllers) + 1 {
                
                offset -= CGFloat(numberOfViewControllers)
            }
        }
        
        previousOffset = offset
        suppressScrollEvent = true
        scrollView.contentOffset = CGPoint(x: view.bounds.width * offset, y: 0.0)
        suppressScrollEvent = false
    }
    
    private func updateLayout() {
        
        for (index, controller) in controllers {
            
            if controller.parent == nil {
                
                controller.view.autoresizingMask = []
                controller.view.layer.isDoubleSided = false
                addChildViewController(controller)
                scrollView.addSubview(controller.view)
            }
            
            var angle: Double = Double(scrollOffset - CGFloat(index)) * (.pi / 2)
            
            while angle < 0 {
                
                angle += .pi * 2
            }
            while angle > .pi * 2 {
                
                angle -= .pi * 2
            }
            
            var transform: CATransform3D = CATransform3DIdentity
            
            if angle != 0.0 {
                
                transform.m34 = -1.0 / 500
                transform = CATransform3DTranslate(transform, 0, 0, -view.bounds.size.width / 2.0)
                transform = CATransform3DRotate(transform, -CGFloat(angle), 0, 1, 0)
                transform = CATransform3DTranslate(transform, 0, 0, view.bounds.size.width / 2.0)
            }
            
            var contentOffset = CGPoint.zero
            
            if let controllerScrollView = controller.view as? UIScrollView {
                
                contentOffset = controllerScrollView.contentOffset
            }
            
            controller.view.bounds = view.bounds
            
            controller.view.center = CGPoint(x: view.bounds.size.width / 2.0 + scrollView.contentOffset.x, y: view.bounds.size.height / 2.0)
            
            controller.view.layer.transform = transform
            
            if let controllerScrollView = controller.view as? UIScrollView {
                
                controllerScrollView.contentOffset = contentOffset
            }
        }
    }
    
    private func loadUnloadControllers() {
        
        //calculate visible indices
        var visibleIndices = Set<Int>()
        visibleIndices.insert(currentViewControllerIndex)
		
        if wrapEnabled || currentViewControllerIndex < numberOfViewControllers - 1 {
            
            visibleIndices.insert(currentViewControllerIndex + 1)
        }
        
        if currentViewControllerIndex > 0 {
            
            visibleIndices.insert(currentViewControllerIndex - 1)
            
        } else if wrapEnabled {
            
            visibleIndices.insert(-1)
        }
        
        let copy = controllers
        
        //remove hidden controllers
        for (index, controller) in copy {
            
            if !visibleIndices.contains(index) {
                
                controller.view!.removeFromSuperview()
                controller.removeFromParentViewController()
                controllers.removeValue(forKey: index)
            }
        }
        
        //load controllers
        for index in visibleIndices {
            
            let controller = controllers[index]
            
            if controller == nil {
            
                if numberOfViewControllers > 0 {
                    
                    if let newController = dataSource?.cubeController(cubeController: self, viewControllerAtIndex: (index + numberOfViewControllers) % numberOfViewControllers) {
                        
                        controllers[index] = newController
                    }
                }
            }
        }
    }
    
    private func updateInteraction() {
        
        for (index, controller) in controllers {
            
            controller.view.isUserInteractionEnabled = (index == currentViewControllerIndex)
        }
    }
    
    //MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !suppressScrollEvent {
            
            //update scroll offset
            let offset = scrollView.contentOffset.x / view.bounds.width
            
            scrollOffset += (offset - previousOffset)
            
            if wrapEnabled {
                
                while scrollOffset < 0.0 {
                    
                    scrollOffset += CGFloat(numberOfViewControllers)
                }
                
                while scrollOffset >= CGFloat(numberOfViewControllers) {
                    
                    scrollOffset -= CGFloat(numberOfViewControllers)
                }
            }
            
            previousOffset = offset
            
            //prevent error accumulation
            if offset - floor(offset) == 0.0 {
                
                scrollOffset = round(scrollOffset)
            }
            
            //update index
            let previousViewControllerIndex = currentViewControllerIndex
            
            currentViewControllerIndex = max(0, min(numberOfViewControllers - 1, Int(round(scrollOffset))))
            
            //update content
            updateContentOffset()
            loadUnloadControllers()
            updateLayout()
            
            //update delegate
            delegate?.cubeControllerDidScroll?(cubeController: self)
            
            if currentViewControllerIndex != previousViewControllerIndex {
                
                delegate?.cubeControllerCurrentViewControllerIndexWillChange?(cubeController: self)
            }
            
            //enable/disable interaction
            updateInteraction()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if !suppressScrollEvent {
            
            delegate?.cubeControllerWillBeginDragging?(cubeController: self)
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !suppressScrollEvent {
            
            delegate?.cubeControllerDidEndDragging?(cubeController: self, willDecelerate: decelerate)
			
			if !decelerate {
				
                delegate?.cubeControllerCurrentViewControllerIndexDidChange?(cubeController: self)
			}
        }
    }
	
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if !suppressScrollEvent {
            
            delegate?.cubeControllerWillBeginDecelerating?(cubeController: self)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if !suppressScrollEvent {
            
            delegate?.cubeControllerDidEndDecelerating?(cubeController: self)
			
            delegate?.cubeControllerCurrentViewControllerIndexDidChange?(cubeController: self)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let nearestIntegralOffset = round(scrollOffset)
        
        if abs(scrollOffset - nearestIntegralOffset) > 0.0 {
            
            scrollToViewControllerAtIndex(index: currentViewControllerIndex, animated: true)
        }
        
        if !suppressScrollEvent {
            
            delegate?.cubeControllerDidEndScrollingAnimation?(cubeController: self)
			
            delegate?.cubeControllerCurrentViewControllerIndexDidChange?(cubeController: self)
        }
    }
}


