//
//  SelectLocationViewController.swift
//  Foursquare Clone
//
//  Created by sarath kumar on 02/08/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit
import MapKit
import Parse

class SelectLocationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    var saveBarButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    // MARK: - Custom Methods
    
    private func setupUI() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveBarButton
        saveBarButton.isEnabled = false
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        let mapGesture = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        mapGesture.minimumPressDuration = 3
        mapView.addGestureRecognizer(mapGesture)
    }
    
    // MARK: - Action Methods
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = coordinates.latitude
            PlaceModel.sharedInstance.placeLogitude = coordinates.longitude
            
            saveBarButton.isEnabled = true
        }
    }
    
    @objc func saveAction() {
        
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Place")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["logitude"] = placeModel.placeLogitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpeg", data: imageData)
        }
        
        object.saveInBackground { (success, error) in
            if error != nil {
                self.showAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "error")
            } else {
                self.performSegue(withIdentifier: "selectLocationToNavigation", sender: nil)
            }
        }
    }

   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       //locationManager.stopUpdatingLocation()
       let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
       let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
       let region = MKCoordinateRegion(center: location, span: span)
       mapView.setRegion(region, animated: true)
   }

}
