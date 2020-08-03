//
//  Places.swift
//  Foursquare Clone
//
//  Created by sarath kumar on 02/08/20.
//  Copyright © 2020 sarath kumar. All rights reserved.
//

import Foundation
import UIKit

class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    
    private init() {}
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = Double()
    var placeLogitude = Double()
}
