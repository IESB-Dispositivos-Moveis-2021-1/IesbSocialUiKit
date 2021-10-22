//
//  NewUserViewController.swift
//  IesbSocialUiKit
//
//  Created by Pedro Henrique on 21/10/21.
//

import UIKit
import CoreLocation
import Contacts

class NewUserViewController: UITableViewController {

    private var receivedLocation: CLLocationCoordinate2D?
    
    private let geocoder = CLGeocoder()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let location = receivedLocation {
            
            geocoder.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { placemarks, error in
                if let placemark = placemarks?.last, let address = placemark.postalAddress {
                    let endereco = """
                        CEP: \(address.postalCode)
                        Cidade: \(address.city)
                        Logradouro: \(address.subLocality)
                        Rua: \(address.street)
                    """
                    print(endereco)	
                }
            }
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapSegue" {
            if let destination = segue.destination as? MapViewController {
                destination.delegate = self
            }
        }
    }
    

}

extension NewUserViewController: MapViewControllerDelegate {
    func userDidChooseLocation(_ location: CLLocationCoordinate2D) {
        receivedLocation = location
    }
}
