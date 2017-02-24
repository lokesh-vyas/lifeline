//
//  DonateView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
import SwiftyJSON

class DonateView: UIViewController {
    
    var camera : GMSCameraPosition?
    var mapView : GMSMapView?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var locationManager = CLLocationManager()
    var placesClient : GMSPlacesClient?
    var coordinates : CLLocationCoordinate2D?
    var SouthLatitude : CLLocationDegrees?
    var NorthLatitude : CLLocationDegrees?
    var WestLongitude : CLLocationDegrees?
    var EastLongitude : CLLocationDegrees?
    var rLatitude : CLLocationDegrees?
    var rLongitude : CLLocationDegrees?
    var rLocation : CLLocation?
    var rCoordinates : CLLocationCoordinate2D?
    var dataArray : JSON!
    
    var warningView = UIView()
    var warningLabel = UILabel()
    let warningImage = UIImageView()
    var lastEventDate : Date? = nil
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CLLocationManager.locationServicesEnabled()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() == true {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        if locationManager.location?.coordinate.latitude != nil {
            camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude:(locationManager.location?.coordinate.longitude)!, zoom:13.0)
        } else {
            camera = GMSCameraPosition.camera(withLatitude: 12.9716, longitude:77.5946, zoom :13.0)
        }
        mapView = GMSMapView.map(withFrame: .zero, camera:camera!)
        placesClient = GMSPlacesClient.shared()
        mapView?.settings.myLocationButton = true
        mapView?.isMyLocationEnabled = true
        mapView?.delegate = self
        view = mapView
        mapView?.isBuildingsEnabled = true
        mapView?.settings.compassButton = true
        mapView?.settings.indoorPicker = true
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //For Result VC
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        self.definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
        DonateInteractor.sharedInstance.delegate = self
        
    }
    
    //MARK:- backButton
    @IBAction func backButton(_ sender: Any) {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    
    //MARK:- Search Button
    @IBAction func btnSearchTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    //MARK:- Search Locations
    func searchLocationMarkers()  {
        mapView?.clear()
        let marker = GMSMarker()
        marker.position = coordinates!
        marker.icon = UIImage(named: "Current_icon")
        marker.map = mapView
        marker.snippet = "You searched this Location"
        camera = GMSCameraPosition.camera(withLatitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!, zoom: 16.0)
        mapView?.camera = camera!
        view = mapView
        self.bloodDonatingMarkers(responseData: dataArray)
    }
    
    //MARK:- Fetch Blood Request To Donate
    func fetchBloodRequestToDonate() {
        
        let customer : Dictionary = ["BloodRequestSearchRequest":["SearchDetails":["LoginID":"114177301473189791455","minLat":"\(SouthLatitude!)","maxLat":"\(NorthLatitude!)","minLon":"\(WestLongitude!)","maxLon":"\(EastLongitude!)"]]]
        
        let str = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.BloodRequestSearch"
        DonateInteractor.sharedInstance.findingDonateSources(urlString: str, params: customer)
        
    }
    
    //MARK:- Hospital/Individual/Campaign Markers
    func bloodDonatingMarkers(responseData : JSON) {
        
        var dataArray = responseData["BloodRequestSearchResponse"]["BloodRequestDetails"]
        
        if ((dataArray as? JSON)?.dictionary) != nil {
            dataArray = JSON.init(arrayLiteral: dataArray)
        }
        
        for (i, _) in dataArray.enumerated() {
            
            if dataArray[i]["TypeOfOrg"] == 1 {
                if dataArray[i]["IndividualDetails"] == JSON.null {
                    
                    self.rLatitude = dataArray[i]["Latitude"].doubleValue
                    self.rLongitude = dataArray[i]["Longitude"].doubleValue
                    self.rLocation = CLLocation.init(latitude:
                        CLLocationDegrees(self.rLatitude!), longitude: CLLocationDegrees(self.rLongitude!))
                    self.rCoordinates = self.rLocation?.coordinate
                    let myMarker1 = GMSMarker()
                    myMarker1.position = self.rCoordinates!
                    myMarker1.icon = UIImage(named: "Hospital_icon")!
                    myMarker1.map = self.mapView
                    myMarker1.snippet = dataArray[i]["Name"].stringValue
                    self.view = self.mapView

                    
                } else {
                    
                    self.rLatitude = dataArray[i]["Latitude"].doubleValue
                    self.rLongitude = dataArray[i]["Longitude"].doubleValue
                    self.rLocation = CLLocation.init(latitude: CLLocationDegrees(self.rLatitude!), longitude: CLLocationDegrees(self.rLongitude!))
                    self.rCoordinates = self.rLocation?.coordinate
                    let myMarker2 = GMSMarker()
                    myMarker2.position = self.rCoordinates!
                    myMarker2.icon = UIImage(named: "Individual_icon")!
                    myMarker2.snippet = dataArray[i]["Name"].stringValue
                    myMarker2.map = self.mapView
                    self.view = self.mapView
                    
                }
                
            } else if dataArray[i]["TypeOfOrg"] == 2 {
            
                
                print("CASE 2: $CAMP")
                rLatitude = dataArray[i]["Latitude"].doubleValue
                rLongitude = dataArray[i]["Longitude"].doubleValue
                rLocation = CLLocation.init(latitude: CLLocationDegrees(rLatitude!), longitude: CLLocationDegrees(rLongitude!))
                rCoordinates = rLocation?.coordinate
                let myMarker3 = GMSMarker()
                myMarker3.position = rCoordinates!
                myMarker3.userData = dataArray[i]
                myMarker3.icon = UIImage(named: "Camp_icon")!
                print("Camp_icon came ?")
                myMarker3.snippet = dataArray[i]["Name"].stringValue
                myMarker3.map = mapView
                view = mapView
            }
        }
        mapView?.delegate = self
    }
    
    
}

