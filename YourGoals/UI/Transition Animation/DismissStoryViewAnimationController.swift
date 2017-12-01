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
    
    internal var selectedCardMetrics:TransitionAnimationMetrics! = nil
    let origin:TransitionAnimationOrigin
    init(origin: TransitionAnimationOrigin) {
        self.origin = origin
        super.init()
    }
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1 - extract from and to view controllers
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? GoalDetailViewController else {
            assertionFailure("couldn't extract goal detail view controller")
            return
        }
        
        let toView = transitionContext.view(forKey: .to)!
        toView.alpha = 0.0
        containerView.backgroundColor = .white
        
        // 2
        containerView.insertSubview(toView, at: 0)
        
        let constraints = selectedCardMetrics.calculateOriginConstraints(containerFrame: containerView.frame)
        
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.startPointTransitionAnimation(origin: self.origin, selectedCardMetris: self.selectedCardMetrics, constraints: constraints)
            toView.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(true)
            fromViewController.view.removeFromSuperview()
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 10.0
        // return 10.0
    }
}
