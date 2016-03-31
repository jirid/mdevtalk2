//
//  SettingsViewController.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 13/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {
    
    private enum Segues: String {
        case Password = "ShowPassword"
        case Pin = "ShowPin"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinSwitch.on = components.crypto.pinEnabled
    }
    
    @IBOutlet weak var pinSwitch: UISwitch!
    
    @IBAction func switched(sender: UISwitch) {
        if pinSwitch.on {
            performSegueWithIdentifier(Segues.Password.rawValue, sender: nil)
        } else {
            components.crypto.disablePin()
        }
    }
    
    private var password: String?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let c = segue.destinationViewController as? PasswordViewController {
            c.title = "Verify Password:"
            c.passwordEntered = {
                [unowned self] pwd in
                self.dismissViewControllerAnimated(true) {
                    [unowned self] in
                    self.password = pwd
                    self.performSegueWithIdentifier(Segues.Pin.rawValue, sender: nil)
                }
                return true
            }
        } else if let c = segue.destinationViewController as? PinViewController {
            c.title = "Choose Pin:"
            c.pinEntered = {
                [unowned self] (pin) in
                self.dismissViewControllerAnimated(true) {
                    [unowned self] in
                    if let pwd = self.password {
                        self.password = nil
                        let success = components.crypto.enablePin(pwd, pin: pin)
                        self.pinSwitch.on = success
                    }
                }
                return true
            }
        }
    }
}
