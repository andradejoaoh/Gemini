//
//  MapaViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapOutlet: MKMapView!
    let locationManager = CLLocationManager()
    var animais: [Animal] = []
    var annotationPins: [PinMapa] = []
    var fazenda: Fazenda?
    
     override func viewDidLoad() {
        super.viewDidLoad()
        animais = JSONHandler.shared.animais
        fazenda = JSONHandler.shared.fazenda
        if fazenda != nil {
            let initialLocation = CLLocation(latitude: fazenda!.latitude, longitude: fazenda!.longitude)
            centerMapOnLocation(location: initialLocation)
        }
        mapOutlet.mapType = .satellite
        mapOutlet.delegate = self
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
//            let animalPin = PinMapa(id: animalID, bateria: animalBateria, coordinate: animalCoordenada)
            let animalPin = MKPointAnnotation()
            animalPin.title = animalID
            animalPin.subtitle = animalBateria
            animalPin.coordinate = animalCoordenada
//            annotationPins.append(animalPin)
            mapOutlet.addAnnotation(animalPin)
        }
//        mapOutlet.addAnnotations(annotationPins)
    }
    func centerMapOnLocation(location: CLLocation) {
        guard let fazenda = fazenda else {return}
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: Double(fazenda.raioDaFazenda/5), longitudinalMeters: Double(fazenda.raioDaFazenda/5))
        mapOutlet.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
