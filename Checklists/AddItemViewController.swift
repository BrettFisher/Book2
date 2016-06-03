//
//  AddItemViewController.swift
//  Checklists
//
//  Created by M.I. Hollemans on 28/07/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation
import UIKit

//contract between screens
protocol AddItemViewControllerDelegate: class
{
    //this is for pressing cancel()
    func addItemViewControllerDidCancel(controller: AddItemViewController)
    //this is for pressing done()
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate
{

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!

  weak var delegate: AddItemViewControllerDelegate?

  override func viewWillAppear(animated: Bool)
  {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  @IBAction func cancel()
  {
    delegate?.addItemViewControllerDidCancel(self)
  }
  
  @IBAction func done()
  {
    let item = ChecklistItem()
    item.text = textField.text!
    item.checked = false
    
    delegate?.addItemViewController(self, didFinishAddingItem: item)
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
