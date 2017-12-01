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
        guard let animationBehavior = transitionContext.viewController(forKey: .to) as? TransitionAnimationBehavior else {
            assertionFailure("couldn't locate the animation behavior from the anticipated GoalDetailViewController calss")
            return
        }
        
        // 2 Calculate the constraints.
        
        containerView.addSubview(transitionContext.view(forKey: .to)!)
        let constraints = selectedCardMetrics.calculateOriginConstraints(containerFrame: containerView.frame)
        animationBehavior.startPointTransitionAnimation(origin: self.origin, selectedCardMetris: self.selectedCardMetrics, constraints: constraints)
        
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: { 
            animationBehavior.endPointTransitionAnimation()
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       return 0.3
  //      return 10.0
    }
}
