//
//  MapViewController.swift
//  IesbSocialUiKit
//
//  Created by Pedro Henrique on 21/10/21.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    
    func userDidChooseLocation(_ location: CLLocationCoordinate2D)
    
}

class MapViewController: UIViewController {
    
    var delegate: MapViewControllerDelegate?

   
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            let lp = UILongPressGestureRecognizer(target: self, action: #selector(dropLocationPin(_:)))
            lp.minimumPressDuration = 1.5
            mapView.addGestureRecognizer(lp)
        }
    }

    
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return lm
    }()
    
    
    var desiredLocation: CLLocationCoordinate2D? {
        didSet {
            if let location = desiredLocation {
                delegate?.userDidChooseLocation(location)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestPermission()
    }
    
    private func requestPermission() {
        let authorizationStatus = locationManager.authorizationStatus
        if authorizationStatus == .notDetermined || authorizationStatus == .denied {
            locationManager.requestWhenInUseAuthorization()
        }
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }
    
    @objc private func dropLocationPin(_ sender: UILongPressGestureRecognizer) {
        
        let longPressPoint = sender.location(in: mapView)
        let coordinate = mapView.convert(longPressPoint, toCoordinateFrom: mapView)
        desiredLocation = coordinate
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Localização Indicada"
        
        mapView.addAnnotation(annotation)
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !annotation.isKind(of: MKUserLocation.self) {
            
            let detailView = UILabel()
            detailView.text = annotation.title ?? "Desconhecido"
            detailView.sizeToFit()
            
            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "localizacao")
            view.isDraggable = true
            view.canShowCallout = true
            view.detailCalloutAccessoryView = detailView
            view.glyphImage = UIImage(systemName: "car")
            view.markerTintColor = UIColor.cyan
            view.glyphTintColor = UIColor.black
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .none || newState == .ending {
            desiredLocation = view.annotation?.coordinate
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let currentLocation = locations.last {
            let camera = MKMapCamera(lookingAtCenter: currentLocation.coordinate,
                                     fromDistance: 3000,
                                     pitch: 0,
                                     heading: 0)
            mapView.setCamera(camera, animated: true)
        }
        
    }
    
    
}
