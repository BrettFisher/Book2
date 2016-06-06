//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Fisher, Brett on 6/6/16.
//  Copyright © 2016 Razeware. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController
{
    var lists: [Checklist]
    
    required init?(coder aDecoder: NSCoder)//this is basically a constructor...like in Java
    {
        lists = [Checklist]()
        super.init(coder: aDecoder)
        
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = cellForTableView(tableView)
        cell.textLabel!.text = "List \(indexPath.row)"

        return cell
    }
    
    
    //the coding way of creating cells
    func cellForTableView(tableView: UITableView) -> UITableViewCell
    {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        {
            return cell
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
    }
 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("ShowChecklist", sender: nil)
    }

}
