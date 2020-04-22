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

    var presentationController: SlideDrawerPresentationController!

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
        switch configuration.animationType {
        case .mask:
            maskDisappear(using: transitionContext)
        case .push:
            pushDisappear(using: transitionContext)
        case .zoom:
            zoomDisappear(using: transitionContext)
        }
    }

    func pushDisappear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let fromViewFinalFrame = presentationController.initialFrameOfPresentedViewInContainerView()
        let containerView = transitionContext.containerView

        let superview = toVC.view.superview

        containerView.addSubview(toVC.view)
        containerView.sendSubviewToBack(toVC.view)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                toVC.view.transform = .identity
                fromVC.view.frame = fromViewFinalFrame
            })
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            superview?.addSubview(toVC.view)
            transitionContext.completeTransition(!cancelled)
        })
    }
    
    func zoomDisappear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let fromViewFinalFrame = presentationController.initialFrameOfPresentedViewInContainerView()
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                toVC.view.frame = toViewFinalFrame
                fromVC.view.frame = fromViewFinalFrame
                toVC.view.layoutIfNeeded()
            })
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
    }

    func maskDisappear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
                return
        }
        let fromViewFinalFrame = presentationController.initialFrameOfPresentedViewInContainerView()

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                fromVC.view.frame = fromViewFinalFrame
            })
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })

    }

    func pushAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let containerView = transitionContext.containerView

        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        let distance = configuration.distance
        let axis: CGFloat = (configuration.direction == .left) ? 1 : -1

        toVC.view.frame = presentationController.initialFrameOfPresentedViewInContainerView()
        containerView.addSubview(toVC.view)

        let fromVCTransform: CGAffineTransform = CGAffineTransform(translationX: axis * distance, y: 0)

        //  保存用于之后将fromVC.view带回原有的视图层级
        let fromViewSuperview = fromVC.view.superview
        // iOS10下，如果fromView不在containerView上，fromView的变换动画不会响应交互式操作，其他情况下没问题。
        if #available(iOS 11, *) {
        } else {
            containerView.addSubview(fromVC.view)
            containerView.sendSubviewToBack(fromVC.view)
        }

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                fromVC.view.transform = fromVCTransform
                toVC.view.frame = toViewFinalFrame
            })
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            fromViewSuperview?.addSubview(fromVC.view)
            fromViewSuperview?.sendSubviewToBack(fromVC.view)
            transitionContext.completeTransition(!cancelled)
        })
    }

    func zoomAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let containerView = transitionContext.containerView

        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = presentationController.initialFrameOfPresentedViewInContainerView()
        containerView.addSubview(toVC.view)

        let distance = configuration.distance
        let axis: CGFloat = (configuration.direction == .left) ? 1 : -1
        let fromViewFinalX: CGFloat = axis * distance

        let height = containerView.frame.height * configuration.scaleY
        let y = (containerView.frame.height - height) / 2
        let fromViewFinalFrame = CGRect(x: fromViewFinalX, y: y, width: containerView.frame.width, height: height)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                fromVC.view.frame = fromViewFinalFrame
                toVC.view.frame = toViewFinalFrame
                fromVC.view.layoutIfNeeded()
            })
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
    }

    func maskAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        let containerView = transitionContext.containerView

        toVC.view.frame = presentationController.initialFrameOfPresentedViewInContainerView()
        containerView.addSubview(toVC.view)

        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                toVC.view.frame = toViewFinalFrame
            })
        }, completion: { _ in
            let cancelled = transitionContext.transitionWasCancelled
            if cancelled {
                toVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!cancelled)
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

    fileprivate func cleanup() {
        let vcs = [presentationController.presentingViewController,
                   presentationController.presentedViewController,
                   presentationController.sourceViewController]

        vcs.forEach { (vc) in
            vc.animator?.presentationController = nil
            if !vc.sd_isRegisterGesture {
                vc.animator = nil
            }
        }
    }

    func animationEnded(_ transitionCompleted: Bool) {
        if transitionType == .disappear && transitionCompleted {
            cleanup()
        }
    }
}
