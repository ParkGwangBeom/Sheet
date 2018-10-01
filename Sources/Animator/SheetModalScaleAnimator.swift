//
//  SheetModalScaleAnimator.swift
//  Sheeeeeeeeet
//
//  Created by NAVER on 2018. 9. 30..
//  Copyright © 2018년 GwangBeom. All rights reserved.
//

import UIKit

class SheetModalScaleAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var present = true
    
    init(present: Bool) {
        super.init()
        self.present = present
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.viewController(forKey: .from)?.view

        let toView = transitionContext.view(forKey: .to)
        toView?.frame = containerView.bounds
        containerView.addSubview(toView!)
        
        UIView.animate(withDuration: 0.2, animations: {
            fromView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
