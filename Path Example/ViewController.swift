//
//  ViewController.swift
//  Path Example
//
//  Created by Nivardo Ibarra on 2/1/16.
//  Copyright © 2016 Nivardo Ibarra. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    private var origin: MKMapItem!
    private var destiny: MKMapItem!
    private var thirdPoint: MKMapItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        var point = CLLocationCoordinate2D(latitude: 19.359727, longitude: -99.257700)
        var place = MKPlacemark(coordinate: point, addressDictionary: nil)
        origin = MKMapItem(placemark: place)
        origin.name = "TEC"
        
        point = CLLocationCoordinate2D(latitude: 19.362896, longitude: -99.268856)
        place = MKPlacemark(coordinate: point, addressDictionary: nil)
        destiny = MKMapItem(placemark: place)
        destiny.name = "Centro Comercial"
        
        
        point = CLLocationCoordinate2D(latitude: 19.358543, longitude: -99.276304)
        place = MKPlacemark(coordinate: point, addressDictionary: nil)
        thirdPoint = MKMapItem(placemark: place)
        thirdPoint.name = "Roundabout"
        
        
        self.setPoint(origin!)
        self.setPoint(destiny!)
        self.setPoint(thirdPoint!)
        
        self.getPath(self.origin, destiny: self.destiny)
        self.getPath(self.destiny, destiny: self.thirdPoint)
    }
    
    func setPoint(point: MKMapItem) {
        let anotation = MKPointAnnotation()
        anotation.coordinate = point.placemark.coordinate
        anotation.title = point.name
        map.addAnnotation(anotation)
    }

    func getPath(origin: MKMapItem, destiny: MKMapItem) {
        let request = MKDirectionsRequest()
        request.source = origin
        request.destination = destiny
//        request.transportType = .Walking
        request.transportType = .Automobile
        let indications = MKDirections(request: request)
        indications.calculateDirectionsWithCompletionHandler({
            (response: MKDirectionsResponse?, error: NSError?) in
            if error != nil {
                print("Error to get the path")
            }else {
                self.showPath(response!)
            }
        })
    }
    
    
    func showPath(response: MKDirectionsResponse) {
        for path in response.routes {
            map.addOverlay(path.polyline, level: MKOverlayLevel.AboveRoads)
            for step in path.steps {
                print(step.instructions)
            }
        }
        let center = origin.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(center, 3000, 3000)
        map.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }

}

