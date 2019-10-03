//
//  TravelLocationMapViewController.swift
//  VirtualTourist
//
//  Created by Aly Essam on 9/30/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import MapKit

let identifier = "goToPhotoAlbum"
class TravelLocationMapViewController: UIViewController, MKMapViewDelegate {
var passedData: CGPoint?
var passedData2Lat: CLLocationDegrees?
var passedData2Lon: CLLocationDegrees?

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
          mapView.delegate = self
    }

    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        
        let locCoord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        print(locCoord)
        passedData = location
        
        passedData2Lat = locCoord.latitude
        passedData2Lon = locCoord.longitude
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        self.mapView.addAnnotation(annotation)
    }
    // MARK: - MKMapViewDelegate

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier{
            let photoAlbumVC = segue.destination as! PhotoAlbumViewController
           //photoAlbumVC.photoLocCoord = slocCoord
            photoAlbumVC.locationData = passedData // both are of Type CLLocationManager
            photoAlbumVC.locationData2Lat = passedData2Lat
            photoAlbumVC.locationData2Lon = passedData2Lon

        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        performSegue(withIdentifier: identifier, sender: self)
    }
    
}


