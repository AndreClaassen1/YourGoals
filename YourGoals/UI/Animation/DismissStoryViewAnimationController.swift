//
//  DismissStoryViewAnimationController.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/18/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import Foundation

import UIKit

internal class DismissStoryViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    internal var selectedCardFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1 - extract from and to view controllers
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? GoalDetailViewController else {
            assertionFailure("couldn't extract goal detail view controller")
            return
        }
        
        guard let navigationController = transitionContext.viewController(forKey: .to) as? UINavigationController else {
            assertionFailure("couldn't extract navigation view controller")
            return
        }
        
        guard let tabbarController = navigationController.viewControllers[0] as? UITabBarController else {
            assertionFailure("couldn't extract tabbar controller")
            return
        }
        
        guard let toViewController = tabbarController.viewControllers?[1] as? GoalsViewController else {
            assertionFailure("couldn't extract goals view controller")
            return
        }
        
        
        // 2
        toViewController.view.isHidden = true
        containerView.addSubview(navigationController.view)
        
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.positionContainer(left: 20.0,
                                                 right: 20.0,
                                                 top: self.selectedCardFrame.origin.y + 20.0,
                                                 bottom: 0.0)
//            fromViewController.setHeaderHeight(self.selectedCardFrame.size.height - 40.0)
//            fromViewController.configureRoundedCorners(shouldRound: true)
        }) { (_) in
            toViewController.view.isHidden = false
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
}
