//
//  SlideDrawerConfiguration.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/28.
//  Copyright © 2018年 gxy. All rights reserved.
//

import Foundation
import UIKit

public enum SlideDrawerAnimationType {
    case push
    case zoom
    case mask
}

public enum SlideDrawerTransitionDirection {
    case left
    case right
}

public struct SlideDrawerConfiguration {
    public var animationType: SlideDrawerAnimationType = .push

    public var direction: SlideDrawerTransitionDirection = .left

    /// the drawer viewController's width, default value is third forth of screen width
    public var distance: CGFloat = SlideDrawerConst.screenwidth * 0.75 {
        didSet {
            if oldValue < 0 {
                distance = SlideDrawerConst.screenwidth * 0.75
            }
        }
    }

    public var apperarDuration: TimeInterval = 0.25 {
        didSet {
            if oldValue <= 0 {
                apperarDuration = 0.25
            }
        }
    }

    public var disappearDuration: TimeInterval = 0.25 {
        didSet {
            if oldValue <= 0 {
                disappearDuration = 0.25
            }
        }
    }

    public var finishPercent: CGFloat = 0.5 {
        didSet {
            if oldValue <= 0 || oldValue > 1 {
                finishPercent = 0.5
            }
        }
    }

    /// only use when animationType is zoom
    public var backgroundImage: UIImage?

    /// only use when animationType is zoom
    public var scaleY: CGFloat = 1 {
        willSet {
            if newValue <= 0 {
                fatalError("scaleY can't be less than 0")
            }
        }
    }

    public var maskAlpha: CGFloat = 0.4 {
        didSet {
            if oldValue <= 0 || oldValue > 1 {
                maskAlpha = 0.4
            }
        }
    }

    public init(animationType: SlideDrawerAnimationType = .push,
                direction: SlideDrawerTransitionDirection = .left,
                distance: CGFloat = SlideDrawerConst.screenwidth * 0.75,
                apperarDuration: TimeInterval = 0.25,
                disappearDuration: TimeInterval = 0.25,
                finishPercent: CGFloat = 0.5,
                backgroundImage: UIImage? = nil,
                scaleY: CGFloat = 1,
                maskAlpha: CGFloat = 0.4) {
        self.animationType = animationType
        self.direction = direction
        self.backgroundImage = backgroundImage
        self.distance = distance
        self.finishPercent = finishPercent
        self.apperarDuration = apperarDuration
        self.disappearDuration = disappearDuration
        self.scaleY = scaleY
        self.maskAlpha = maskAlpha
    }

    public static var `default`: SlideDrawerConfiguration {
        return SlideDrawerConfiguration()
    }
}
