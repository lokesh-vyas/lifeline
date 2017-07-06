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
import GooglePlacePicker
import CoreLocation


//MARK:- MyRequestProtocol
protocol MyAddressFormat
{
    func SuccessMyAddressFormat(AddressResponse: AddressString,checkBool:Bool)
}
class AddressString
{
    var MessageAddressString :String = ""
    var addressString :String = ""
    var City:String = ""
    var PINCode:String = ""
    var latitude:String = ""
    var longitude:String = ""
}

class ShowHospitalInMapView: UIViewController
{
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
    
    override func viewDidLoad()
    {
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
        } else
        {
            self.openSettingsForDisableMap()
        }
    }
    //MARK:- goToInCurrentLoction
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
        mapView.delegate = self
        view = mapView
        
        mapView.isBuildingsEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
    }
    func SearchWithString(AdressString:String)
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(AdressString, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error of map", error!)
                self.currentLoctionSearch()
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
        mapView.delegate = self
        camera = GMSCameraPosition.camera(withLatitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!, zoom: 15.0)
        mapView.camera = camera!
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view = mapView
        
        mapView.isBuildingsEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = true
    }
    
    @IBAction func btnSearchTapped(_ sender: Any)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    @IBAction func btnbackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension ShowHospitalInMapView : CLLocationManagerDelegate {
    
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
extension ShowHospitalInMapView: GMSAutocompleteViewControllerDelegate {
    
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
extension ShowHospitalInMapView : GMSMapViewDelegate {
    
    public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition){
    }
    public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    }
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    public func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
    {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            //Add this line
            if response == nil
            {
                return
            }

            if let address = response!.firstResult()
            {
                self.addressFormat.MessageAddressString = ("\(address.lines![0]) \(address.lines![1])")
                self.addressFormat.addressString = address.lines![0]
                if address.locality != nil
                {
                     self.addressFormat.City = address.locality!
                }
                if address.postalCode != nil
                {
                    self.addressFormat.PINCode = address.postalCode!
                }
                self.addressFormat.latitude = String(address.coordinate.latitude)
                self.addressFormat.longitude = String(address.coordinate.longitude)
                
                let alert = UIAlertController(title: MultiLanguage.getLanguageUsingKey("BTN_SELECT_ADDRESS"), message: self.addressFormat.MessageAddressString, preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_SELECT"), style: .default, handler:
                    {
                        alert -> Void in
                        if self.checkBool == nil
                        {
                            self.checkBool = true
                        }
                        self.delegate?.SuccessMyAddressFormat(AddressResponse: self.addressFormat,checkBool: self.checkBool!)
                        self.dismiss(animated: true, completion: nil)
                })
                
                alert.addAction(UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_CANCEL"), style: UIAlertActionStyle.destructive, handler: nil))
                
                alert.addAction(saveAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}

