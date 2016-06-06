//
//  Checklist.swift
//  Checklists
//
//  Created by Fisher, Brett on 6/6/16.
//  Copyright © 2016 Razeware. All rights reserved.
//

import UIKit

class Checklist: NSObject
{
    var name = ""
    
    init(name: String)
    {
        self.name = name
        super.init()
    }
}
