//
//  PlaceDetailsViewController.swift
//  Foursquare Clone
//
//  Created by sarath kumar on 02/08/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import UIKit
import MapKit
import Parse

class PlaceDetailsViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeAtmosphereLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLogitude = Double()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        getselectedParseData()
        setMapLocation()
    }
    
    private func setupUI() {
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }
    
    private func getselectedParseData() {
        let query = PFQuery(className: "Place")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        
        query.findObjectsInBackground { (object, error) in
            
            if error != nil {
                self.showAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "error")
            } else {
                if object != nil {
                    if object!.count > 0 {
                        let placeObject = object![0]
                        
                        if let placeName = placeObject.object(forKey: "name") as? String {
                            self.title = placeName
                        }
                        if let placeType = placeObject.object(forKey: "type") as? String {
                            self.placeTypeLabel.text = placeType
                        }
                        if let placeAtmos = placeObject.object(forKey: "atmosphere") as? String {
                            self.placeAtmosphereLabel.text = placeAtmos
                        }
                        if let placelatitude = placeObject.object(forKey: "latitude") as? String {
                            if let latitude = Double(placelatitude) {
                                self.chosenLatitude = latitude
                            }
                        }
                        if let placeLongitude  = placeObject.object(forKey: "longitude") as? String {
                            if let longitude = Double(placeLongitude) {
                                self.chosenLogitude = longitude
                            }
                        }
                        if let imageData = placeObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { (data, error) in
                                if error != nil {
                                    self.imageView.image = UIImage(named: "PlaceholderImage")
                                } else {
                                    self.imageView.image = UIImage(data: data!)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func setMapLocation() {
        
        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLogitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = self.title
        annotation.subtitle = self.placeTypeLabel.text
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLogitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLogitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.title
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                    
                }
            }
            
        }
    }

}
