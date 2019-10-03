//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Aly Essam on 9/30/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var photoLocCoord = ""
    var locationData: CGPoint?
    var locationData2Lat: CLLocationDegrees?
    var locationData2Lon: CLLocationDegrees?

   // let travelLocationVC: TravelLocationMapViewController

        override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
       // let locCoord = self.mapView.convert(locationData!, toCoordinateFrom: self.mapView)
        print(locationData2Lat!)
        print(locationData2Lon!)
   
        let coordinate = CLLocationCoordinate2D(latitude:  locationData2Lat!, longitude: locationData2Lon!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        
        self.mapView.addAnnotation(annotation)
            
            //FlickerClient.searchByLatLon(latitude: locationData2Lat!, longitude: locationData2Lon!)
            FlickerClient.searchByLatLon(latitude: locationData2Lat!, longitude: locationData2Lon!,  completion: handleResponse(imageURL:error:))
  }
    
    //MARK: Handle Network Response
    func handleResponse (imageURL: photo!, error: Error?) {
        if let imageURL = imageURL{
            print("Image URL: \(imageURL)")
        }
        else {
            print("Cannot load image")
        }
    }
}


