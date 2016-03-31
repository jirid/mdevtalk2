//
//  ViewController.swift
//  FakeSnippets
//
//  Created by Jiri Dutkevic on 13/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let components = Components()
        if let data = components.storage.data, let snippets = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Snippet] {
            print(snippets)
        }
    }
}

