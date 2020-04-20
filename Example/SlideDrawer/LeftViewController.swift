//
//  LeftViewController.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/29.
//  Copyright © 2018年 gxy. All rights reserved.
//

import UIKit
import SlideDrawer

class LeftViewController: UITableViewController {
    var keepWhenPresenting: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.tableView.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
//        NotificationCenter.default.addObserver(self, selector: #selector(observeDismiss), name: NSNotification.Name.SlideDrawer.insideDismissCompleted, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            self.sd.present(NextViewController(), animated: true, completion: nil)
        case 1:
            self.sd.pushViewController(NextViewController(), animated: true)
        case 2:
            self.dismiss(animated: true, completion: nil)
        default:
            fatalError()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LeftViewController: SlideDrawerPresentKeepable {

//    @objc func observeDismiss() {
//        keepPresentedWhenPresenting(from: .left)
//    }
}
