//
//  SheetFadeAnimator.swift
//  Sheeeeeeeeet
//
//  Created by Gwangbeom on 2018. 9. 26..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

class SheetFadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPush: Bool = true
    var onReady: (() -> Void)?
    var onComplete: (() -> Void)?
    
    private var options: SheetOptions {
        return SheetManager.shared.options
    }
    
    private var animationOption: SheetAnimationOption {
        return SheetManager.shared.animationOption
    }
    
    private var toTopMargin: CGFloat = 0
    private var fromTopMargin: CGFloat = 0

    init(to: CGFloat, from: CGFloat) {
        super.init()
        toTopMargin = to
        fromTopMargin = from
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationOption.pushAnimationItem.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)

        let fromContainer = fromViewController?.view

        let fromContent = fromViewController as? SheetContent
        let toContent = toViewController as? SheetContent
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = SheetManager.shared.options.sheetBackgroundColor
        
        backgroundView.layer.cornerRadius = options.cornerRadius
        backgroundView.frame = CGRect(x: 0, y: fromTopMargin, width: containerView.bounds.width, height: containerView.bounds.height)
        containerView.insertSubview(backgroundView, at: 0)
        
        let toView = transitionContext.view(forKey: .to) ?? UIView()
        toView.alpha = 0
        containerView.addSubview(toView)

        let diff = fromTopMargin - toTopMargin

        var toLayoutTopMargin: CGFloat = 0
        if let toSheetContentViewController = toViewController as? SheetContentsViewController {
            let toLayout = toSheetContentViewController.collectionView.collectionViewLayout as? SheetContentsLayout
            toLayoutTopMargin = toLayout?.settings.topMargin ?? 0
            toContent?.contentScrollView.contentOffset.y = isPush ? -diff : toLayoutTopMargin - fromTopMargin
        } else {
            toView.transform = CGAffineTransform.init(translationX: 0, y: isPush ? diff : -toLayoutTopMargin + fromTopMargin)
//            toContent?.contentScrollView.contentOffset.y = isPush ? -diff : toLayoutTopMargin - fromTopMargin
        }

//        toContent?.contentScrollView.contentOffset.y = isPush ? -diff : toLayoutTopMargin - fromTopMargin

        onReady?()
        
        UIView.animate(withDuration: animationOption.pushAnimationItem.duration, delay: 0, usingSpringWithDamping: animationOption.pushAnimationItem.springDumping, initialSpringVelocity: animationOption.pushAnimationItem.initialSpringVelocity, options: animationOption.pushAnimationItem.options, animations: {
            fromContainer?.alpha = 0
            if fromViewController is SheetContentsViewController {
                fromContent?.contentScrollView.contentOffset.y += diff
            } else {
                fromViewController?.view.transform = CGAffineTransform.init(translationX: 0, y: -diff)
            }
            
            
            backgroundView.frame = CGRect(x: 0, y: self.toTopMargin, width: containerView.bounds.width, height: containerView.bounds.height)

            toView.alpha = 1
            
            if toViewController is SheetContentsViewController {
                toContent?.contentScrollView.contentOffset.y = self.isPush ? 0 : toLayoutTopMargin - self.toTopMargin
            } else {
                toView.transform = .identity
            }
            
        }) { _ in
            self.onComplete?()
            backgroundView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
