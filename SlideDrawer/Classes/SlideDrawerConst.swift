//
//  SlideDrawerConst.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/27.
//  Copyright © 2018年 gxy. All rights reserved.
//

import Foundation
import UIKit

public struct SlideDrawerConst {
    public static var screenwidth: CGFloat {
        UIScreen.main.bounds.width
    }
    static let backgroundScale: CGFloat = 1.4
    static let edgeGestureLength: CGFloat = 50
    internal struct AssociatedKeys {
        static var animatorKey = "com.sliderdrawer.animatorKey"
        static var registerGesture = "com.sliderdrawer.registerGesture"
    }
}
