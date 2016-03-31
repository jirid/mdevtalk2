//
//  RootViewController.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private enum Segues: String {
        case Password = "ShowPassword"
        case Pin = "ShowPin"
        case Content = "ShowContent"
    }
    
    var initialized = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !initialized {
            showLockUI()
            initialized = true
        }
    }
    
    func showLockUI() {
        if components.crypto.pinEnabled {
            showPin()
        } else {
            showPassword()
        }
    }
    
    private func dismiss(cont: () -> ()) {
        if let _ = presentedViewController {
            dismissViewControllerAnimated(false) {
                cont()
            }
        } else {
            cont()
        }
    }
    
    private func show(what: Segues) {
        performSegueWithIdentifier(what.rawValue, sender: nil)
    }
    
    func showPassword() {
        dismiss {
            [unowned self] in
            self.show(.Password)
        }
    }
    
    func showPin() {
        dismiss {
            [unowned self] in
            self.show(.Pin)
        }
    }
    
    func showContent() {
        dismiss {
            [unowned self] in
            self.show(.Content)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let c = segue.destinationViewController as? PinViewController {
            c.title = "Enter Pin:"
            c.pinEntered = {
                [unowned self] in
                let success = components.crypto.unlockUsingPin($0)
                if success {
                    self.showContent()
                }
                return success
            }
        } else if let c = segue.destinationViewController as? PasswordViewController {
            c.title = "Enter Password:"
            c.passwordEntered = {
                [unowned self] in
                let c = components.crypto
                let unlockMethod = c.initialized ? c.unlockUsingPassword : c.initialize
                let success = unlockMethod($0)
                if success {
                    self.showContent()
                }
                return success
            }
        } else if let c = segue.destinationViewController as? UITabBarController {
            if let n = c.viewControllers?.first as? UINavigationController {
                if let l = n.viewControllers.first as? ListViewController {
                    l.model = components.model
                    l.lock = {
                        [unowned self] in
                        self.showLockUI()
                    }
                }
            }
        }
    }
}
