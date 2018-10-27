//
//  SlideDrawerInteractiveTransition.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/29.
//  Copyright © 2018年 gxy. All rights reserved.
//
// swiftlint:disable identifier_name
import UIKit

public enum IntractiveGestureType {
    case edge
    case fullScreen
}

class SlideDrawerInteractiveTransition: UIPercentDrivenInteractiveTransition,
    SlideDrawerTransitionable {
    var transitionType: SlideDrawerTransitionType
    var configuration: SlideDrawerConfiguration

    var drawerAppearGesture: IntractiveGestureType = .edge

    weak var drawerVC: UIViewController?

    typealias TransitionHandler = (SlideDrawerTransitionDirection) -> Void

    var transitionHandler: TransitionHandler?

    internal private(set) var interacting: Bool = false

    private var percent: CGFloat = 0

    /// displayLink完成剩余手势的每帧的百分比
    private var framePercent: CGFloat = 0

    private var cancelOrFinish: Bool = false

    private var displayLink: CADisplayLink?

    // MARK: life cycle

    init(transitionType: SlideDrawerTransitionType, configuration: SlideDrawerConfiguration = SlideDrawerConfiguration.default) {
        self.transitionType = transitionType
        self.configuration = configuration
        super.init()

        self.addNotificationCenterObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.SlideDrawer.tap, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.SlideDrawer.pan, object: nil)
    }

    // MARK: private

    private func addNotificationCenterObserver() {
        // 观察SlideDrawerMaskView发出的通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGesture(by:)), name: NSNotification.Name.SlideDrawer.tap, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleGesture(by:)), name: NSNotification.Name.SlideDrawer.pan, object: nil)
    }

    // 处理SlideDrawerMaskView发出的通知
    @objc private func handleGesture(by noti: NSNotification) {
        let object = noti.object

        if object is UITapGestureRecognizer {
            let gesture = object as! UITapGestureRecognizer
            gesture.view?.sd.viewController.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        if object is UIPanGestureRecognizer {
            guard self.transitionType == .disappear else {
                return
            }
            let gesture = object as! UIPanGestureRecognizer
            self.handle(gesture: gesture)
        }
    }

    @objc internal func handle(gesture: UIPanGestureRecognizer) {
        // 拿到手势移动的距离，计算百分比
        let x = gesture.translation(in: gesture.view).x
        self.percent = abs(x / SlideDrawerConst.screenwidth)

        switch gesture.state {
        case .changed:
            if self.interacting {
                self.percent = min(max(self.percent, 0.001), 1.0)
                self.update(self.percent)
            } else {
                self.willInteracting(beginTranslationX: x, by: gesture)
            }
        case .cancelled, .ended:
            self.interacting = false
            self.startDisplayLink(from: self.percent)
        default:
            break
        }
    }

    private func willInteracting(beginTranslationX x: CGFloat, by gesture: UIPanGestureRecognizer) {
        switch self.transitionType {
        case .appear:
            if x == 0 {
                return
            }
            self.appear(beginTranslationX: x, by: gesture)
        case .disappear:
            self.disappear(beginTranslationX: x, by: gesture)
        }
    }

    private func appear(beginTranslationX x: CGFloat, by gesture: UIPanGestureRecognizer) {
        self.configuration.direction = x > 0 ? .left : .right
//        let locationX = gesture.location(in: self.drawerVC?.view).x
//    if gesture is UIScreenEdgePanGestureRecognizer {
//        return
//    }
//        let edgeGesture: Bool = self.drawerAppearGesture == .edge
//        let condition1 = edgeGesture && self.configuration.direction == .left &&
//                         locationX > SlideDrawerConst.edgeGestureLength
//        let condition2 = edgeGesture && self.configuration.direction == .right &&
//                         locationX < SlideDrawerConst.screenwidth - SlideDrawerConst.edgeGestureLength
//        if condition1 || condition2 {
//            return
//        }
        self.interacting = true
        self.transitionHandler?(self.configuration.direction)
    }

    func disappear(beginTranslationX x: CGFloat, by gesture: UIPanGestureRecognizer) {
        let condition = (x > 0, self.configuration.direction)
        switch condition {
        case (true, .left), (false, .right):
            return
        default:
            break
        }
        self.interacting = true
        self.drawerVC?.dismiss(animated: true, completion: nil)
    }

    // 手势结束后接下来的事情
    private func startDisplayLink(from percent: CGFloat) {
        self.cancelOrFinish = percent >= self.configuration.finishPercent
        self.framePercent = 1 / (self.duration * 60)
        if self.displayLink == nil {
            self.displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkUpdate))
        }
        self.displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }

    private func stopDisplayLink() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }

    /// 自动完成手势
    @objc private func displayLinkUpdate() {
        switch self.cancelOrFinish {
        case true:
            if self.percent >= 1 {
                self.stopDisplayLink()
                self.finish()
                return
            } else {
                self.percent += self.framePercent
            }
        case false:
            if self.percent <= 0 {
                self.stopDisplayLink()
                self.cancel()
                return
            } else {
                self.percent -= self.framePercent
            }
        }

        self.percent = min(max(self.percent, 0.0), 1.0)
        self.update(self.percent)
    }
}
