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
    
    /* |-------------------|
       |VARIÁVEIS E OUTLETS|
       |-------------------| */
    
    @IBOutlet weak var mapOutlet: MKMapView!
    let locationManager = CLLocationManager()
    var animais: [Animal] = []
    var annotationPins: [PinMapa] = []
    var fazenda: Fazenda?
    var latitudeInicial: Double?
    var longitudeInicial: Double?
    
                               /* |---------------|
                                  |FUNÇÕES DA VIEW|
                                  |---------------| */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animais = JSONHandler.shared.animais
        fazenda = JSONHandler.shared.fazenda
        if latitudeInicial != nil && longitudeInicial != nil{
            let initialLocation = CLLocation(latitude: latitudeInicial!, longitude: longitudeInicial!)
            centerMapOnLocation(location: initialLocation)
        } else {
            let initialLocation = CLLocation(latitude: fazenda!.latitude, longitude: fazenda!.longitude)
            centerMapOnLocation(location: initialLocation)
        }
        mapOutlet.mapType = .satellite
        mapOutlet.delegate = self
        checkLocationServices()
        adicionarPins()

    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.tintColor = .white

    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.tintColor = .black
        self.title = "Mapa"
        self.navigationController?.title = "Mapa"
    }
    
                           /* |---------------------|
                              |PEDIDO DE LOCALIZAÇÃO|
                              |---------------------| */
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
    
                                 /* |---------------|
                                    |FUNÇÕES DO MAPA|
                                    |---------------| */
    
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
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}
