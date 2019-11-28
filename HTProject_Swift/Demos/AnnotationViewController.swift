//
//  MapViewController.swift
//  TestSwift
//
//  Created by heming on 16/4/18.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class AnnotationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    var locationManager:CLLocationManager = CLLocationManager()
    var mapView:MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "地图"
        
        mapView = MKMapView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        mapView.mapType = .standard
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        self.startLocation()
    }
    
    func startLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "myId"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
        }
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        leftIconView.image = UIImage(named: "great")
        annotationView?.leftCalloutAccessoryView = leftIconView
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let annotation = MKPointAnnotation()
        annotation.title = "文荟大厦"
        annotation.subtitle = "工作地点"
        annotation.coordinate = (location?.coordinate)!
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingHeading()
    }
}
