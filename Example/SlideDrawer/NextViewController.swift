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
        btn.setTitle("dismiss", for: .normal)
        btn.addTarget(self, action: #selector(self.dismissTwo), for: .touchUpInside)
        self.view.addSubview(btn)
        // Do any additional setup after loading the view.
    }

    @objc func dismissTwo() {
        self.dismiss(animated: true) {
        }
        NotificationCenter.default.post(name: NSNotification.Name.SlideDrawer.insideDismissCompleted, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
