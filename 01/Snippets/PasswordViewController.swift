//
//  PasswordViewController.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

final class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    override var title: String? {
        didSet {
            label?.text = title
        }
    }
    
    @IBOutlet weak var label: UILabel!
    
    var passwordEntered: (String -> Bool)?
    
    @IBOutlet weak var text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = title
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        text.text = ""
        text.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let password = text.text where !password.isEmpty, let f = passwordEntered {
            if !f(password) {
                text.text = ""
            }
        }
        return false
    }
}
