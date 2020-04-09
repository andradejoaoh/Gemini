//
//  MapOverlay.swift
//  Gemini
//
//  Created by João Henrique Andrade on 09/04/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import Foundation
import MapKit

class MapPolygonOverlay: MKPolygon {
    let areaName: String
    let overlay: MKPolygon
    
    init(areaName: String, coordinates: [CLLocationCoordinate2D], count: Int) {
        self.overlay = MKPolygon(coordinates: coordinates, count: count)
        self.areaName = areaName
    }
}
