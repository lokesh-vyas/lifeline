//
//  getCommunityModel.swift
//  lifeline
//
//  Created by Anjali on 27/12/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol getCommunityProtocol {
    func didSucess()
    func didFail()
}
class getCommunityModel {
    var Name : String?
    var Description : String?
    var type : String?
    var phone : Int?
    var CreatedOn : String?
    var Logo : String?
    var isBloodbank : Bool?
    var UpdatedOn : String?
    var isActive : Bool?
    var CommunityId : Int?
    var Status : String?
    var ContactPerson : String?
    var LoginId : String?
    var inviteId: Int?
    var inviteStatus: String?
    var userName: String?
    var emailID: String?
}

class getCommunityViewModel {
    static var SharedInstance: getCommunityViewModel {
        struct Shared {
            static let Instance = getCommunityViewModel()
        }
        return Shared.Instance
    }
    var delegate : getCommunityProtocol?
    var getCommunityList = [getCommunityModel]()
    
    //MARK:- MyCommunityServiceCall
    func getMyCommunityServerCall() {
        let reqBody : Dictionary =  ["LoginId" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)"]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_GET_COMMUNITY .rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            if(JSONResponse["CommunityList"]) == JSON.null {
                self.delegate?.didFail()
            }
            else {
                var communityArray = JSONResponse["CommunityList"]["Community"]
                if ((communityArray).dictionary) != nil {
                    communityArray = JSON.init(arrayLiteral: communityArray)
                }
                if((communityArray.array?.count)! > 0) {
                    for i in 0..<communityArray.count {
                        let communitylistmodel = getCommunityModel()
                        let Dict = communityArray[i].dictionaryValue
                        print("My Community Data = \(Dict)")
                        communitylistmodel.Name = Dict["Name"]?.string
                        communitylistmodel.Description = Dict["Description"]?.string
                        communitylistmodel.type = Dict["Type"]?.string
                        communitylistmodel.CommunityId = Dict["CommunityId"]?.int
                        communitylistmodel.isBloodbank = Dict["isBloodbank"]?.bool
                        communitylistmodel.phone = Dict["Phone"]?.int
                        if Dict["LoginId"]?.int != nil {
                            communitylistmodel.LoginId = String(describing: Dict["LoginId"]!)
                        } else {
                            communitylistmodel.LoginId = (Dict["LoginId"]?.string)!
                        }
                        communitylistmodel.ContactPerson = Dict["ContactName"]?.string
                        self.getCommunityList.append(communitylistmodel)
                    }
                    
                    self.delegate?.didSucess()
                }
                else {
                    self.delegate?.didFail()
                }
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail()
        })
    }
    
    //MARK:- AllCommunityServiceCall
    func getAllCommunityServerCall() {
        let reqBody : Dictionary =  ["LoginId" : ""]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_GET_COMMUNITY .rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            
            if(JSONResponse["CommunityList"]) == JSON.null {
                self.delegate?.didFail()
            }
            else {
                var communityArray = JSONResponse["CommunityList"]["Community"]
                if ((communityArray).dictionary) != nil {
                    communityArray = JSON.init(arrayLiteral: communityArray)
                }
                if((communityArray.array?.count)! > 0) {
                    for i in 0..<communityArray.count {
                        let communitylistmodel = getCommunityModel()
                        let Dict = communityArray[i].dictionaryValue
                        print("All Community Data = \(Dict)")
                        communitylistmodel.Name = Dict["Name"]?.string
                        communitylistmodel.Description = Dict["Description"]?.string
                        communitylistmodel.type = Dict["Type"]?.string
                        communitylistmodel.CommunityId = Dict["CommunityId"]?.int
                        communitylistmodel.isBloodbank = Dict["isBloodbank"]?.bool
                        communitylistmodel.phone = Dict["Phone"]?.int
                        if Dict["LoginId"]?.int != nil {
                            communitylistmodel.LoginId = String(describing: Dict["LoginId"]!)
                        } else {
                            communitylistmodel.LoginId = (Dict["LoginId"]?.string)!
                        }
                        communitylistmodel.ContactPerson = Dict["ContactName"]?.string
                        self.getCommunityList.append(communitylistmodel)
                    }
                    self.delegate?.didSucess()
                }
                else {
                    self.delegate?.didFail()
                }
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail()
        })
    }
    
    //MARK:- GetCommunityMemberServerCall
    func getCommunityMember(communityId: Int) {
        let reqBody : Dictionary = ["CommunityId": communityId,"LoginID" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)"] as [String : Any]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_GET_COMMUNITY_MEMBER.rawValue, method: "POST", parameters: reqBody, sucess: { (JSONResponse) -> Void in
            if(JSONResponse["CommunityList"]) == JSON.null {
                self.delegate?.didFail()
            }
            else {
                var communityArray = JSONResponse["CommunityList"]["Community"]
                if ((communityArray).dictionary) != nil {
                    communityArray = JSON.init(arrayLiteral: communityArray)
                }
                if((communityArray.array?.count)! > 0) {
                    for i in 0..<communityArray.count {
                        let communitylistmodel = getCommunityModel()
                        let Dict = communityArray[i].dictionaryValue
                        print("My Community Data = \(Dict)")
                        communitylistmodel.Name = Dict["Name"]?.string
                        communitylistmodel.CommunityId = Dict["CommunityId"]?.int
                        communitylistmodel.phone = Dict["Phone"]?.int
                        communitylistmodel.Status = Dict["Status"]?.string
                        communitylistmodel.isActive = Dict["isActive"]?.bool
                        if Dict["LoginId"]?.int != nil {
                            communitylistmodel.LoginId = String(describing: Dict["LoginId"]!)
                        } else {
                            communitylistmodel.LoginId = Dict["LoginId"]?.string
                        }
                        self.getCommunityList.append(communitylistmodel)
                    }
                    self.delegate?.didSucess()
                }
                else {
                    self.delegate?.didFail()
                }
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail()
        })
    }
    //MARK:- CreateCommunityServerCall
    func createCommunity(name: String, description: String, type: String, phone: String, logo: String, contactName: String) {
        let reqBody : Dictionary =  ["CreateCommunity":["Name" : name,"Description": description,"Type": type,"Phone": phone,"Logo": logo,"LoginId" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)","ContactName": contactName]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_CREATE_COMMUNITY.rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            if(JSONResponse["CreateCommunity"]["StatusCode"].int == 0) {
                self.delegate?.didSucess()
            }else{
                self.delegate?.didFail()
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail()
        })
    }
    //MARK:- GetUsersInvitationsServerCall
    func GetUsersInvitations() {
        let reqBody : Dictionary =  ["GetmyInvitation":["LoginId" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)"]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_GET_USER_INVITATION.rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            if(JSONResponse["MyInvitationLists"]) == JSON.null {
                self.delegate?.didFail()
            } else {
                var communityArray = JSONResponse["MyInvitationLists"]["MyInvitationList"]
                if ((communityArray).dictionary) != nil {
                    communityArray = JSON.init(arrayLiteral: communityArray)
                }
                if((communityArray.array?.count)! > 0) {
                    for i in 0..<communityArray.count {
                        let communitylistmodel = getCommunityModel()
                        let Dict = communityArray[i].dictionaryValue
                        print("My Invitation Data = \(Dict)")
                        communitylistmodel.CommunityId = Dict["CommunityId"]?.int
                        communitylistmodel.inviteId = Dict["InviteId"]?.int
                        communitylistmodel.inviteStatus = Dict["InviteStatus"]?.string
                        if Dict["LoginId"]?.int != nil {
                            communitylistmodel.LoginId = String(describing: Dict["LoginId"]!)
                        } else {
                            communitylistmodel.LoginId = Dict["LoginId"]?.string
                        }
                        communitylistmodel.Name = Dict["CommunityName"]?.string
                        self.getCommunityList.append(communitylistmodel)
                    }
                    self.delegate?.didSucess()
                }
                else {
                    self.delegate?.didFail()
                }}
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail()
        })
    }
    //MARK:- GetAllInvitationsServerCall
    func GetAllInvitations(communityId: Int) {
        let reqBody : Dictionary =  ["InvitationList":["CommunityId" : communityId]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_GET_USER_INVITATION.rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            if(JSONResponse["InvitationLists"]) == JSON.null {
                self.delegate?.didFail()
            } else {
                
                var communityArray = JSONResponse["InvitationLists"]["InvitationList"]
                if ((communityArray).dictionary) != nil {
                    communityArray = JSON.init(arrayLiteral: communityArray)
                }
                if((communityArray.array?.count)! > 0) {
                    for i in 0..<communityArray.count {
                        
                        let communitylistmodel = getCommunityModel()
                        let Dict = communityArray[i].dictionaryValue
                        print("My Invitation Data = \(Dict)")
                        communitylistmodel.CommunityId = Dict["CommunityId"]?.int
                        communitylistmodel.inviteId = Dict["InviteId"]?.int
                        communitylistmodel.inviteStatus = Dict["InviteStatus"]?.string
                        if Dict["LoginId"]?.int != nil {
                            communitylistmodel.LoginId = String(describing: Dict["LoginId"]!)
                        } else {
                            communitylistmodel.LoginId = Dict["LoginId"]?.string
                        }
                        communitylistmodel.userName = Dict["UserName"]?.string
                        communitylistmodel.emailID = Dict["EmailId"]?.string
                        self.getCommunityList.append(communitylistmodel)
                    }
                    self.delegate?.didSucess()
                }
                else {
                    self.delegate?.didFail()
                }}
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail()
        })
    }
}
//
protocol updateCommunityMemberProtocol {
    func didSuccess(StatusCode: Int)
    func didFail(Response: String)
}

