//
//  MapaViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController{
    @IBOutlet weak var mapOutlet: MKMapView!
    let locationManager = CLLocationManager()
    var animais: [Animal] = []
    var fazenda:Fazenda?
     override func viewDidLoad() {
        super.viewDidLoad()
        animais = JSONHandler.shared.animais
        fazenda = JSONHandler.shared.fazenda
        if fazenda != nil {
            let initialLocation = CLLocation(latitude: fazenda!.latitude, longitude: fazenda!.longitude)
            centerMapOnLocation(location: initialLocation)
        }
        mapOutlet.mapType = .satellite
        checkLocationServices()
        adicionarPins()
    }
    
    
    func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {
        // Show alert letting the user know they have to turn this on.
      }
    }
    
    func checkLocationAuthorization() {
      switch CLLocationManager.authorizationStatus() {
      case .authorizedWhenInUse:
        mapOutlet.showsUserLocation = true
      // For these case, you need to show a pop-up telling users what's up and how to turn on permisneeded if needed
      case .denied:
        break
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        mapOutlet.showsUserLocation = true
      case .restricted:
        break
      case .authorizedAlways:
        break
      @unknown default:
        fatalError()
        }
    }
    
    func adicionarPins() {
        for animal in animais {
            let animalID = "ID: " + animal.id
            let animalBateria = "Bateria: " + String(animal.bateria) + "%"
            let animalCoordenada = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
            let animalPin = PinMapa(id: animalID, bateria: animalBateria, coordinate: animalCoordenada)
            mapOutlet.addAnnotation(animalPin)
        }
    }
    func centerMapOnLocation(location: CLLocation) {
        guard let fazenda = fazenda else {return}
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: Double(fazenda.raioDaFazenda), longitudinalMeters: Double(fazenda.raioDaFazenda))
        mapOutlet.setRegion(coordinateRegion, animated: true)
    }
}
