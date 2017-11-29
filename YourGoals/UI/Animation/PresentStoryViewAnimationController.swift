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
    
    let origin:AnimationControllerOrigin
    
    init(origin: AnimationControllerOrigin) {
        self.origin = origin
        super.init()
    }
    
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
        var innerMargin:CGFloat = 0.0
        var radius:CGFloat = 0.0
        switch self.origin {
        case .fromLargeCell:
            radius = 14.0
            innerMargin = 20.0
        case .fromMiniCell:
            innerMargin = 8.0
            radius = 4.0
        }
        
        let imageFrame = selectedCardFrame.insetBy(dx: innerMargin, dy: innerMargin)
        let left = imageFrame.origin.x
        let right = containerView.frame.width - (imageFrame.origin.x + imageFrame.width)
        
        containerView.addSubview(toViewController.view)
        
        if origin == .fromMiniCell {
            toViewController.configureDescriptionItems(shouldBeVisible: false)
        }
        toViewController.positionContainer(left: left,
                                           right: right,
                                           top: imageFrame.origin.y - 15.0,
                                           bottom: -imageFrame.origin.y)
        toViewController.setHeaderHeight(imageFrame.size.height)
        toViewController.configureRoundedCorners(radius: radius)
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
            toViewController.configureRoundedCorners(radius: 0.0)
            toViewController.setTaskViewAlpha(1.0)
        }) { (_) in
            toViewController.configureDescriptionItems(shouldBeVisible: true)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
}
