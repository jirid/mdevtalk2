//
//  PinViewController.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

final class PinViewController: UIViewController {
    
    override var title: String? {
        didSet {
            label?.text = title
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    private var pin: String = "" {
        didSet {
            text.text = pin
        }
    }
    
    var pinEntered: (String -> Bool)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = title
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pin = ""
    }
    
    @IBOutlet weak var text: UITextField!
    
    @IBAction func tapped(sender: UIButton) {
        if let title = sender.titleForState(.Normal) {
            switch title {
            case "⌫":
                if !pin.isEmpty {
                    pin.removeAtIndex(pin.endIndex.predecessor())
                }
            default:
                pin += title
            }
        }
        if pin.characters.count >= 4 {
            if let f = pinEntered where !f(pin) {
                pin = ""
            }
        }
    }
}
