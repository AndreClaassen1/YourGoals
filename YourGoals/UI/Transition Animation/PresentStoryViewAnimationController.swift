//
//  StoryViewAnimationController.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/17/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

internal class PresentStoryViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    internal var selectedCardMetrics:TransitionAnimationMetrics! = nil
    
    let origin:TransitionAnimationOrigin
    
    init(origin: TransitionAnimationOrigin) {
        self.origin = origin
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to) as? GoalDetailAnimationBehavior else {
            // assertionFailure("couldn't locate apropriate controller")
            return
        }
        
        // 2 Calculate the constraints.
        
        let constraints = selectedCardMetrics.calculateOriginConstraints(containerFrame: containerView.frame)
        
        containerView.addSubview(toViewController.view)
        
        if origin == .fromMiniCell {
            toViewController.configureDescriptionItems(shouldBeVisible: false)
        }
        toViewController.positionContainer(constraints: constraints)
        toViewController.setHeaderHeight(selectedCardMetrics.selectedFrame.size.height)
        toViewController.configureRoundedCorners(radius: selectedCardMetrics.cornerRadius)
        toViewController.setTaskViewAlpha(0.0)
        //
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: { 
            toViewController.positionContainer(constraints: TransitionAnimationConstraints.zero)
            toViewController.setHeaderHeight(320)
            toViewController.view.backgroundColor = .white
            toViewController.configureRoundedCorners(radius: 0.0)
            toViewController.setTaskViewAlpha(1.0)
        }) { (_) in
            toViewController.configureDescriptionItems(shouldBeVisible: true)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       return 0.3
 //       return 10.0
    }
}
