//
//  ListViewController.swift
//  Snippets
//
//  Created by Jiri Dutkevic on 12/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import UIKit

final class ListViewController: UITableViewController {
    
    private enum Cells: String {
        case Default = "DefaultCell"
    }
    
    private enum Segues: String {
        case Detail = "ShowDetail"
    }
    
    var model: Model!
    
    var lock: (() -> ())?
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.snippets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cells.Default.rawValue)!
        cell.textLabel?.text = model.snippets[indexPath.row].name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? DetailViewController {
            if let selected = tableView.indexPathForSelectedRow {
                vc.snippet = model.snippets[selected.row]
                vc.save = {
                    [unowned self] in
                    self.model.snippets[selected.row] = $0
                    self.tableView.reloadRowsAtIndexPaths([selected], withRowAnimation: .Automatic)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            } else {
                vc.save = {
                    [unowned self] in
                    self.model.snippets.append($0)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.model.snippets.count-1, inSection: 0)], withRowAnimation: .Automatic)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") {
            [unowned self] (action, indexPath) in
                self.model.snippets.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }]
    }
    
    @IBAction func lock(sender: UIBarButtonItem) {
        lock?()
    }
}
