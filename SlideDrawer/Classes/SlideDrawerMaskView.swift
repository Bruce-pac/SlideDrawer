//
//  SlideDrawerMaskView.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/28.
//  Copyright © 2018年 gxy. All rights reserved.
//

import UIKit

final class SlideDrawerMaskView: UIView {
    private static var shared: SlideDrawerMaskView?

    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        alpha = 0
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.setupGestureRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func shared(frame: CGRect) -> SlideDrawerMaskView {
        if self.shared != nil {
            return self.shared!
        }

        let maskView = SlideDrawerMaskView(frame: frame)
        shared = maskView
        return maskView
    }

    static func releaseShared() {
        self.shared?.removeFromSuperview()
        self.shared = nil
    }

    private func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture(recognizer:)))
        self.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(recognizer:)))
        self.addGestureRecognizer(pan)
    }

    // 处理遮罩层上的手势，通过发送通知到SlideDrawerInteractiveTransition具体处理
    @objc func handleGesture(recognizer: UIGestureRecognizer) {
        switch recognizer {
        case is UIPanGestureRecognizer:
            NotificationCenter.default.post(name: NSNotification.Name.SlideDrawer.pan, object: recognizer)
        case is UITapGestureRecognizer:
            NotificationCenter.default.post(name: NSNotification.Name.SlideDrawer.tap, object: recognizer)
        default:
            break
        }
    }
}
