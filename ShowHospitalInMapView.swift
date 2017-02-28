//
//  ShowHospitalInMapView.swift
//  lifeline
//
//  Created by AppleMacBook on 25/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ShowHospitalInMapView: UIViewController
{

    var addresstring = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func loadView()
    {
        let camera = GMSCameraPosition.camera(withLatitude: 12.91, longitude: 77.61, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView

        // Creates a marker in the center of the map.
        
        
        let address = "1 Infinite Loop, CA, USA"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error of map", error!)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                coordinates.latitude
                coordinates.longitude
                print("lat", coordinates.latitude)
                print("long", coordinates.longitude)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                marker.title = "CA"
                marker.snippet = "USA"
                marker.map = mapView

            }
        })
        
        
        
    }
}
