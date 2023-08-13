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
        
        mapView.delegate = self
        
        requestAuthorization()
    }
    
    func requestAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? SiteViewController, let site = sender as? String {
            vc.site = site
        }
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation, let name = annotation.title else {return}
        
        let alert = UIAlertController(title: name, message: "O que deseja fazer?", preferredStyle: .actionSheet)
        
        if let subtitle = annotation.subtitle, let url = subtitle {
            let urlAction = UIAlertAction(title: "Acessar site", style: .default) { (action) in
                self.performSegue(withIdentifier: "webSegue", sender: url)
            }
            alert.addAction(urlAction)
        }
        
        let routeAction = UIAlertAction(title: "Traçar rota", style: .default) { (action) in
            self.showRoute(to: annotation.coordinate)
        }
        alert.addAction(routeAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.lineWidth = 8.0
            renderer.strokeColor = .blue
            
            return renderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func showRoute(to destination: CLLocationCoordinate2D) {
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            if error == nil {
                guard let response = response, let route = response.routes.first else {return}
                
                print("Nome:", route.name, "- distância:", route.distance, "- duração:", route.expectedTravelTime)
                
                for step in route.steps {
                    print("Em", step.distance, "metros, ", step.instructions)
                }
                
                self.mapView.removeOverlays(self.mapView.overlays)
                
                self.mapView.addOverlays([route.polyline], level: .aboveRoads)
            }
        }
    }
}
