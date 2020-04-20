//
//  SlideDrawerPresentationController.swift
//  SlideDrawer
//
//  Created by gxy on 2020/4/16.
//

import UIKit

class SlideDrawerPresentationController: UIPresentationController {

    let configuration: SlideDrawerConfiguration

    // 三种动画都需要
    lazy var dimmingView: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()

    // zoom 需要
    lazy var backgroundImageView: UIImageView! = {
        var backgroundImageView: UIImageView = UIImageView(frame: .zero)
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return backgroundImageView
    }()

    /*
     zoom 需要，其他时候为空
     因为zoom时把presentingView加到containerView上，当present取消或dismiss成功需要重新放回原处
     */
    var presentingViewInitialSuperview: UIView?

    var sourceViewController: UIViewController

    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         source: UIViewController,
         configuration: SlideDrawerConfiguration) {
        self.configuration = configuration
        self.sourceViewController = source
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override var frameOfPresentedViewInContainerView: CGRect {

        guard let containerView = containerView else { return UIScreen.main.bounds }
        let containerBounds = containerView.bounds

        let distance = configuration.distance
        var x: CGFloat = 0
        switch configuration.direction {
        case .left:
            x = 0
        case .right:
            x = containerBounds.width - distance
        }

        let presentedViewFrame = CGRect(x: x, y: 0, width: distance, height: containerBounds.height)
        return presentedViewFrame
    }

    func initialFrameOfPresentedViewInContainerView() -> CGRect {
        guard let containerView = containerView else { return UIScreen.main.bounds }
        let containerBounds = containerView.bounds

        let distance = configuration.distance
        var x: CGFloat = 0
        switch configuration.direction {
        case .left:
            x = -distance
        case .right:
            x = containerBounds.width
        }

        let result = CGRect(x: x, y: 0, width: distance, height: containerBounds.height)
        return result
    }

    /// presentation转场开始发生时distance与containerView的width的比值
    var initialScale: CGFloat!
    /// presentation转场开始发生时的方向
    var initialOrientation: UIDeviceOrientation = UIDevice.current.orientation

    override func containerViewWillLayoutSubviews() {
        guard !transitioning else { return }
        guard let containerView = containerView else { return }
        let containerBounds = containerView.bounds

        let orientation = UIDevice.current.orientation
        if initialOrientation != orientation {
            let newWidth = initialScale * containerBounds.width
            adjustLayoutWhenOrientationChanged(with: newWidth)
        }else {
            adjustLayoutWhenOrientationChanged(with: configuration.distance)
        }
        if let presentedView = presentedView {
            containerView.bringSubviewToFront(presentedView)
        }
    }

    func adjustLayoutWhenOrientationChanged(with newWidth: CGFloat) {
        guard let containerView = containerView else { return }
        let containerBounds = containerView.bounds
        var axis: CGFloat = 1
        var x: CGFloat = 0
        switch configuration.direction {
        case .left:
            x = 0
        case .right:
            axis = -1
            x = containerBounds.width - newWidth
        }
        let newFrame = CGRect(x: x, y: 0, width: newWidth, height: containerBounds.height)
        presentedView?.frame = newFrame

        switch configuration.animationType {
        case .mask:
            break
        case .push:
            presentingViewController.view.transform = CGAffineTransform(translationX: axis * newWidth, y: 0)
        case .zoom:
            let height = containerBounds.height * configuration.scaleY
            let y = (containerBounds.height - height) / 2
            presentingViewController.view.frame = CGRect(x: axis * newWidth, y: y, width: containerBounds.width, height: height)
            dimmingView.frame = CGRect(x: 0, y: y, width: dimmingView.bounds.width, height: height)
        }
    }

    func finalFrameOfPresentingViewWhenZoom(with distance: CGFloat) -> CGRect {
        guard let containerView = containerView else { return UIScreen.main.bounds }
        let containerBounds = containerView.bounds

        let axis: CGFloat = (configuration.direction == .left) ? 1 : -1
        let height = containerBounds.height * configuration.scaleY
        let y = (containerBounds.height - height) / 2
        let result = CGRect(x: axis * distance, y: y, width: containerBounds.width, height: height)
        return result
    }

    var transitioning: Bool = false

    override func presentationTransitionWillBegin() {
        transitioning = true
        if let containerBounds = containerView?.bounds {
            initialScale = configuration.distance / containerBounds.width
        }
        switch configuration.animationType {
        case .mask:
            presentationTransitionWillBeginWhenMask()
        case .push:
            presentationTransitionWillBeginWhenMask()
        case .zoom:
            presentationTransitionWillBeginWhenZoom()
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        transitioning = false
        switch configuration.animationType {
        case .mask, .push:
            presentationTransitionDidEndWhenMask(completed)
        case .zoom:
            presentationTransitionDidEndWhenZoom(completed)
        }
    }

    override func dismissalTransitionWillBegin() {
        transitioning = true
        switch configuration.animationType {
        case .mask, .push:
            if let transitionCoordinator = presentedViewController.transitionCoordinator {
                transitionCoordinator.animate(alongsideTransition: { (_) in
                    self.dimmingView.alpha = 0
                }, completion: nil)
            }else {
                self.dimmingView.alpha = 0
            }
        case .zoom:
            dismissalTransitionWillBeginWhenZoom()
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        transitioning = false
        if completed {
            self.dimmingView.removeFromSuperview()
            // zoom 时
            presentingViewInitialSuperview?.addSubview(presentingViewController.view)
        }else{
            if #available(iOS 13, *) {
            } else {
                /// iOS 12以下，push类型的dismiss取消状态下，系统把presentingView放到最前面了，挡住了dimmingView，所以要重新放到最后面。
                if case .push = configuration.animationType  {
                    presentingViewController.view.superview?.sendSubviewToBack(presentingViewController.view)
                }
            }
        }

    }

    private func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture(recognizer:)))
        self.dimmingView.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(recognizer:)))
        self.dimmingView.addGestureRecognizer(pan)
    }

    @objc func handleGesture(recognizer: UIGestureRecognizer) {
        switch recognizer {
        case is UIPanGestureRecognizer:
            // 处理遮罩层上的手势，通过发送通知到SlideDrawerInteractiveTransition具体处理
            NotificationCenter.default.post(name: NSNotification.Name.SlideDrawer.pan, object: recognizer)
        case is UITapGestureRecognizer:
            presentedViewController.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}

extension SlideDrawerPresentationController {
    func presentationTransitionWillBeginWhenZoom() {
        guard let containerView = containerView else { return }
        let containerBounds = containerView.bounds
        presentingViewInitialSuperview = presentingViewController.view.superview

        backgroundImageView.frame = containerBounds
        backgroundImageView.image = configuration.backgroundImage
        containerView.addSubview(backgroundImageView)

        self.dimmingView.frame = containerBounds
        let scaleTransform = CGAffineTransform(scaleX: 1, y: configuration.scaleY)
        setupGestureRecognizer()
        containerView.addSubview(dimmingView)
        containerView.insertSubview(presentingViewController.view, belowSubview: dimmingView)

        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (_) in
                self.dimmingView.alpha = self.configuration.maskAlpha
                self.dimmingView.transform = scaleTransform
            }, completion: nil)
        }else {
            self.dimmingView.alpha = self.configuration.maskAlpha
            self.dimmingView.transform = scaleTransform
        }
    }

    func presentationTransitionDidEndWhenZoom(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
            backgroundImageView.removeFromSuperview()
            presentingViewInitialSuperview?.addSubview(presentingViewController.view)
        }
    }

    func dismissalTransitionWillBeginWhenZoom() {
        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (_) in
                self.dimmingView.alpha = 0
                self.dimmingView.transform = .identity
            }, completion: nil)
        }else {
            self.dimmingView.alpha = 0
            self.dimmingView.transform = .identity
        }
    }
}

extension SlideDrawerPresentationController {
    func presentationTransitionWillBeginWhenMask() {
        guard let containerView = containerView else { return }
        let containerBounds = containerView.bounds

        self.dimmingView.frame = containerBounds
        setupGestureRecognizer()
        containerView.insertSubview(self.dimmingView, at: 0)

        if let transitionCoordinator = presentedViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (_) in
                self.dimmingView.alpha = self.configuration.maskAlpha
            }, completion: nil)
        }else {
            self.dimmingView.alpha = self.configuration.maskAlpha
        }
    }

    func presentationTransitionDidEndWhenMask(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
}