//
class UpdateCommunityMemberModel {
    static var SharedInstance: UpdateCommunityMemberModel {
        struct Shared {
            static let Instance = UpdateCommunityMemberModel()
        }
        return Shared.Instance
    }
    var delegate : updateCommunityMemberProtocol?
    
    //MARK:- UpdateCommunityMemberServerCall
    func UpdateCommunityMember(loginId: String, communityId: Int, isActive: Int) {
        let reqBody : Dictionary =  ["UpdateCommunityMembers":["CommunityId" : communityId,"isActive": isActive,"LoginId" : loginId]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_UPDATE_COMMUNITY_MEMBER.rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            if(JSONResponse["UpdateCommunityMember"]["StatusCode"].int == 0) {
                self.delegate?.didSuccess(StatusCode: 0)
            }else if(JSONResponse["UpdateCommunityMember"]["StatusCode"].int == 1) {
                self.delegate?.didSuccess(StatusCode: 1)
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail(Response: Response)
        })
    }
    
    //MARK:- CreateInviteServerCall
    func createInvite(emailId: String, communityId: Int, invitationStatus: String) {
        let reqBody: Dictionary = ["CommunityInvite":["EmailId": emailId,"CommunityId": communityId,"InviteStatus": invitationStatus]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_CREATE_INVITE.rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            if(JSONResponse["InviteCommunity"]["StatusCode"].int == 0) {
                self.delegate?.didSuccess(StatusCode: 0)
            }else if(JSONResponse["InviteCommunity"]["StatusCode"].int == 1){
                self.delegate?.didSuccess(StatusCode: 1)
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail(Response: Response)
        })
    }
    
    //MARK:- UpdateInviteServerCall
    func UpdateInvite(inviteId: Int, inviteStatus: String) {
        let reqBody : Dictionary = ["UpdateInvite":["InviteId" : inviteId,"InviteStatus": inviteStatus]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_UPDATE_INVITE.rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            if JSONResponse["UpdateInvite"]["StatusCode"] == 0 {
                self.delegate?.didSuccess(StatusCode: 0)
            }
            else if JSONResponse["UpdateInvite"]["StatusCode"] == 1 {
                self.delegate?.didSuccess(StatusCode: 1)
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail(Response: Response)
        })
    }
}
