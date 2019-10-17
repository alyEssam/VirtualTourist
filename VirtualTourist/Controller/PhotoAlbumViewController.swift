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
import SVProgressHUD

private let collectionCellIdentifier = "imageFlickerCell"

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegateFlowLayout{
    
    var currentPage = 0
    var photoData = [Photo]()
    var selectedPin: Pin!
    var itemsSelected = [IndexPath]()
    var photosSelected = false
    var initalLocation : CLLocation!
    let regionRadius: CLLocationDistance = 1000

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionOutlet: UIButton!
    // PhotoAlbumViewController Life Cycle
    override func viewDidLoad() {
      super.viewDidLoad()
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
    }

    //IBOutlets
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func getNewCollection(_ sender: UIButton) {
 
        if photosSelected{
            //Delete Photos
            removePhotos()
            self.collectionView.reloadData()
            photosSelected = false
            newCollectionOutlet.setTitle("New Collection", for: .normal)
        }
        else {
            //Add new Collection
            newCollectionOutlet.isEnabled = false
            for photo in photoData {
                appDelegate.getContext().delete(photo)
            }
            photoData.removeAll()
            saveItems()
            currentPage += 1
            getFlickrPhotosURL(page: currentPage)
        }
        
    }
    func removePhotos() {
    if itemsSelected.count > 0 {
       for indexPath in itemsSelected {
           let photo = photoData[indexPath.item]
           appDelegate.getContext().delete(photo)
           self.photoData.remove(at: indexPath.item)
           self.collectionView.deleteItems(at: [indexPath as IndexPath])
           //print("Photo at row \(indexPath.row) was deleted")
        }
    itemsSelected.removeAll()
    saveItems()
    }
        //itemsSelected = [IndexPath]()
   }
    //MARK:- Save the context
    func saveItems(){
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    // MARK: - Fetch Photos
    func fetchPhotos(){
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin = %@", selectedPin!)
        let context = appDelegate.getContext()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        if let data = fetchedResultsController.fetchedObjects, data.count > 0 {
            photoData = data
            self.collectionView.reloadData()
        } else {
            getFlickrPhotosURL(page: currentPage)
        }
    }
    
    // MARK: - Networking
    func getFlickrPhotosURL(page: Int){
        FlickerClient.getImagesFromFlickr(selectedPin, page, completion: getFlickerPhotosURLResponse(photosArray: error:))
   }
    func getFlickerPhotosURLResponse( photosArray: [Photo]?, error: Error?){
        guard error == nil else {
            raiseAlertView(withTitle: "Unable to get photos from Flickr", withMessage: error?.localizedDescription ?? "")
            return
        }
        /* Add results to photoData and reload collectionView */
        DispatchQueue.main.async {
            if photosArray!.count > 0 {
            self.photoData = photosArray!
            //print("\(self.photoData.count) photos from Flickr fetched")
            self.collectionView.reloadData()
            }
            else {
                if self.currentPage == 0{
                    self.raiseAlertView(withTitle: "Can not get any photos", withMessage: "Can not get any photos, Please choice another location or try again")
                } else {
                    self.currentPage = 0
                    self.getFlickrPhotosURL(page: self.currentPage)
                }
            }
            self.newCollectionOutlet.isEnabled = true
        }
    }
    
}


// MARK:- CollectionView Data Source Methods
/***************************************************************/
extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return photoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! FlickerImageCell

          let photo = photoData[indexPath.row]
            cell.flickerImage.image = UIImage(named: "placeholder")
            cell.flickerImage.alpha = 1.0
            SVProgressHUD.show()
            if photo.imageData != nil {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                 cell.flickerImage.image = UIImage(data: photo.imageData! as Data)
            } else {
                if let imageURL = URL(string: photo.urlString!){
                FlickerClient.requestImagePhoto(url: imageURL) { (results, error) in
                guard let imageData = results else {
                self.raiseAlertView(withTitle: "Image data error", withMessage: error?.localizedDescription ?? "")
                SVProgressHUD.dismiss()
                return
                }
                DispatchQueue.main.async{
                    photo.imageData = imageData as Data?
                    SVProgressHUD.dismiss()
                    cell.flickerImage.image = UIImage(data: photo.imageData! as Data)
                    
                  }
                }
              }
            }
            return cell
    }
}
extension PhotoAlbumViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    let cell = collectionView.cellForItem(at: indexPath) as! FlickerImageCell
    
        let index = itemsSelected.firstIndex(of: indexPath)
    
    if let index = index {
        itemsSelected.remove(at: index)
        cell.flickerImage.alpha = 1.0
    } else {
        itemsSelected.append(indexPath)
        //print(itemsSelected)
        cell.flickerImage.alpha = 0.25
    }
    
    if itemsSelected.count > 0 {
        newCollectionOutlet.setTitle("Delete", for: .normal)
        photosSelected = true
        
    } else {
        newCollectionOutlet.setTitle("New Collection", for: .normal)
        photosSelected = false
    }

    }
}

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




