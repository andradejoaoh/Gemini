//
//  AnimalCell.swift
//  Gemini
//
//  Created by João Henrique Andrade on 29/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import UIKit
class AtividadesCell: UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var acaoLabel: UILabel!
    
    override var frame: CGRect {
      get {
          return super.frame
      }
      set (newFrame) {
          var frame = newFrame
          frame.origin.y += 2
          frame.size.height -= 5
          super.frame = frame
      }
    }
}
