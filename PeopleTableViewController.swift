//
//  PeopleTableViewController.swift
//  GetLocation
//
//  Created by Charles Konkol on 2015-12-02.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import UIKit
import ParseUI

class PeopleTableViewController:PFQueryTableViewController {
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "MapLocation"
        
        self.textKey = "fullname"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    @IBAction func btnback(sender: UIBarButtonItem) {
         self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "MapLocation")
        
        
        
        return query
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // Configure the PFQueryTableView
    
        loadObjects()
        
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.text = object?["fullname"] as? String
        cell?.detailTextLabel?.text = object?["lastupdate"] as? String
        others = (object?["fullname"] as? String)!
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("people", sender: tableView)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        let detailScene = segue.destinationViewController as! ViewController
        
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let row = Int(indexPath.row)
            detailScene.currentObject = objects![row] as? PFObject
        }
    }
}



