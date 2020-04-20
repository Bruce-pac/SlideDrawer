//
//  NextViewController.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/2/20.
//  Copyright © 2018年 gxy. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        let btn = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        btn.center = view.center
        btn.setTitle("dismiss", for: .normal)
        btn.addTarget(self, action: #selector(self.dismissTwo), for: .touchUpInside)
        self.view.addSubview(btn)
    }

    @objc func dismissTwo() {
        self.dismiss(animated: true) {
        }
//        NotificationCenter.default.post(name: NSNotification.Name.SlideDrawer.insideDismissCompleted, object: nil)
    }

}
