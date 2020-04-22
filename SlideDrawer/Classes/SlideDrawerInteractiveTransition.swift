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

typealias TransitionHandler = (SlideDrawerTransitionDirection) -> Void

class SlideDrawerInteractiveTransition: UIPercentDrivenInteractiveTransition,
    SlideDrawerTransitionable {
    var transitionType: SlideDrawerTransitionType
    var configuration: SlideDrawerConfiguration

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
    }

    deinit {
        debugPrint("SlideDrawerInteractiveTransition")
    }

    func handleAppear(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            gesture.setTranslation(.zero, in: gesture.view)
        case .changed:
            let x = gesture.translation(in: gesture.view).x
            if x == 0 {
                return
            }
            if self.interacting {
                self.percent = abs(x / configuration.distance)
                self.percent = min(max(self.percent, 0.001), 1.0)
                update(self.percent)
            }else{
                self.interacting = true
                self.configuration.direction = x > 0 ? .left : .right
                self.transitionHandler?(self.configuration.direction)
            }
        case .cancelled, .ended:
            self.interacting = false
            self.startDisplayLink(from: self.percent)
        default:
            break
        }
    }

    func handleDisppear(gesture: UIPanGestureRecognizer, presentingVC: UIViewController) {
        switch gesture.state {
        case .began:
            gesture.setTranslation(.zero, in: gesture.view)
        case .changed:
            let x = gesture.translation(in: gesture.view).x
            if x == 0 {
                return
            }
            if self.interacting {
                self.percent = abs(x / configuration.distance)
                self.percent = min(max(self.percent, 0.001), 1.0)
                update(self.percent)
            }else{
                self.interacting = true
                presentingVC.dismiss(animated: true, completion: nil)
            }
        case .cancelled, .ended:
            self.interacting = false
            self.startDisplayLink(from: self.percent)
        default:
            break
        }

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
