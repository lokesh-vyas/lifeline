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
    var NotifcationId : String?
    var ReadStatus : String?
    var Message : String?
    var NotificationType : String?
    var Title : String?
    var CampaignID : String?
    var RequestID : String?
    var DonationID : String?
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
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_GET_NOTIFICATIONS.rawValue, method: "POST", parameters: reqBody,sucess:
            {
                (JSONResponse) -> Void in
                if((JSONResponse["notifications"]["notification"].array?.count)! > 0)
                {
                     self.MyNotifiactionData(JSONResponse: JSONResponse)
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
    func MyNotifiactionData(JSONResponse : JSON)  {
        for i in 0..<JSONResponse["notifications"]["notification"].count
        {
            let notificationlistmodel = MyNotificationModel()
            let Dict = JSONResponse["userData"]["schedule_list"][i].dictionaryValue
            notificationlistmodel.Message = Dict["Message"]?.string
            notificationlistmodel.Title = Dict["Title"]?.string
            notificationlistmodel.NotifcationId = Dict["notificationid"]?.string
            notificationlistmodel.ReadStatus = Dict["ReadStatus"]?.string
            
             self.NotificationList.append(notificationlistmodel)
        }
         self.delegate?.didSucess()
    }
    //MARK:- Get Update Notification
    func MyNotificatonUpdate(NotificationId: String) {
        let reqBody : Dictionary =
            ["UpdateNotification":["NotificationId" : NotificationId,"ReadStatus":"1"]]
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
    func MyNotificationDelete(NotificationId: String) {
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
