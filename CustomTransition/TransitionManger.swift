//
//  TransitionManger.swift
//  CustomTransition
//
//  Created by Colin Dunn on 3/14/15.
//  Copyright (c) 2015 Colin Dunn. All rights reserved.
//

import UIKit

class TransitionManger: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning {
    
    var isPresenting = false
    var interactiveTransition = UIPercentDrivenInteractiveTransition()
    var presentingController: UIViewController! {
        didSet {
            self.panGesture = UIPanGestureRecognizer(target: self, action: "onPan:")
            self.presentingController.view.addGestureRecognizer(self.panGesture)
        }
    }
    
    private var isInteractive = false
    private var panGesture = UIPanGestureRecognizer()
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let frame = panGesture.view!.frame.size
        let offScreenLeft = CGAffineTransformMakeTranslation(-frame.width, 0)
        let offScreenRight = CGAffineTransformMakeTranslation(frame.width, 0)
        
        if isPresenting {
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            toViewController?.view.transform = offScreenRight
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                toViewController?.view.transform = CGAffineTransformMakeTranslation(0, 0)
                fromViewController?.view.transform = offScreenLeft
                
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
            }
        } else {
            containerView.addSubview(toViewController!.view)
            containerView.addSubview(fromViewController!.view)
            toViewController?.view.transform = offScreenLeft
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                fromViewController?.view.transform = offScreenRight
                toViewController?.view.transform = CGAffineTransformMakeTranslation(0, 0)
                
                }) { (finished: Bool) -> Void in
                    if transitionContext.transitionWasCancelled() {
                        transitionContext.completeTransition(false)
                    } else {
                        transitionContext.completeTransition(true)
                        fromViewController?.view.removeFromSuperview()
                    }
            }
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self : nil
    }
    
    func onPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(sender.view!)
        let percentPanned = translation.x / sender.view!.frame.size.width
        
        switch (sender.state) {
        case UIGestureRecognizerState.Began:
            isInteractive = true
            presentingController.dismissViewControllerAnimated(true, completion: nil)
            break
            
        case UIGestureRecognizerState.Changed:
            updateInteractiveTransition(percentPanned)
            break
            
        default:
            if percentPanned > 0.25 {
                isInteractive = false
                finishInteractiveTransition()
            } else {
                cancelInteractiveTransition()
            }
        }
    }
}
