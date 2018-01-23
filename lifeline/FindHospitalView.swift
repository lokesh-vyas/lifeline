//
//  FindHospitalView.swift
//  lifeline
//
//  Created by Anjali on 21/12/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class FindHospitalView: UIViewController {
    
    var locationManager = CLLocationManager()
    var placesClient : GMSPlacesClient?
    var camera : GMSCameraPosition?
    var mapView = GMSMapView()
    var addresstring = String()
    var searchController: UISearchController?
    var coordinates : CLLocationCoordinate2D?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var addressFormat = AddressString()
    var delegate:MyAddressFormat?
    var checkBool:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        self.navigationItem.title = MultiLanguage.getLanguageUsingKey("ADDRESS_MAP_TITLE")
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                self.openSettingsForDisableMap()
            case .authorizedWhenInUse:
                self.goToInCurrentLoction()
            default:
                self.openSettingsForDisableMap()
            }
            self.getPlacePickerView()
        } else
        {
            self.openSettingsForDisableMap()
        }
        self.getPlacePickerView()
    }
    
    func goToInCurrentLoction()
    {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        if addresstring.characters.count >= 7
        {
            self.SearchWithString(AdressString: addresstring)
            
        }else
        {
            self.currentLoctionSearch()
        }
    }
    func currentLoctionSearch()
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() == true {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        camera = GMSCameraPosition.camera(withLatitude: SingleTon.SharedInstance.currentLatitude, longitude: SingleTon.SharedInstance.currentLongitude, zoom :15.0)
        
        mapView = GMSMapView.map(withFrame: .zero, camera:camera!)
        placesClient = GMSPlacesClient.shared()
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self as? GMSMapViewDelegate
        view = mapView
        mapView.accessibilityLanguage = "en"
        mapView.isBuildingsEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
    }
    func getPlacePickerView() {
        
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    //MARK:- openSettingsForDisableMap
    func openSettingsForDisableMap()
    {
        let alertController = UIAlertController (title: MultiLanguage.getLanguageUsingKey("LOCATION_TITLE_WARNING"), message: MultiLanguage.getLanguageUsingKey("LOCATION_MESSAGE_WARNING"), preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: MultiLanguage.getLanguageUsingKey("TOAST_SETTING_TITLE"), style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                } else {
                    if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
                        UIApplication.shared.openURL(settingsURL as URL)
                    }
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_CANCEL"), style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func SearchWithString(AdressString:String)
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(AdressString, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error of map", error!)
                //self.currentLoctionSearch()
            }
            if let placemark = placemarks?.first {
                self.coordinates = placemark.location!.coordinate
                self.searchLocationMarkers()
            }
        })
    }
    //MARK:- Search Locations
    func searchLocationMarkers()
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        mapView.clear()
        let marker = GMSMarker()
        marker.position = coordinates!
        marker.icon = UIImage(named: "Current_icon")
        marker.map = mapView
        mapView.delegate = self as? GMSMapViewDelegate
        camera = GMSCameraPosition.camera(withLatitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!, zoom: 15.0)
        mapView.camera = camera!
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view = mapView
        
        mapView.isBuildingsEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSearchTapped(_ sender: Any) {
        self.getPlacePickerView()
    }
}
extension FindHospitalView: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        coordinates = place.coordinate
        self.searchLocationMarkers()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Place Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension FindHospitalView : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if manager.location?.coordinate.latitude != nil || manager.location?.coordinate.latitude != 0 {
            manager.stopUpdatingLocation()
            print("Updation Stopped !!")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in CLM delegate:", error.localizedDescription)
    }
    
}

extension FindHospitalView : GMSPlacePickerViewControllerDelegate
{
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        print("inside didpick condition")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        print("inside cancel fuction")
        viewController.dismiss(animated: true, completion: nil)
    }
}
