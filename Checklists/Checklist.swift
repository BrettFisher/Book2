//
//  Checklist.swift
//  Checklists
//
//  Created by M.I. Hollemans on 30/07/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class Checklist: NSObject {
  var name = ""
  
  init(name: String) {
    self.name = name
    super.init()
  }
}
