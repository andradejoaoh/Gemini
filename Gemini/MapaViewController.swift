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
    var selectedAnimalID: String?
    
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
        createAreas()
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .darkContent
        navigationController?.navigationBar.tintColor = .black
        self.title = "Mapa"
        self.navigationController?.title = "Mapa"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
            let animalBateria = animal.bateria
            let animalCoordenada = CLLocationCoordinate2D(latitude: animal.latitude, longitude: animal.longitude)
            let animalPin = PinMapa(id: animalID, bateria: animalBateria, coordinate: animalCoordenada)
            annotationPins.append(animalPin)
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
                
        var annotationView: MKAnnotationView?

        if let annotation = annotation as? PinMapa {
            annotationView = setupCowAnnotation(for: annotation, on: mapView)
        }
        return annotationView
    }
    
    private func setupCowAnnotation(for annotation: PinMapa, on mapView: MKMapView) -> MKAnnotationView {
        let identifier = "Annotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            let rightButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = rightButton
            annotationView?.image = UIImage(named: "goodCowPin")
            if annotation.bateria <= 20 {
                annotationView?.image = UIImage(named: "badCowPin")
            }
            
        } else {
            annotationView!.annotation = annotation
        }
        if #available(iOS 11.0, *) {
            annotationView?.clusteringIdentifier = "mapPinCluster"
        }
        return annotationView!
    }
    
    func createAreas() {
        let areaCoordinates = [CLLocationCoordinate2D(latitude: -20.981, longitude: -50.472),
        CLLocationCoordinate2D(latitude: -20.983, longitude: -50.472),
        CLLocationCoordinate2D(latitude: -20.983, longitude: -50.474),
        CLLocationCoordinate2D(latitude: -20.981, longitude: -50.474)
        ]
        let mapOverlay = MKPolygon(coordinates: areaCoordinates, count: areaCoordinates.count)
        mapOutlet.addOverlay(mapOverlay)
        
        for pin in annotationPins{
            print(mapOverlay.boundingMapRect.contains(MKMapPoint(pin.coordinate)))
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolygon {
            let overlayRender = MKPolygonRenderer(polygon: overlay)
            overlayRender.fillColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            overlayRender.alpha = 0.25
            return overlayRender
        }
        return MKPolygonRenderer()
    }
                                 /* |----------------|
                                    |FUNÇÕES DA SEGUE|
                                    |----------------| */
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard var id = view.annotation?.title!! else { return }
        id.removeFirst(4)
        selectedAnimalID = id
        performSegue(withIdentifier: "fromMapToAnimal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let animalViewController = segue.destination as? AnimalViewController {
            animalViewController.animal = animais.filter{$0.id == selectedAnimalID }.first
        }
    }
    
}
