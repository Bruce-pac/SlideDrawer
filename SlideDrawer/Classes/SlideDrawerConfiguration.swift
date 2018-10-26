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
    var animationType: SlideDrawerAnimationType = .push

    var direction: SlideDrawerTransitionDirection = .left

    var backgroundImage: UIImage?

    var distance: CGFloat = SlideDrawerConst.screenwidth * 0.75 {
        didSet {
            if oldValue < 0 {
                distance = SlideDrawerConst.screenwidth * 0.75
            }
        }
    }

    var finishPercent: CGFloat = 0.5 {
        didSet {
            if oldValue <= 0 || oldValue > 1 {
                finishPercent = 0.5
            }
        }
    }

    var apperarDuration: TimeInterval = 0.25 {
        didSet {
            if oldValue <= 0 {
                apperarDuration = 0.25
            }
        }
    }

    var disappearDuration: TimeInterval = 0.25 {
        didSet {
            if oldValue <= 0 {
                disappearDuration = 0.25
            }
        }
    }

    var scaleY: CGFloat = 1 {
        willSet {
            if newValue <= 0 {
                fatalError("scaleY can't be less than 0")
            }
        }
    }

    var maskAlpha: CGFloat = 0.4 {
        didSet {
            if oldValue <= 0 || oldValue > 1 {
                maskAlpha = 0.4
            }
        }
    }

    public static var `default` : SlideDrawerConfiguration {
            return SlideDrawerConfiguration()
    }
}
