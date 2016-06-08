//
//  AllListsViewController.swift
//  Checklists
//
//  Created by M.I. Hollemans on 30/07/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate
{
    var dataModel: DataModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self//view controller makes itself delegate for nav controller
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count
        {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }
  
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
  
  
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataModel.lists.count
    }
    
    //things happening in the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = cellForTableView(tableView)

        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0
        {
            cell.detailTextLabel!.text = "(No items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All tasks completed"
        } else {
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        return cell
    }

    func cellForTableView(tableView: UITableView) -> UITableViewCell
    {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        {
            return cell
        } else {
            //use detailTextLabel to access the new subtitle property
            return UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
    }
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        dataModel.indexOfSelectedChecklist = indexPath.row //stores index upon tap
        let checklist = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
  
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        dataModel.lists.removeAtIndex(indexPath.row)
    
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }

    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath)
    {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigationController") as! UINavigationController
    
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
    
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
    
        presentViewController(navigationController, animated: true, completion: nil)
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowChecklist"
        {
            let controller = segue.destinationViewController as! ChecklistViewController
            controller.checklist = sender as! Checklist

        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
  
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
  
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist)
    {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
  
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist)
    {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //delegate method
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
    {
        if viewController === self
        {
            dataModel.indexOfSelectedChecklist = -1
        }
        print("navigationController(willShowViewController) ran and completed")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    
    
}
