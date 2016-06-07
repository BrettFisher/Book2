//
//  Checklist.swift
//  Checklists
//
//  Created by M.I. Hollemans on 30/07/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding
{
    var name = ""
    var items = [ChecklistItem]()//this is an array that can hold ChecklistItem objects
  
    init(name: String)
    {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
    }
}
