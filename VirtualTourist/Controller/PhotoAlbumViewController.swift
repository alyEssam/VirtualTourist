//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Aly Essam on 9/30/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import CoreData

private let collectionCellIdentifier = "imageFlickerCell"

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    
    var currentPage = 0
    var  photoData = [Photo]()
    var selectedPin: Pin!
    var initalLocation : CLLocation!
    let regionRadius: CLLocationDistance = 1000
    /*
    var selectedPin: Pin?{
        didSet{
            loadLocation()
        }
    }
    */
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    @IBOutlet weak var mapView: MKMapView!



        override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        //collectionView.delegate = self
            let space:CGFloat = 3.0
            let dimensionPortrait = (view.frame.size.width - (2 * space)) / 3.0
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimensionPortrait, height: dimensionPortrait)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadLocation()
        fetchPhotos()

        collectionView!.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func saveItems(){
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.collectionView.reloadData()
    }
 
    
    @IBAction func getNewCollection(_ sender: UIButton) {
        collectionView!.reloadData()
    }
    
    func fetchPhotos(){
        
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin = %@", selectedPin!)
       // let context = CoreDataStack.getContext()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        if let data = fetchedResultsController.fetchedObjects, data.count > 0 {
            print("\(data.count) photos from core data fetched.")
            photoData = data
            self.collectionView.reloadData()
        } else {
            getFlickrPhotos(page: currentPage)
            
        }
    }
    
    
    func getFlickrPhotos(page: Int){
        
    FlickerClient.getImagesFromFlickr(selectedPin, page) { (photosArray, error) in
    guard error == nil else {
    //self.displayAlert(title: "Unable to get photos from Flickr", message: error?.localizedDescription)
    return
    }
    /* Add results to photoData and reload flickrCollectionView */
   // DispatchQueue.main.async {
    if photosArray != nil {
        self.photoData = photosArray!
        print("\(self.photoData.count) photos from Flickr fetched")
        self.collectionView.reloadData()
        }
     //}
    }
   }

    func requestImageFromURLString(photoURLString: String, indexPath: IndexPath){
        FlickerClient.requestImage(photoUrlString: photoURLString) { (data, error) in
            guard let imageFlickerdata = data else {
                print("Error is \(error?.localizedDescription ?? "")")
                return
            }
            print("Successfully requested image!")
            self.photoData[indexPath.item].imageData = imageFlickerdata
            self.saveItems()

        }
      }
}

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! FlickerImageCell
        
        if let imageURL = URL(string: photoData[indexPath.item].urlString!)  {
            FlickerClient.requestImageFile(url: imageURL) { (data, error) in
                guard let data = data else {
                    print("Error is \(error?.localizedDescription ?? "")")
                    return
                }
                print("Successfully requested image!")
                self.photoData[indexPath.item].imageData = data
                let downloadedImage = UIImage(data: data)
                
                DispatchQueue.main.async {
                    
                    if cell.flickerImage.image == nil {
                        cell.flickerImage.image = UIImage(named: "placeholder")
                    }
                        
                    else {
                        cell.flickerImage.image = downloadedImage
                        self.saveItems()
                    }
                }
            }
        }
        else {
            print("image url is not exist!")
            DispatchQueue.main.async {
               cell.flickerImage.image = UIImage(named: "placeholder")
            }
        }
        

       
 
        return cell
    }
    
    
}
/*

    // MARK:- CollectionView Data Source Methods
    /***************************************************************/
    extension PhotoAlbumViewController {
        
 
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
      //  }
       
 
    }
*/

// MARK:- MapView Delegate Methods
/***************************************************************/
extension PhotoAlbumViewController: MKMapViewDelegate{
 
    public func loadLocation ()  {
           
           initalLocation = CLLocation(latitude: selectedPin.latitude, longitude: selectedPin.longitude)
               centerMapOnLocation(location: initalLocation)
    
               // The lat and long are used to create a CLLocationCoordinates2D instance.
           let coordinate = CLLocationCoordinate2D(latitude: selectedPin.latitude, longitude: selectedPin.longitude)
           
               // Here we create the annotation and set its coordiate, title, and subtitle properties
               let annotation = MKPointAnnotation()
               annotation.coordinate = coordinate

               mapView.addAnnotation(annotation)
       }
       
       func centerMapOnLocation(location: CLLocation) {
           let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                     latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
           self.mapView.setRegion(coordinateRegion, animated: true)
       }
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
}




