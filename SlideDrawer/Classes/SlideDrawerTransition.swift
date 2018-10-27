//
//  SlideDrawerTransition.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/27.
//  Copyright © 2018年 gxy. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit

enum SlideDrawerTransitionType {
    case appear
    case disappear
}

protocol SlideDrawerTransitionable {
    var transitionType: SlideDrawerTransitionType { get set }
    var configuration: SlideDrawerConfiguration { get set }
}

class SlideDrawerTransition: NSObject, SlideDrawerTransitionable {
    internal var transitionType: SlideDrawerTransitionType
    internal var configuration: SlideDrawerConfiguration
    private var backgroundImageView: UIImageView?

    init(transitionType: SlideDrawerTransitionType, configuration: SlideDrawerConfiguration) {
        self.transitionType = transitionType
        self.configuration = configuration
    }

    private func appearTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch configuration.animationType {
        case .push:
            pushAnimation(using: transitionContext)
        case .zoom:
            zoomAnimation(using: transitionContext)
        case .mask:
            maskAnimation(using: transitionContext)
        }
    }

    private func disappearTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                toVC?.view.transform = CGAffineTransform.identity
                fromVC?.view.transform = CGAffineTransform.identity
                let maskView = SlideDrawerMaskView.shared(frame: CGRect.zero)
                maskView.alpha = 0
                self.backgroundImageView?.transform = CGAffineTransform(scaleX: SlideDrawerConst.backgroundScale, y: SlideDrawerConst.backgroundScale)
            })
        }, completion: { _ in
            if transitionContext.transitionWasCancelled == false {
                self.backgroundImageView?.removeFromSuperview()
                SlideDrawerMaskView.releaseShared()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    func pushAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView

        let maskView = SlideDrawerMaskView.shared(frame: (fromVC?.view.bounds)!)
        fromVC?.view.addSubview(maskView)

        let distance = configuration.distance
        var axis: CGFloat = 1
        var x: CGFloat = 0
        switch configuration.direction {
        case .left:
            x = -distance / 2
        case .right:
            axis = -1
            x = containerView.frame.width - distance / 2
        }

        toVC?.view.frame = CGRect(x: x, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        containerView.addSubview((toVC?.view)!)
        containerView.addSubview((fromVC?.view)!)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                let fromVCTransform: CGAffineTransform = CGAffineTransform(translationX: axis * distance, y: 0)
                let toVCTransform: CGAffineTransform = CGAffineTransform(translationX: axis * distance / 2, y: 0)
                fromVC?.view.transform = fromVCTransform
                toVC?.view.transform = toVCTransform
                maskView.alpha = self.configuration.maskAlpha
            })
        }, completion: { _ in
            if transitionContext.transitionWasCancelled {
                SlideDrawerMaskView.releaseShared()
                transitionContext.completeTransition(false)
            } else {
                maskView.isUserInteractionEnabled = true
                transitionContext.completeTransition(true)
                containerView.addSubview((fromVC?.view)!)
            }
        })
    }

    func zoomAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView

        let maskView = SlideDrawerMaskView.shared(frame: (fromVC?.view.bounds)!)
        fromVC?.view.addSubview(maskView)

        var backgroundImageView: UIImageView = UIImageView(frame: containerView.bounds)
        if configuration.backgroundImage != nil {
            backgroundImageView = UIImageView(frame: containerView.bounds)
            backgroundImageView.image = configuration.backgroundImage
            backgroundImageView.transform = CGAffineTransform(scaleX: SlideDrawerConst.backgroundScale, y: SlideDrawerConst.backgroundScale)
            backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(backgroundImageView)
            self.backgroundImageView = backgroundImageView
        }

        let distance = configuration.distance
        var axis: CGFloat = 1
        var x: CGFloat = 0
        switch configuration.direction {
        case .left:
            x = -distance / 2
        case .right:
            axis = -1
            x = containerView.frame.width - distance / 2
        }

        toVC?.view.frame = CGRect(x: x, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        containerView.addSubview((toVC?.view)!)
        containerView.addSubview((fromVC?.view)!)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                let scaleTransform = CGAffineTransform(scaleX: self.configuration.scaleY, y: self.configuration.scaleY)
                let translationX = distance - (containerView.frame.width * (1 - self.configuration.scaleY) / 2)
                let translationTransform = CGAffineTransform(translationX: axis * translationX, y: 0)
                let fromVCTransform: CGAffineTransform = scaleTransform.concatenating(translationTransform)
                let toVCTransform: CGAffineTransform = CGAffineTransform(translationX: axis * distance / 2, y: 0)
                fromVC?.view.transform = fromVCTransform
                toVC?.view.transform = toVCTransform
                maskView.alpha = self.configuration.maskAlpha
                backgroundImageView.transform = CGAffineTransform.identity
            })
        }, completion: { _ in
            if transitionContext.transitionWasCancelled {
                SlideDrawerMaskView.releaseShared()
                backgroundImageView.removeFromSuperview()
                transitionContext.completeTransition(false)
            } else {
                maskView.isUserInteractionEnabled = true
                transitionContext.completeTransition(true)
                containerView.addSubview((fromVC?.view)!)
            }
        })
    }

    func maskAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView

        let maskView = SlideDrawerMaskView.shared(frame: (fromVC?.view.bounds)!)
        fromVC?.view.addSubview(maskView)

        let distance = configuration.distance
        var axis: CGFloat = 1
        var x: CGFloat = 0
        switch configuration.direction {
        case .left:
            x = -distance
        case .right:
            axis = -1
            x = SlideDrawerConst.screenwidth
        }

        toVC?.view.frame = CGRect(x: x, y: 0, width: distance, height: containerView.frame.height)
        containerView.addSubview((fromVC?.view)!)
        containerView.addSubview((toVC?.view)!)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                toVC?.view.transform = CGAffineTransform(translationX: axis * distance, y: 0)
                maskView.alpha = self.configuration.maskAlpha
            })
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
            if cancelled {
                SlideDrawerMaskView.releaseShared()
            } else {
                containerView.addSubview((fromVC?.view)!)
                containerView.bringSubviewToFront((toVC?.view)!)
            }
        })
    }
}

extension SlideDrawerTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        switch transitionType {
        case .appear:
            return configuration.apperarDuration
        case .disappear:
            return configuration.disappearDuration
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .appear:
            appearTransition(using: transitionContext)
        case .disappear:
            disappearTransition(using: transitionContext)
        }
    }
}
