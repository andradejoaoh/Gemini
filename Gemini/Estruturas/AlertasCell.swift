//
//  AlertasCell.swift
//  Gemini
//
//  Created by João Henrique Andrade on 05/01/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit
class AlertasCell: UITableViewCell {
    @IBOutlet weak var imagemAlerta: UIImageView!
    @IBOutlet weak var idAnimal: UILabel!
    @IBOutlet weak var mensagemAlerta: UILabel!
    
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
