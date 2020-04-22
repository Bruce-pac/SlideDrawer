//
//  UIViewController+SlideDrawer.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/27.
//  Copyright © 2018年 gxy. All rights reserved.
//

import UIKit

public extension SlideDrawer where Base: UIViewController {
    /// 展示抽屉
    ///
    /// - Parameters:
    ///   - viewController: 抽屉控制器
    ///   - configuration: 展示抽屉需要的一些效果的配置
    func show(drawer viewController: UIViewController, configuration: SlideDrawerConfiguration = SlideDrawerConfiguration.default) {
        /// 获取animator，没有则创建，然后更新配置
        var animator = self.base.animator
        if animator == nil {
            animator = SlideDrawerAnimator(configuration: configuration)
            self.base.animator = animator
        }
        viewController.animator = animator
        animator?.update(configuration: configuration)
        viewController.transitioningDelegate = animator
        viewController.modalPresentationStyle = .custom
        self.base.present(viewController, animated: true, completion: nil)
    }

    // 使用建造者模式快速配置并显示抽屉
    func show(drawer viewController: UIViewController, configurationBuilder: (SlideDrawerConfiguration) -> SlideDrawerConfiguration) {
        let defaultConfiguration = SlideDrawerConfiguration.default
        let configuration = configurationBuilder(defaultConfiguration)
        show(drawer: viewController, configuration: configuration)
    }

    /// 为呼出抽屉增加交互手势
    ///
    /// - Parameters:
    ///   - gesture: 交互手势的类型，边缘和全屏
    ///   - transitionHandler: 触发手势后需要执行的具体转场
    func register(gesture: IntractiveGestureType, transitionHandler: @escaping (SlideDrawerTransitionDirection) -> Void) {
        let animator = SlideDrawerAnimator(configuration: SlideDrawerConfiguration.default, transitionHandler: transitionHandler)

        self.base.sd_isRegisterGesture = true
        self.base.animator = animator
        self.base.transitioningDelegate = animator

        let viewController = self.base
        switch gesture {
        case .edge:
            let leftedge = UIScreenEdgePanGestureRecognizer(target: animator, action: #selector(animator.handle(gesture:)))
            leftedge.edges = .left
            leftedge.delegate = animator
            viewController.view.addGestureRecognizer(leftedge)
            let rightedge = UIScreenEdgePanGestureRecognizer(target: animator, action: #selector(animator.handle(gesture:)))
            rightedge.edges = .right
            rightedge.delegate = animator
            viewController.view.addGestureRecognizer(rightedge)
        case .fullScreen:
            let pan = UIPanGestureRecognizer(target: animator, action: #selector(animator.handle(gesture:)))
            pan.delegate = animator
            viewController.view.addGestureRecognizer(pan)
        }
    }

    /// 抽屉内push
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let presentingViewController = self.base.presentingViewController
        self.base.dismiss(animated: true)

        if let navVC = presentingViewController as? UINavigationController {
            navVC.pushViewController(viewController, animated: animated)
            return
        }
        if let navVC = presentingViewController?.navigationController {
            navVC.pushViewController(viewController, animated: animated)
            return
        }
        if let tabVC = presentingViewController as? UITabBarController {
            if let navVC = tabVC.selectedViewController as? UINavigationController {
                navVC.pushViewController(viewController, animated: animated)
                return
            }
        }
        debugPrint("no navigationController")
    }
}

public extension SlideDrawer where Base: UIViewController, Base: SlideDrawerPresentKeepable {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        guard self.base.keepWhenPresenting else {
            let presentingVC = self.base.presentingViewController
            self.base.dismiss(animated: true) {
                presentingVC?.present(viewControllerToPresent, animated: flag, completion: completion)
            }
            return
        }
        viewControllerToPresent.modalPresentationStyle = .overFullScreen
        self.base.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

extension UIViewController {
    internal var animator: SlideDrawerAnimator? {
        get {
            return objc_getAssociatedObject(self, &SlideDrawerConst.AssociatedKeys.animatorKey) as? SlideDrawerAnimator
        }
        set {
            objc_setAssociatedObject(self, &SlideDrawerConst.AssociatedKeys.animatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// A value that indicates whether or not an interactive gesture is registered
    var sd_isRegisterGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &SlideDrawerConst.AssociatedKeys.registerGesture) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &SlideDrawerConst.AssociatedKeys.registerGesture, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
