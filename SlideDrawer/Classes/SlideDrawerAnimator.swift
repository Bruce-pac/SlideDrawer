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

    internal var disappearInteractiveTransition: SlideDrawerInteractiveTransition? {
        didSet {
            self.disappearInteractiveTransition?.configuration = self.configuration
        }
    }

    internal var appearInteractiveTransition: SlideDrawerInteractiveTransition? {
        didSet {
            self.appearInteractiveTransition?.configuration = self.configuration
        }
    }

    var presentationController: SlideDrawerPresentationController!

    init(configuration: SlideDrawerConfiguration) {
        self.configuration = configuration
    }

    deinit {
        print(#function, self)
    }

    func update(configuration: SlideDrawerConfiguration) {
        self.configuration = configuration
        self.disappearInteractiveTransition?.configuration = self.configuration
        self.appearInteractiveTransition?.configuration = self.configuration
    }

    func addPanGesture(on viewController: UIViewController, for transition: SlideDrawerInteractiveTransition) {
        switch transition.drawerAppearGesture {
        case .edge:
            let leftedge = UIScreenEdgePanGestureRecognizer(target: transition, action: #selector(transition.handle(gesture:)))
            leftedge.edges = .left
            leftedge.delegate = self
            viewController.view.addGestureRecognizer(leftedge)
            let rightedge = UIScreenEdgePanGestureRecognizer(target: transition, action: #selector(transition.handle(gesture:)))
            rightedge.edges = .right
            rightedge.delegate = self
            viewController.view.addGestureRecognizer(rightedge)
        case .fullScreen:
            let pan = UIPanGestureRecognizer(target: transition, action: #selector(transition.handle(gesture:)))
            pan.delegate = self
            viewController.view.addGestureRecognizer(pan)
        }
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
        guard let interacting = self.appearInteractiveTransition?.interacting else { return nil }

        return interacting ? self.appearInteractiveTransition : nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interacting = self.disappearInteractiveTransition?.interacting else { return nil }

        return interacting ? self.disappearInteractiveTransition : nil
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        presentationController = SlideDrawerPresentationController(presentedViewController: presented,
                                                                   presenting: presenting,
                                                                   source: source,
                                                                   configuration: self.configuration)
        return presentationController
    }
}
