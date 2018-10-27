//
//  SlideDrawer.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/27.
//  Copyright © 2018年 gxy. All rights reserved.
//

import Foundation

public struct SlideDrawer<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol SlideDrawerCompatible {
    /// Extended type
    associatedtype CompatibleType

    var sd: SlideDrawer<CompatibleType> { get }
}

public extension SlideDrawerCompatible {
    public var sd: SlideDrawer<Self> {
        get {
            return SlideDrawer(self)
        }
    }
}

import UIKit

extension UIViewController: SlideDrawerCompatible {

}

extension NSNotification.Name {
   public struct SlideDrawer {
        internal static let tap = Notification.Name("tap")
        internal static let pan = Notification.Name("pan")
        //see demo
        public static let insideDismissCompleted = Notification.Name("insideDismissCompleted")
    }
}

extension UIView: SlideDrawerCompatible {

}

extension SlideDrawer where Base: UIView {
    var viewController: UIViewController {
            var responder = self.base.next

            while !(responder?.isKind(of: UIViewController.self))! {
               responder = responder?.next
            }
            return responder as! UIViewController
    }
}
