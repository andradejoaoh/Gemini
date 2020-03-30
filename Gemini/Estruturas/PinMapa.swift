//
//  PinMapa.swift
//  Gemini
//
//  Created by João Henrique Andrade on 04/12/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import Foundation
import MapKit
class PinMapa: NSObject, MKAnnotation {
  let id: String?
  let bateria: Int
  let coordinate: CLLocationCoordinate2D
  
  init(id: String, bateria: Int, coordinate: CLLocationCoordinate2D) {
    self.id = id
    self.bateria = bateria
    self.coordinate = coordinate
    super.init()
  }
  
    var subtitle: String? {
        return "Bateria: " + String(bateria) + "%"
    }
    
    var title: String? {
        return id
    }

}
