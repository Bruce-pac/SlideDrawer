//
//  ViewController.swift
//  Demo_SlideDrawer
//
//  Created by gxy on 2018/1/27.
//  Copyright © 2018年 gxy. All rights reserved.
//

import UIKit
import SlideDrawer

class ViewController: UITableViewController {

    var appearDuration: TimeInterval = 0.25
    var disappearDuration: TimeInterval = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sd.register(gesture: .edge) { (direction) in
            self.push(from: direction)
        }
    }

    @IBAction func appearDurationChanged(_ sender: UISlider) {
        appearDuration = TimeInterval(sender.value)
    }

    @IBAction func disappearDurationChanged(_ sender: UISlider) {
        disappearDuration = TimeInterval(sender.value)
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

    func zoom(from direction: SlideDrawerTransitionDirection) {
        switch direction {
        case .left:
            let vc: LeftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
            self.sd.show(drawer: vc) { (letConfig) -> SlideDrawerConfiguration in
                var config = letConfig
                config.animationType = .zoom
                config.scaleY = 0.8
                config.backgroundImage = UIImage(color: UIColor.green)
                config.apperarDuration = appearDuration
                config.disappearDuration = disappearDuration
                return config
            }
        case .right:
            let vc: RightViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
            self.sd.show(drawer: vc) { (letConfig) -> SlideDrawerConfiguration in
                var config = letConfig
                config.direction = .right
                config.animationType = .zoom
                config.scaleY = 0.8
                config.backgroundImage = UIImage(color: UIColor.green)
                return config
            }
        }
    }

    func mask(from direction: SlideDrawerTransitionDirection) {
        switch direction {
        case .left:
            let vc: LeftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
            self.sd.show(drawer: vc) { (letConfig) -> SlideDrawerConfiguration in
                var config = letConfig
                config.animationType = .mask
                config.distance = SlideDrawerConst.screenwidth * 0.85
                return config
            }
        case .right:
            let vc: RightViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
            self.sd.show(drawer: vc) { (letConfig) -> SlideDrawerConfiguration in
                var config = letConfig
                config.direction = .right
                config.animationType = .mask
                return config
            }
        }
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            self.push(from: .left)
        case 1:
            self.push(from: .right)
        case 2:
            self.zoom(from: .left)
        case 3:
            self.zoom(from: .right)
        case 4:
            self.mask(from: .left)
        case 5:
            self.mask(from: .right)
        default:
            print("\(index)")
        }
    }
}
