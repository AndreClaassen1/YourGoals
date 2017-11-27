//
//  StoryViewAnimationController.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/17/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

internal class PresentStoryViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    internal var selectedCardFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        let containerView = transitionContext.containerView
        guard let _ = transitionContext.viewController(forKey: .from),
        let toViewController = transitionContext.viewController(forKey: .to) as? GoalDetailViewController else {
            // assertionFailure("couldn't locate apropriate controller")
            return
        }
        
        // 2
        
        
        let imageFrame = selectedCardFrame.insetBy(dx: 20.0, dy: 20.0)
        containerView.addSubview(toViewController.view)
        toViewController.positionContainer(left: 20.0,
                                           right: 20.0,
                                           top: imageFrame.origin.y,
                                           bottom: 0.0)
        toViewController.setHeaderHeight(imageFrame.size.height)
        toViewController.configureRoundedCorners(shouldRound: true)
        toViewController.setTaskViewAlpha(0.0)
        //
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: { 
            toViewController.positionContainer(left: 0.0,
                                               right: 0.0,
                                               top: 0.0,
                                               bottom: 0.0)
            toViewController.setHeaderHeight(320)
            toViewController.view.backgroundColor = .white
            toViewController.configureRoundedCorners(shouldRound: false)
            toViewController.setTaskViewAlpha(1.0)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
}
