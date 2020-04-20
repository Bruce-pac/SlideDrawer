//
//  File.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/2/21.
//  Copyright © 2018年 gxy. All rights reserved.
//

import UIKit

public protocol SlideDrawerPresentKeepable: NSObjectProtocol {
    /// Whether the drawer stays in the drawer when the drawer is presenting other viewcontroller. 抽屉内进行present的时候是否保持抽屉状态
    var keepWhenPresenting: Bool { get }

}

public extension SlideDrawerPresentKeepable where Self: UIViewController {
    @available(*, deprecated, message: "No longer need, just keepWhenPresenting needed")
    func keepPresentedWhenPresenting(from direction: SlideDrawerTransitionDirection) {
        switch direction {
        case .left:
            let frame = self.presentingViewController?.view.frame
            self.presentingViewController?.view.frame = CGRect(x: SlideDrawerConst.screenwidth, y: (frame?.minY)!, width: (frame?.width)!, height: (frame?.height)!)

            self.view.superview?.sendSubviewToBack(self.view)
            UIView.animate(withDuration: 0.2) {
                self.presentingViewController?.view.frame = CGRect(x: (frame?.minX)!, y: (frame?.minY)!, width: (frame?.width)!, height: (frame?.height)!)
            }
        case .right:
            let frame = self.view.frame
            let maxX = self.presentingViewController?.view.frame.maxX
            self.view.superview?.sendSubviewToBack(self.view)
            UIView.animate(withDuration: 0.2) {
                self.view.frame = CGRect(x: maxX!, y: (frame.minY), width: (frame.width), height: (frame.height))
            }
        }
    }
}
