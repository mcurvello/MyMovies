//
//  MapViewController.swift
//  MyMovies
//
//  Created by Marcio Curvello on 13/08/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        requestAuthorization()
    }
    
    func requestAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if error == nil {
                guard let response = response else {return}
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                for item in response.mapItems {
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.url?.absoluteString
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
}
