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
        
        containerView.addSubview(toViewController.view)
        let constraints = selectedCardMetrics.calculateOriginConstraints(containerFrame: containerView.frame)
        toViewController.startPointTransitionAnimation(origin: self.origin, selectedCardMetris: self.selectedCardMetrics, constraints: constraints)
        
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: { 
            toViewController.endPointTransitionAnimation(origin: self.origin)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       return 0.3
  //      return 10.0
    }
}
