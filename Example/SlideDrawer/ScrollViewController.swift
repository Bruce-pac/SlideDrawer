//
//  ScrollViewController.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/2/22.
//  Copyright © 2018年 gxy. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit
import SlideDrawer

class ScrollViewController: UIViewController {
    @IBOutlet weak var scrollView: CustomScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupscrollView()
        self.sd.register(gesture: .fullScreen) { (direc) in
            self.push(from: direc)
        }
    }

    func push(from direction: SlideDrawerTransitionDirection) {
        switch direction {
        case .left:
            let vc: LeftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
            vc.keepWhenPresenting = true
            self.sd.show(drawer: vc)
        case .right:
            let vc: RightViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
            self.sd.show(drawer: vc) { (letConfig) -> SlideDrawerConfiguration in
                var config = letConfig
                config.direction = .right
                return config
            }
        }
    }

    func setupscrollView() {
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: UIScreen.main.bounds.height)
        let colors: [UIColor] = [.cyan, .green, .magenta]
        for i in 0...2 {
            let fi = CGFloat(integerLiteral: i)
            let view = UIView(frame: CGRect(x: fi * UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            view.backgroundColor = colors[i]
            self.scrollView.addSubview(view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class CustomScrollView: UIScrollView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let tranlationX = pan.translation(in: self).x
            if tranlationX > 0 && self.contentOffset.x == 0 {//scroll from left
                return false
            }
            if tranlationX < 0 &&
                self.contentSize.width - self.contentOffset.x == self.bounds.width {
                return false
            }
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
