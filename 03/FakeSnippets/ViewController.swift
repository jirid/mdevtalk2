//
//  ViewController.swift
//  FakeSnippets
//
//  Created by Jiri Dutkevic on 13/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var endLabel: UILabel!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        let fmt = NSDateFormatter()
        fmt.dateStyle = .NoStyle
        fmt.timeStyle = .LongStyle
        startLabel.text = fmt.stringFromDate(NSDate())
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            [unowned self] in
            let components = Components()
            for i in 0...9999 {
                let s: String
                switch i {
                case _ where i < 10:
                    s = "000\(i)"
                case _ where i < 100:
                    s = "00\(i)"
                case _ where i < 1000:
                    s = "0\(i)"
                default:
                    s = "\(i)"
                }
                if components.crypto.unlockUsingPin(s) {
                    dispatch_async(dispatch_get_main_queue()) {
                        [unowned self] in
                        self.label.text = s
                    }
                    break
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.endLabel.text = fmt.stringFromDate(NSDate())
            }
        }
    }
}

