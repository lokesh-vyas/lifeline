//
//  MyNotificationModel.swift
//  lifeline
//
//  Created by iSteer Technologies  Pvt. Ltd. on 15/11/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NotificationUpdateProtocol {
   func didSucess()
   func didFail()
}
class MyNotificationModel{
    var NotificationId : Int?
    var ReadStatus : Int?
    var Message : String?
    var NotificationType : Int?
    var Title : String?
    var CampaignID : Int?
    var RequestID : Int?
    var DonationID : Int?
    var sendOnTime : String?
}

class MyNotificationViewModel{
    static var SharedInstance: MyNotificationViewModel {
        struct Shared {
            static let Instance = MyNotificationViewModel()
        }
        return Shared.Instance
    }
    var delegate : NotificationUpdateProtocol?
    var NotificationList = [MyNotificationModel]()
    //MARK:- Get Notification
    func MyNotificationServerCall(){
        let reqBody : Dictionary =
            ["LoginID" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)"]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_GET_NOTIFICATIONS.rawValue, method: "POST", parameters: reqBody,sucess: { (JSONResponse) -> Void in
            
                if(JSONResponse["notifications"]) == JSON.null
                {
                    self.delegate?.didFail()
                }
                else
                {
                    var notificationArray = JSONResponse["notifications"]["notification"]
                    if ((notificationArray as? JSON)?.dictionary) != nil {
                        notificationArray = JSON.init(arrayLiteral: notificationArray)
                    }
                    if((notificationArray.array?.count)! > 0)
                    {
                        for i in 0..<notificationArray.count
                        {
                            let notificationlistmodel = MyNotificationModel()
                            let Dict = notificationArray[i].dictionaryValue
                            print("My Notification Data = \(Dict)")
                            notificationlistmodel.Message = Dict["Message"]?.string
                            notificationlistmodel.Title = Dict["Title"]?.string
                            notificationlistmodel.NotificationId = Dict["notificationid"]?.int
                            notificationlistmodel.ReadStatus = Dict["ReadStatus"]?.int
                            notificationlistmodel.NotificationType = Dict["Type"]?.int
                            notificationlistmodel.CampaignID = Dict["CampaignID"]?.int
                            notificationlistmodel.RequestID = Dict["RequestID"]?.int
                            notificationlistmodel.DonationID = Dict["DonationID"]?.int
                            self.NotificationList.append(notificationlistmodel)
                        }
                        self.delegate?.didSucess()
                    }
                    else
                    {
                        self.delegate?.didFail()
                    }
                }
        }, failure:
            { (Response) -> Void in
                print("Here in failure....")
                self.delegate?.didFail()
        })
    }
    //MARK:- Get Update Notification
    func MyNotificatonUpdate(NotificationId: Int) {
        let reqBody : Dictionary =
            ["UpdateNotification":["NotificationId" : NotificationId,"ReadStatus": 1 ]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_UPDATE_NOTIFICATON.rawValue, method: "POST", parameters: reqBody,sucess:
            {
                (JSONResponse) -> Void in
                if(JSONResponse["UpdateNotification"]["StatusCode"].int == 0)
                {
                    self.delegate?.didSucess()
                }
                else
                {
                    self.delegate?.didFail()
                }
        }, failure:
            { (Response) -> Void in
                self.delegate?.didFail()
        })
    }
    //MARK:- DELETE Notification
    func MyNotificationDelete(NotificationId: Int) {
        let reqBody : Dictionary =
            ["DeleteNotification":["NotificationId" : NotificationId]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_DELETE_NOTIFICATION.rawValue, method: "POST", parameters: reqBody,sucess:
            {
                (JSONResponse) -> Void in
                if(JSONResponse["UpdateNotification"]["StatusCode"].int == 0)
                {
                    self.delegate?.didSucess()
                }
                else
                {
                    self.delegate?.didFail()
                }
        }, failure:
            { (Response) -> Void in
                self.delegate?.didFail()
        })
    }
    // MARK:- Call For Server
}
