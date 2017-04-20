//
//  JSPresentAnimator.swift
//  GuideDemo
//
//  Created by Jesson on 2017/4/19.
//  Copyright © 2017年 Jesson. All rights reserved.
//

import UIKit

class JSPresentAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    let duration = 0.4 //动画的时间
    var originFrame = CGRect.zero //点击Cell的frame
    var originVc:UIViewController?
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let finalFrame = toView.frame
//        let xScale = originFrame.size.width/toView.frame.size.width
//        let yScale = originFrame.size.height/toView.frame.size.height
//        toView.transform = CGAffineTransform.init(scaleX: xScale, y: yScale)
//        toView.center = CGPoint.init(x: originFrame.midX, y: originFrame.midY)
        toView.frame.origin.x = originFrame.size.width
        containView.addSubview(toView)
        UIView.animate(withDuration: duration, animations: { () -> Void in
//            toView.center = CGPoint.init(x: finalFrame.midX, y: finalFrame.midY)
//            toView.transform = .identity
//            self.originVc?.view.alpha = 0.8
            self.originVc?.view.frame.origin.x -= finalFrame.size.width
            toView.frame.origin.x = 0
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
}
