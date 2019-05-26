//
//  MapVC.swift
//  MCondominio
//
//  Created by ROMEU PILON FILHO on 13/05/19.
//  Copyright © 2019 Pegs.com. All rights reserved.
//

import UIKit
import MapKit


class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pointOfInterest: String?
    let lat: CLLocationDegrees = -23.520361
    let long: CLLocationDegrees = -46.680801
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        if let poi = pointOfInterest {
            let ud = UserDefaults.standard
            guard let dLat = Double(ud.string(forKey: "latitude") ?? "0"),let dLong = Double(ud.string(forKey: "longitude") ?? "0") else {return}
            
            let lat = CLLocationDegrees(dLat)
            let long = CLLocationDegrees(dLong)
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            loadPOIs(text: poi)
        }else{
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func condominioLocation(){
        
    }
    
    func loadPOIs(text: String){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if error == nil {
                guard let response = response else{return}
                self.mapView.removeAnnotations(self.mapView.annotations)
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.url?.absoluteString
                    self.mapView.addAnnotation(annotation)
                }
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
        }
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let ud = UserDefaults.standard
        guard let dLat = Double(ud.string(forKey: "latitude") ?? "0"),let dLong = Double(ud.string(forKey: "longitude") ?? "0") else {return}
        
        let lat = CLLocationDegrees(dLat)
        let long = CLLocationDegrees(dLong)
        guard let annotation = view.annotation else {return}
        let coordinate = annotation.coordinate
        
        let baseCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: baseCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error == nil {
                guard let response = response, let route = response.routes.first else {return}
                self.mapView.removeOverlays(mapView.overlays)
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
            }
        }
    }
}

