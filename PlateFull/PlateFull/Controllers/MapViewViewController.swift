//
//  MapViewViewController.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 25.07.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    init?(coder: NSCoder, restaurants: [Restaurant]) {
        self.restaurants = restaurants
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var restaurants: [Restaurant]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAnnotations()
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: restaurants[7].latitude, longitude: restaurants[0].longitude), span: MKCoordinateSpan(latitudeDelta: 0.16, longitudeDelta: 0.12)), animated: true)
    }
    
    func addAnnotations() {
        for restaurant in restaurants {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            annotation.title = restaurant.name
            annotation.subtitle = restaurant.dietaryRestrictions.reduce("") { $0 + $1.rawValue.emoji }
            self.mapView.addAnnotation(annotation)
        }
    }
}