extension DonateView : CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("MyLatitude :\((manager.location?.coordinate.latitude)!) and MyLongitude : \((manager.location?.coordinate.longitude)!)")
        
        if manager.location?.coordinate.latitude != nil || manager.location?.coordinate.latitude != 0 {
            manager.stopUpdatingLocation()
            print("Updation Stopped !!")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in CLM delegate:", error.localizedDescription)
    }
    
}

extension DonateView : GMSMapViewDelegate {
    
    public func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("willMove")
    }
    
    public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        print("didChange")
        
        if lastEventDate != nil {
            let latestTime = Date()
            let didChangeInterval = latestTime.timeIntervalSince(lastEventDate!)
            
                if didChangeInterval < 0.5 {
                return
                }
            }
        
        
        lastEventDate = Date()
        let visibleRegion = mapView.projection.visibleRegion()
        let mapBounds = GMSCoordinateBounds.init(region: visibleRegion)
        let NorthWest = CLLocationCoordinate2DMake(mapBounds.northEast.latitude, mapBounds.southWest.longitude)
        let SouthEast = CLLocationCoordinate2DMake(mapBounds.southWest.latitude, mapBounds.northEast.longitude)
        
        SouthLatitude = SouthEast.latitude
        NorthLatitude = NorthWest.latitude
        WestLongitude = NorthWest.longitude
        EastLongitude = SouthEast.longitude
        
        self.fetchBloodRequestToDonate()
    }
    
    public func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
    }
    
    public func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("didTapAt")
        
        
    }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        lastEventDate = Date()
        return true
    }
}

extension DonateView: GMSAutocompleteViewControllerDelegate {
    
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

extension DonateView : GMSAutocompleteResultsViewControllerDelegate {
    
    public func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        
        searchController?.isActive = false
        coordinates = place.coordinate
        self.searchLocationMarkers()
        print("ResultPlace name: \(place.name)")
    }
    
    public func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("REsult Place Error: ", error.localizedDescription)
    }
    
    public func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
    
    public func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension DonateView : DonateViewProtocol {
    func successDonateSources(jsonArray: JSON) {
        
        if jsonArray["BloodRequestSearchResponse"] == JSON.null || jsonArray["BloodRequestSearchResponse"]["BloodRequestSearchResponseDetails"]["StatusCode"] == 1 {
            print("No Requirements in your location")
            //warningView
            warningView.backgroundColor = UIColor.white
            warningView.translatesAutoresizingMaskIntoConstraints = false
            warningView.layer.cornerRadius = 27.5
            
           
            //warningLabel
            warningLabel.text = "No Requirements in your location"
//            warningLabel.textAlignment = .center
            warningLabel.numberOfLines = 2
            warningLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // warningImage
            warningImage.image = UIImage(named: "error-sign.png")
            warningImage.translatesAutoresizingMaskIntoConstraints = false
            
            self.warningView.addSubview(warningLabel)
            self.warningView.addSubview(warningImage)
            self.mapView?.addSubview(warningView)
            self.view = self.mapView
            
            //AutoLayout Constraint
            //-//warning View Height
            let warningViewHeightConstraint = NSLayoutConstraint(
                item: warningView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: 55)
            
            //warning ViewLeading
             let warningViewLeadingConstraints = NSLayoutConstraint(
                item: warningView,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: view,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1,
                constant: 10)
            
            //warning View Trailing
             let warningViewTrailingConstraints = NSLayoutConstraint(
                item: warningView,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: view,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1,
                constant: -75)
            
            //warning View Bottom
             let warningViewBottomConstraints = NSLayoutConstraint(
                item: warningView,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: view,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1,
                constant: -10)
            
            //-//warning Label Leading
            let warningLabelLeadingConstraints = NSLayoutConstraint(
                item: warningLabel,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: warningView,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1,
                constant: 55)
            
            //warning Label Trailing
            let warningLabelTrailingConstraints = NSLayoutConstraint(
                item: warningLabel,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: warningView,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1,
                constant: -10)
            
            //Label Vertical constraint
            let warningLabelVerticalConstraint = NSLayoutConstraint(
                item: warningLabel,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: warningView,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1,
                constant: 0)
            
            //-//warning Image Leading
            let warningImageLeadingConstraints = NSLayoutConstraint(
                item: warningImage,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: warningView,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1,
                constant: 5)
            
            //warning Image Top
            let warningImageTopConstraints = NSLayoutConstraint(
                item: warningImage,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: warningView,
                attribute: NSLayoutAttribute.top,
                multiplier: 1,
                constant: 5)
            
            //warning Image Bottom
            let warningImageBottomConstraints = NSLayoutConstraint(
                item: warningImage,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: warningView,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1,
                constant: -5)
            
            //warning Image width
            let warningImageWidthConstraint = NSLayoutConstraint(
                item: warningImage,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: 45)
            
            view.addConstraint(warningViewHeightConstraint)
            view.addConstraint(warningViewLeadingConstraints)
            view.addConstraint(warningViewTrailingConstraints)
            view.addConstraint(warningViewBottomConstraints)
            
            view.addConstraint(warningLabelLeadingConstraints)
            view.addConstraint(warningLabelTrailingConstraints)
            view.addConstraint(warningLabelVerticalConstraint)
            
            view.addConstraint(warningImageLeadingConstraints)
            view.addConstraint(warningImageTopConstraints)
            view.addConstraint(warningImageBottomConstraints)
            view.addConstraint(warningImageWidthConstraint)
            
        } else {
            
            warningView.removeFromSuperview()
            self.bloodDonatingMarkers(responseData: jsonArray)
            
        }
    }
    func failedDonateSources() {
        print("Failed to get Donate resources !!")
            }
}




