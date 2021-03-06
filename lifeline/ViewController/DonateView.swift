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
    var mapView = GMSMapView()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var locationManager = CLLocationManager()
    var placesClient  : GMSPlacesClient?
    var coordinates   : CLLocationCoordinate2D?
    var SouthLatitude : CLLocationDegrees?
    var NorthLatitude : CLLocationDegrees?
    var WestLongitude : CLLocationDegrees?
    var EastLongitude : CLLocationDegrees?
    var rLatitude     : CLLocationDegrees?
    var rLongitude    : CLLocationDegrees?
    var rLocation     : CLLocation?
    var rCoordinates  : CLLocationCoordinate2D?
    var dataArray     : JSON!
    var viewWarning   = UIView()
    var labelWarning  = UILabel()
    let imageWarning  = UIImageView()
    let btnListofMarkers = UIButton()
    var lastEventDate : Date? = nil
    var loader : Bool?
    var InternetIssue : Bool?
    var appendsListMarkers : [Dictionary<String, Any>] = []
    
    var currentLat : CLLocationDegrees!
    var currentLong : CLLocationDegrees!
    
    var count : Int = 0
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = true
        InternetIssue = true
        
         count = count + 1
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(DonateView.bloodDonatingMarkers(responseData: "")), name: NSNotification.Name(rawValue: "DataFilter"), object: nil)
        //        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    //MARK:- viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //btnListofMarkers.isHidden = true
        self.navigationController?.completelyTransparentBarForDonate()
        
        //For Result VC
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        self.definesPresentationContext = true
        searchController?.hidesNavigationBarDuringPresentation = false
        DonateInteractor.sharedInstance.delegate = self
        
    }
    //MARK:- GoToInCurrentLoction
    func goToInCurrentLoction()
    {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() == true {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        camera = GMSCameraPosition.camera(withLatitude: SingleTon.SharedInstance.currentLatitude, longitude:SingleTon.SharedInstance.currentLongitude, zoom :15.0)
        
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
    
    
    //MARK:- PushNotificationView
    func PushNotificationView(_ notification: NSNotification)
    {
        let dict = notification.object as! Dictionary<String, Any>
        
        let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
        notificationView.UserJSON = dict
        notificationView.modalPresentationStyle = .overCurrentContext
        notificationView.modalTransitionStyle = .coverVertical
        notificationView.view.backgroundColor = UIColor.clear
        self.present(notificationView, animated: true, completion: nil)
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
    
    //MARK:- Filter Button
    @IBAction func btnFilterTapped(_ sender: Any) {
        SingleTon.SharedInstance.cameFromMarkersList = false
        let filterView = self.storyboard!.instantiateViewController(withIdentifier: "FilterChecks") as! FilterChecks
        filterView.modalPresentationStyle = .overCurrentContext
        filterView.view.backgroundColor = UIColor.clear
        self.navigationController?.present(filterView, animated: true, completion: nil)
    }
    
    //MARK:- Search Locations
    func searchLocationMarkers()  {
        mapView.clear()
        let marker = GMSMarker()
        marker.position = coordinates!
        marker.icon = UIImage(named: "Current_icon")
        marker.map = mapView
        marker.snippet = MultiLanguage.getLanguageUsingKey("SEARCH_LOCATION")
        camera = GMSCameraPosition.camera(withLatitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!, zoom: 18.0)
        mapView.camera = camera!
        view = mapView
    }
    
    //MARK:- Fetch Blood Request To Donate
    func fetchBloodRequestToDonate() {
        
        //FIXME:- LoginID
        let reqBody : Dictionary = ["BloodRequestSearchRequest":
            ["SearchDetails":
                ["LoginID" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)",
                    "minLat" : "\(SouthLatitude!)",
                    "maxLat" : "\(NorthLatitude!)",
                    "minLon" : "\(WestLongitude!)",
                    "maxLon" : "\(EastLongitude!)"
                ]]]
        DonateInteractor.sharedInstance.findingDonateSources(urlString: URLList.BLOOD_REQUEST_SEARCH.rawValue, params: reqBody)
        
    }
    
    //MARK:- Hospital/Individual/Campaign Markers
    func bloodDonatingMarkers(responseData : JSON) {
        
        var dataArray = responseData["BloodRequestSearchResponse"]["BloodRequestDetails"]
        if ((dataArray as? JSON)?.dictionary) != nil {
            dataArray = JSON.init(arrayLiteral: dataArray)
        }
        
        for (i, _) in dataArray.enumerated() {
            
            if dataArray[i]["TypeOfOrg"] == 1  {
                if dataArray[i]["IndividualDetails"] == JSON.null && SingleTon.SharedInstance.isCheckedHospital {
                    
                    self.rLatitude = dataArray[i]["Latitude"].doubleValue
                    self.rLongitude = dataArray[i]["Longitude"].doubleValue
                    self.rLocation = CLLocation.init(latitude:
                    CLLocationDegrees(self.rLatitude!), longitude: CLLocationDegrees(self.rLongitude!))
                    self.rCoordinates = self.rLocation?.coordinate
                    let myMarker1 = GMSMarker()
                    myMarker1.position = self.rCoordinates!
                    myMarker1.userData = dataArray[i]
                    myMarker1.icon = UIImage(named: "Hospital_icon")!
                    myMarker1.map = self.mapView
                    self.view = self.mapView
                    
                    
                } else if dataArray[i]["IndividualDetails"] != JSON.null && SingleTon.SharedInstance.isCheckedIndividual {
                    
                    //                    print("Indi",dataArray)
                    self.rLatitude = dataArray[i]["Latitude"].doubleValue
                    self.rLongitude = dataArray[i]["Longitude"].doubleValue
                    self.rLocation = CLLocation.init(latitude: CLLocationDegrees(self.rLatitude!), longitude: CLLocationDegrees(self.rLongitude!))
                    self.rCoordinates = self.rLocation?.coordinate
                    let myMarker2 = GMSMarker()
                    myMarker2.position = self.rCoordinates!
                    myMarker2.userData = dataArray[i]
                    myMarker2.icon = UIImage(named: "Individual_icon")!
                    myMarker2.map = self.mapView
                    self.view = self.mapView
                    
                }
                
            } else if dataArray[i]["TypeOfOrg"] == 2 && SingleTon.SharedInstance.isCheckedCamp {
                
                rLatitude = dataArray[i]["Latitude"].doubleValue
                rLongitude = dataArray[i]["Longitude"].doubleValue
                rLocation = CLLocation.init(latitude: CLLocationDegrees(rLatitude!), longitude: CLLocationDegrees(rLongitude!))
                rCoordinates = rLocation?.coordinate
                let myMarker3 = GMSMarker()
                myMarker3.position = rCoordinates!
                myMarker3.userData = dataArray[i]
                myMarker3.icon = UIImage(named: "Camp_icon")!
                myMarker3.map = mapView
                view = mapView
            }
        }
        mapView.delegate = self
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        
    }
    
    
}

extension DonateView : CLLocationManagerDelegate {
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("MyLatitude :\((manager.location?.coordinate.latitude)!) and MyLongitude : \((manager.location?.coordinate.longitude)!)")
        
        if manager.location?.coordinate.latitude != nil || manager.location?.coordinate.latitude != 0 {
            manager.stopUpdatingLocation()
            print("Updation Stopped !!")
            
            let loc: CLLocation = locations[locations.count - 1]
            currentLat = loc.coordinate.latitude
            currentLong = loc.coordinate.longitude
            
            print("<=\(currentLat) & \(currentLong)=>")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in CLM delegate:", error.localizedDescription)
    }
    
}

extension DonateView : GMSMapViewDelegate {
    
    
    //FIXME:- removable methods
    public func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
        
    }
    public func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        
        
    }
    
    
    public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        
        if loader == true {
            HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        }
        
        if lastEventDate != nil {
            let latestTime = Date()
            let didChangeInterval = latestTime.timeIntervalSince(lastEventDate!)
            
            if didChangeInterval < 0.5 {
                return
            }
        }
        print("didChange")
        
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
        loader = false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    
        print("I am in idle state...")
        
        
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
    
   
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        lastEventDate = Date()
        var userDict = [String:Any]()
        var jsonDict = JSON.init(dictionaryLiteral: ("Index", marker.userData!))
        jsonDict = jsonDict["Index"]
        print("*******\(jsonDict)********")
        userDict["Name"] = String(describing: jsonDict["Name"])
        userDict["WorkingHours"] = String(describing: jsonDict["WorkingHours"])
        userDict["IOLoginID"] = String(describing: jsonDict["IOLoginID"])
        userDict["IndividualDetails"] = String(describing: jsonDict["IndividualDetails"]["Individuals"][0]["CTypeOfOrg"])
        MarkerData.SharedInstance.IndividualsArray = []
        if jsonDict["IndividualDetails"]["Individuals"][0] != JSON.null { // it is an Array
            var IuserDict = [String : Any]()
            for (index, _) in jsonDict["IndividualDetails"]["Individuals"].enumerated() {
                
                IuserDict["CEmail"] = String(describing: jsonDict["IndividualDetails"]["Individuals"][index]["CEmail"])
                IuserDict["CContactNumber"] = String(describing: jsonDict["IndividualDetails"]["Individuals"][index]["CContactNumber"])
                IuserDict["CID"] = String(describing: jsonDict["IndividualDetails"]["Individuals"][index]["CID"])
                IuserDict["UserName"] = String(describing: jsonDict["IndividualDetails"]["Individuals"][index]["UserName"])
                IuserDict["CTypeOfOrg"] = String(describing: jsonDict["IndividualDetails"]["Individuals"][index]["CTypeOfOrg"])
                IuserDict["CName"] = String(describing: jsonDict["IndividualDetails"]["Individuals"][index]["CName"])
                MarkerData.SharedInstance.IndividualsArray.append(IuserDict)
                
            }
            
        } else { // It is a Dictionary
            
            var IuserDict = [String : Any]()
            IuserDict["CEmail"] = String(describing: jsonDict["IndividualDetails"]["Individuals"]["CEmail"])
            IuserDict["CContactNumber"] = String(describing: jsonDict["IndividualDetails"]["Individuals"]["CContactNumber"])
            IuserDict["CID"] = String(describing: jsonDict["IndividualDetails"]["Individuals"]["CID"])
            IuserDict["UserName"] = String(describing: jsonDict["IndividualDetails"]["Individuals"]["UserName"])
            IuserDict["CTypeOfOrg"] = String(describing: jsonDict["IndividualDetails"]["Individuals"]["CTypeOfOrg"])
            IuserDict["CName"] = String(describing: jsonDict["IndividualDetails"]["Individuals"]["CName"])
            MarkerData.SharedInstance.IndividualsArray.append(IuserDict)
            
        }
        
        userDict["Email"] = String(describing: jsonDict["Email"])
        userDict["Country"] = String(describing: jsonDict["Country"])
        userDict["IOBloodgroup"] = String(describing: jsonDict["IOBloodgroup"])
        userDict["State"] = String(describing: jsonDict["State"])
        userDict["PINCode"] = String(describing: jsonDict["PINCode"])
        userDict["AddressLine"] = String(describing: jsonDict["AddressLine"])
        userDict["LandMark"] = String(describing: jsonDict["LandMark"])
        userDict["ContactNumber"] = String(describing: jsonDict["ContactNumber"])
        userDict["ID"] = String(describing: jsonDict["ID"])
        userDict["City"] = String(describing: jsonDict["City"])
        userDict["AddressId"] = String(describing: jsonDict["AddressId"])
        userDict["TypeOfOrg"] = String(describing: jsonDict["TypeOfOrg"])
        
        if String(describing: jsonDict["FromDate"]).characters.count > 10 {
            let trimDate = String(describing: jsonDict["FromDate"]).substring(to: 10)
            userDict["FromDate"] = trimDate
        } else {
            userDict["FromDate"] = String(describing: jsonDict["FromDate"])
        }
        
        if String(describing: jsonDict["ToDate"]).characters.count > 10 {
            let trimDate = String(describing: jsonDict["ToDate"]).substring(to: 10)
            userDict["ToDate"] = trimDate
        } else {
            userDict["ToDate"] = String(describing: jsonDict["ToDate"])
        }
        
        if jsonDict["TypeOfOrg"] == 1 && jsonDict["IndividualDetails"] != JSON.null { // Individual Marker Details
            
            let markerDetails = self.storyboard?.instantiateViewController(withIdentifier: "MarkerIndividualDetails") as! MarkerIndividualDetails
            //  let nav = UINavigationController(rootViewController: markerDetails)
            MarkerData.SharedInstance.markerData = userDict
            markerDetails.modalPresentationStyle = .overCurrentContext
            markerDetails.view.backgroundColor = UIColor.clear
            self.navigationController?.present(markerDetails, animated: true, completion: nil)
            
        } else if (jsonDict["TypeOfOrg"] == 1 && jsonDict["IndividualDetails"] == JSON.null) || jsonDict["TypeOfOrg"] == 2 {
            // Hospital or Campaign details
            let markerDetails = self.storyboard?.instantiateViewController(withIdentifier: "MarkerNotIndividualDetails") as! MarkerNotIndividualDetails
            //  let nav = UINavigationController(rootViewController: markerDetails)
            MarkerData.SharedInstance.markerData = userDict
            markerDetails.modalPresentationStyle = .overCurrentContext
            markerDetails.view.backgroundColor = UIColor.clear
            self.navigationController?.present(markerDetails, animated: true, completion: nil)
        }
        return false //marker event is still handled by delegate
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
        print("Result Place Error: ", error.localizedDescription)
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
        
        // ListofMarkers
        btnListofMarkers.setImage(UIImage(named : "List-32"), for: .normal)
        
        btnListofMarkers.backgroundColor = UIColor.white
        btnListofMarkers.cornerRadius = 27.5
        btnListofMarkers.layer.shadowColor = UIColor.red.cgColor
        btnListofMarkers.layer.shadowRadius = 5.0
        
        btnListofMarkers.addTarget(self, action:#selector(self.btnListClicked), for: .touchUpInside)
        btnListofMarkers.translatesAutoresizingMaskIntoConstraints = false
        
        self.mapView.addSubview(btnListofMarkers)
        self.view = self.mapView
        
        //ListAutolayout
        //Height
        let listHeightConstraint = NSLayoutConstraint(
            item: btnListofMarkers,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: 55)
        
        //Width
        let listWidthConstraint = NSLayoutConstraint(
            item: btnListofMarkers,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1,
            constant: 55)
        
        //Trailing
        let listTrailingConstraint = NSLayoutConstraint(
            item: btnListofMarkers,
            attribute: NSLayoutAttribute.trailing,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.trailing,
            multiplier: 1,
            constant: -10)
        
        //Vertical Space
        let listVerticalSpaceConstraint = NSLayoutConstraint(
            item: btnListofMarkers,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1,
            constant: -75)
        
        //List
        self.view.addConstraints([listHeightConstraint, listWidthConstraint, listTrailingConstraint, listVerticalSpaceConstraint])
        
        //MARK:- Availability of Markers
        if jsonArray["BloodRequestSearchResponse"] == JSON.null || jsonArray["BloodRequestSearchResponse"]["BloodRequestSearchResponseDetails"]["StatusCode"] == 1 {
            
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            
            //viewWarning
            viewWarning.backgroundColor = UIColor.white
            viewWarning.translatesAutoresizingMaskIntoConstraints = false
            viewWarning.layer.cornerRadius = 27.5
            
            //labelWarning
            labelWarning.text = MultiLanguage.getLanguageUsingKey("NO_REQUIREMENT_WARNING")
            labelWarning.numberOfLines = 2
            labelWarning.adjustsFontSizeToFitWidth = true
            labelWarning.translatesAutoresizingMaskIntoConstraints = false
            
            // imageWarning
            imageWarning.image = UIImage(named: "error-sign.png")
            imageWarning.translatesAutoresizingMaskIntoConstraints = false
            
            self.viewWarning.addSubview(labelWarning)
            self.viewWarning.addSubview(imageWarning)
            self.mapView.addSubview(viewWarning)
            self.view = self.mapView
            
            //AutoLayout Constraint
            //-//warning View Height
            let viewWarningHeightConstraint = NSLayoutConstraint(
                item: viewWarning,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: 55)
            
            //warning ViewLeading
            let viewWarningLeadingConstraints = NSLayoutConstraint(
                item: viewWarning,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: view,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1,
                constant: 10)
            
            //warning View Trailing
            let viewWarningTrailingConstraints = NSLayoutConstraint(
                item: viewWarning,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: view,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1,
                constant: -75)
            
            //warning View Bottom
            let viewWarningBottomConstraints = NSLayoutConstraint(
                item: viewWarning,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: view,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1,
                constant: -10)
            
            //-//warning Label Leading
            let labelWarningLeadingConstraints = NSLayoutConstraint(
                item: labelWarning,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: viewWarning,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1,
                constant: 55)
            
            //warning Label Trailing
            let labelWarningTrailingConstraints = NSLayoutConstraint(
                item: labelWarning,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: viewWarning,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1,
                constant: -10)
            
            //Label Vertical constraint
            let labelWarningVerticalConstraint = NSLayoutConstraint(
                item: labelWarning,
                attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: viewWarning,
                attribute: NSLayoutAttribute.centerY,
                multiplier: 1,
                constant: 0)
            
            //-//warning Image Leading
            let imageWarningLeadingConstraints = NSLayoutConstraint(
                item: imageWarning,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: viewWarning,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1,
                constant: 5)
            
            //warning Image Top
            let imageWarningTopConstraints = NSLayoutConstraint(
                item: imageWarning,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: viewWarning,
                attribute: NSLayoutAttribute.top,
                multiplier: 1,
                constant: 5)
            
            //warning Image Bottom
            let imageWarningBottomConstraints = NSLayoutConstraint(
                item: imageWarning,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: viewWarning,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1,
                constant: -5)
            
            //warning Image width
            let imageWarningWidthConstraint = NSLayoutConstraint(
                item: imageWarning,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: 45)
            
            //subView
            view.addConstraints([viewWarningHeightConstraint, viewWarningLeadingConstraints, viewWarningTrailingConstraints, viewWarningBottomConstraints])
            //Label
            view.addConstraints([labelWarningLeadingConstraints, labelWarningTrailingConstraints, labelWarningVerticalConstraint])
            //image warning
            view.addConstraints([imageWarningLeadingConstraints, imageWarningTopConstraints, imageWarningBottomConstraints, imageWarningWidthConstraint])
            
            SingleTon.SharedInstance.noMarkers = true
            
            
        } else { // when we get marekrs (also when we find another markers through 'No requirements' places)
            
             countsForMarkers(myJSON: jsonArray)
//            viewWarning.removeFromSuperview()
//            SingleTon.SharedInstance.noMarkers = false
//            var tempDict = [String : Any]()
//            var jDict = JSON.init(dictionaryLiteral: ("Index", jsonArray["BloodRequestSearchResponse"]["BloodRequestDetails"]))
//            jDict = jDict["Index"]
//            
//            if jDict["ToDate"].exists() {
//                jDict =  [jDict]
//            }
//            appendsListMarkers.removeAll()
//            
//            for (i, _) in jDict.enumerated() {
//                tempDict["Name"] = jDict[i]["Name"]
//                tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
//                tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
//                tempDict["Individuals"] = jDict[i]["IndividualDetails"]
//                //print("Here is my Info \(String(describing: tempDict["Individuals"]))")
//                appendsListMarkers.append(tempDict)
//            }
//            self.bloodDonatingMarkers(responseData: jsonArray)
        }
    }
    
    func countsForMarkers(myJSON : JSON) {
        
         // when we get marekrs (also when we find another markers through 'No requirements' places)
            viewWarning.removeFromSuperview()
            var tempDict = [String : Any]()
            var jDict = JSON.init(dictionaryLiteral: ("Index", myJSON["BloodRequestSearchResponse"]["BloodRequestDetails"]))
            jDict = jDict["Index"]
            
            if jDict["ToDate"].exists() {
                jDict =  [jDict]
            }
            appendsListMarkers.removeAll()
            
            for (i, _) in jDict.enumerated() {
                
                if jDict[i]["TypeOfOrg"].int == 1 {
                    if String(describing: jDict[i]["IndividualDetails"]) != "null" && SingleTon.SharedInstance.isCheckedIndividual { // Individuals
                        
                        tempDict["Name"] = jDict[i]["Name"]
                        tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                        tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                        tempDict["Individuals"] = jDict[i]["IndividualDetails"]
                        appendsListMarkers.append(tempDict)
                        
                    } else if String(describing: jDict[i]["IndividualDetails"]) == "null" && SingleTon.SharedInstance.isCheckedHospital { // Hospital
                        
                        tempDict["Name"] = jDict[i]["Name"]
                        tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                        tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                        tempDict["Individuals"] = jDict[i]["IndividualDetails"]
                        appendsListMarkers.append(tempDict)
                    }
                    
                } else if jDict[i]["TypeOfOrg"].int == 2 && SingleTon.SharedInstance.isCheckedCamp { // Camps
                    
                    tempDict["Name"] = jDict[i]["Name"]
                    tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                    tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                    
                    if String(describing: jDict[i]["FromDate"]).characters.count > 10 {
                        let trimDate = String(describing: jDict[i]["FromDate"]).substring(to: 10)
                        tempDict["FromDate"] = trimDate
                    }else {
                        tempDict["FromDate"] = String(describing: jDict[i]["FromDate"])
                    }
                    
                    if String(describing: jDict[i]["ToDate"]).characters.count > 10 {
                        let trimDate = String(describing: jDict[i]["ToDate"]).substring(to: 10)
                        tempDict["ToDate"] = trimDate
                    } else {
                        tempDict["ToDate"] = String(describing: jDict[i]["ToDate"])
                    }
                    tempDict["Individuals"] = jDict[i]["IndividualDetails"]
                    appendsListMarkers.append(tempDict)
                    
                } else {
                    SingleTon.SharedInstance.noMarkers = true
                }
                SingleTon.SharedInstance.noMarkers = false
        }
            self.bloodDonatingMarkers(responseData: myJSON)
        
    }
    
    
    //MARK:- List Button action
    func btnListClicked() {
        
        let lists = self.storyboard?.instantiateViewController(withIdentifier: "MarkersListView") as! MarkersListView
//        lists.listMarker2 = JSON.init(dictionaryLiteral: ("Data",appendsListMarkers))
        let tempDictionary = JSON.init(dictionaryLiteral: ("Data",appendsListMarkers))
        SingleTon.SharedInstance.sMarkers = tempDictionary["Data"]
        
        let nav = UINavigationController(rootViewController: lists)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    
    func failedDonateSources(Response:String) {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            if InternetIssue == true {
                InternetIssue = false
               self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
            }
        }else
        {
            if InternetIssue == true {
                InternetIssue = false
                self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
            }
        }
    }
}

//extension DonateView : filterMarkersProtocol {
//    func didSuccessFilters(sender: FilterChecks) {
//        //   TODO:-
//    }
//}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}



