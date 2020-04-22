//
//  SlideDrawerAnimator.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/29.
//  Copyright © 2018年 gxy. All rights reserved.
//

import UIKit

class SlideDrawerAnimator: NSObject {
    private var configuration: SlideDrawerConfiguration

    lazy var disappearInteractiveTransition: SlideDrawerInteractiveTransition = {
        let disappear = SlideDrawerInteractiveTransition(transitionType: .disappear)
        return disappear
    }()

    lazy var appearInteractiveTransition: SlideDrawerInteractiveTransition = {
        let appear = SlideDrawerInteractiveTransition(transitionType: .appear)
        appear.transitionHandler = self.transitionHandler
        return appear
    }()

    var presentationController: SlideDrawerPresentationController!

    var transitionHandler: TransitionHandler?

    init(configuration: SlideDrawerConfiguration,
         transitionHandler: TransitionHandler? = nil) {
        self.configuration = configuration
        self.transitionHandler = transitionHandler
    }

    deinit {
        debugPrint(#function, self)
    }

    func update(configuration: SlideDrawerConfiguration) {
        self.configuration = configuration
        self.disappearInteractiveTransition.configuration = self.configuration
        self.appearInteractiveTransition.configuration = self.configuration
    }

    @objc func handle(gesture: UIPanGestureRecognizer) {
        self.appearInteractiveTransition.handleAppear(gesture: gesture)
    }
}

extension SlideDrawerAnimator: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view is UITableView {
            return true
        }
        return false
    }
}

extension SlideDrawerAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = SlideDrawerTransition(transitionType: .appear, configuration: self.configuration)
        transition.presentationController = presentationController
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = SlideDrawerTransition(transitionType: .disappear, configuration: self.configuration)
        transition.presentationController = presentationController
        return transition
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let interacting = self.appearInteractiveTransition.interacting
        return interacting ? self.appearInteractiveTransition : nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        let interacting = self.disappearInteractiveTransition.interacting
        return interacting ? self.disappearInteractiveTransition : nil
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationController = SlideDrawerPresentationController(presentedViewController: presented,
                                                                   presenting: presenting,
                                                                   source: source,
                                                                   configuration: self.configuration)
        presentationController.dismissPanHandler = { [unowned self] (gesture) in
            self.disappearInteractiveTransition.handleDisppear(gesture: gesture, presentingVC: presenting ?? source)
        }
        return presentationController
    }
}
