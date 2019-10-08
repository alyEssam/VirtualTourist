//
//  TravelLocationMapViewController.swift
//  VirtualTourist
//
//  Created by Aly Essam on 9/30/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import MapKit
import CoreData

let identifier = "goToPhotoAlbum"
class TravelLocationMapViewController: UIViewController {
    var pinList = [Pin]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadPins()
    }

    //IBActions :
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        
        let locCoord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        self.mapView.addAnnotation(annotation)
        
        let newPin = Pin(context: self.context)
        newPin.latitude  = locCoord.latitude
        newPin.longitude = locCoord.longitude
        self.pinList.append(newPin)
        self.saveCategouries()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier{
            let photoAlbumVC = segue.destination as! PhotoAlbumViewController
            let selectedPin: Pin = sender as! Pin
            photoAlbumVC.selectedPin = selectedPin}
    }
    
   

    // MARK: - MKMapViewDelegate

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
//Save the context
    func saveCategouries(){
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.mapView.reloadInputViews()
    }
    //MARK: - LoadPins
    func loadPins(with request: NSFetchRequest<Pin> = Pin.fetchRequest()){

        do {
            pinList = try context.fetch(request)
            print("There are \(pinList.count) locations")
            var annotations = [MKPointAnnotation]()
            for result in pinList as [Pin] {
                
                let lat = CLLocationDegrees(result.latitude)
                let long = CLLocationDegrees(result.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotations.append(annotation)
                
            }
            DispatchQueue.main.async{
                self.mapView.addAnnotations(annotations)
                print("Annotations added to the map view.")
            }
        }
        catch {
            print("Error Fetching data from context \(error)")
        }
    }
    
}

extension TravelLocationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        let lat = view.annotation?.coordinate.latitude
        let lon = view.annotation?.coordinate.longitude
        print("The selected pin's lat:\(String(describing: lat)), lon:\(String(describing: lon))")
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            let searchResults = try context.fetch(fetchRequest)
            for pin in searchResults as [Pin] {
                if pin.latitude == lat!, pin.longitude == lon! {
                    let selectedPin = pin
                    print("Found pin info.")
                    /* Segue to Photo Album VC */
                    print("Perform segue to the photo album.")
                  //  FlickerClient.searchByLatLon(latitude: lat!, longitude: lon!, completion: handleSearchByLatLonResponse)
                    let photoAlbumVC = self.storyboard?.instantiateViewController(withIdentifier: identifier) as! PhotoAlbumViewController
                
                    photoAlbumVC.selectedPin = selectedPin
                    DispatchQueue.main.async{
                        self.present(photoAlbumVC, animated: true, completion: nil)
                    }
                }
                
            }
        }
        catch {
            print("Error: \(error)")
        }
    }
}
