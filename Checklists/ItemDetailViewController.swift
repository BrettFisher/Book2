//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by M.I. Hollemans on 28/07/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation
import UIKit

//contract between screens
protocol ItemDetailViewControllerDelegate: class
{
    //this is for pressing cancel()
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    //this is for pressing done()
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    //this is for pressing done() in edit mode
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let item = itemToEdit
        {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
        }
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    var itemToEdit: ChecklistItem?
    
    weak var delegate: ItemDetailViewControllerDelegate?

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
  
    @IBAction func cancel()
    {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
  
    @IBAction func done()
    {
        if let item = itemToEdit
        {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }
  
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?
    {
        return nil
    }
  
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)

        doneBarButton.enabled = newText.length > 0
        //if ___ {stuff} else {things} can also be written -> something = some condition
        return true
    }
}
