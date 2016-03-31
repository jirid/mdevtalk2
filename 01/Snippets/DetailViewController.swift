//
//  DetailViewController.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    var snippet: Snippet? {
        didSet {
            if let f = nameField {
                f.text = snippet?.name
            }
            if let f = contentField {
                f.text = snippet?.content
            }
        }
    }
    
    var save: (Snippet -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        if let s = snippet {
            nameField.text = s.name
            contentField.text = s.content
        } else {
            nameField.text = ""
            contentField.text = ""
        }
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contentField: UITextView!
    
    @IBAction func save(sender: UIBarButtonItem) {
        if let name = nameField.text where !name.isEmpty,
            let content = contentField.text where !content.isEmpty {
            let snippet = Snippet(name: name, content: content)
            save?(snippet)
        }
    }
}
