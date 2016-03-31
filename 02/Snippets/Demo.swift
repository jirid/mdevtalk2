//
//  Demo.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 13/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

extension ListViewController {
    
    @IBAction func demo(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Demo", message: "Insert one of the following snippets into your snippet database.", preferredStyle: .Alert)
        let n1 = "Fast integer factorization"
        let s1 = UIAlertAction(title: n1, style: .Default) {
            [unowned self] (action) in
            let snippet = Snippet(name: n1, content: "func factorization(n: Int) -> [Int] {\n\tswitch n {\n\t case _ where n <= 1:\n\t\tfatalError(\"not implemented\")\n\tcase 2, 3, 5, 7, 11, 13, 17, 19, 23:\n\t\treturn [n]\n\tcase _ where n % 2 == 0:\n\t\tvar c = factoriztion(n / 2)\n\t\tc.append(2)\n\t\treturn c\n\tdefault:\n\t\treturn oracle(n)\n\t}\n}\n\nfunc oracle(n: Int) -> [Int] {\n\treturn [4, 8, 15, 16, 23, 42]\n}")
            self.model.snippets.append(snippet)
            self.tableView.reloadData()
        }
        alert.addAction(s1)
        let n2 = "Central theorem"
        let s2 = UIAlertAction(title: n2, style: .Default) {
            [unowned self] (action) in
            let snippet = Snippet(name: n2, content: "func theAnswer() -> Int {\n\treturn 42\n}")
            self.model.snippets.append(snippet)
            self.tableView.reloadData()
        }
        alert.addAction(s2)
        let n3 = "Useful debugging tool"
        let s3 = UIAlertAction(title: n3, style: .Default) {
            [unowned self] (action) in
            let snippet = Snippet(name: n3, content: "func retry(block: () -> ()) {\n\tguard system.pluggedIn() else {\n\t\tfatalError(\"Plug it in.\")\n\t}\n\tdo {\n\t\ttry system.turnOff()\n\t\ttry system.turnOn()\n\t } catch {\n\t\tfatalError(\"No idea what's wrong.\")\n\t}\n\tblock()\n}")
            self.model.snippets.append(snippet)
            self.tableView.reloadData()
        }
        alert.addAction(s3)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }
}
