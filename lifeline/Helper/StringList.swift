//
//  StringList.swift
//  lifeline
//
//  Created by iSteer on 11/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation

//MARK:- URL LIST
public enum URLList:String
{
    //MARK:- Production URL's
//    case ACCESS      =               "http://api.lifeline.services/services/AccessV1.1"
//    case BLOOD_REQUEST_SEARCH  =     "http://api.lifeline.services/services/BloodRequestSearchV1.1"
//    case CONFIRM_DONATE      =       "http://api.lifeline.services/services/ConfirmDonateV1.1"
//    case GET_REQUEST_DETAILS   =     "http://api.lifeline.services/services/GetRequestDetailsV1.1"
//    case BLOOD_REQUIREMENT     =     "http://api.lifeline.services/services/BloodRequirementV1.1"
//    case GET_COLLECTION_CENTRE_LIST = "http://api.lifeline.services/services/GetCollectionCentersListV1.1"
//    case PROFILE_REGISTRATION   =    "http://api.lifeline.services/services/ProfileRegistrationV1.1"
//    case MY_REQUESTS           =     "http://api.lifeline.services/services/MyRequestsV1.1"
//    case REQUEST_STATUS_UPDATE  =     "http://api.lifeline.services/services/RequestStatusUpdateV1.1"
//    case  Device_Token_Reg     =     "http://api.lifeline.services/services/DeviceDetailsV1.1"
//    case LIFELINE_Get_Profile = "http://api.lifeline.services/services/GetProfileV1.1"
//    
//    case LIFELINE_Custom_Sign_Up = "https://api.lifeline.services/services/CustomSignUpV1.1"
//    case LIFELINE_Change_Password =  "https://api.lifeline.services/services/ChangePasswordV1.1"
//    case LIFELINE_UserIDAvilableityCheck = "https://api.lifeline.services/services/UserIDAvilableityCheckV1.1"
//    case LIFELINE_ForgetPassword = "https://api.lifeline.services/services/ForgetPasswordV1.1"
//    case LIFELINE_CustomLogin = "https://api.lifeline.services/services/CustomLoginV1.1"
//    case GET_CAMPAGIN_DETAILS   =    "http://api.lifeline.services/services/GetCampaignDetailsV1.1"
//    http://api.lifeline.services/services/GetVolunteerListV1.1
    
     //MARK:- Development URL's
    case ACCESS                           = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.Access"
    case BLOOD_REQUEST_SEARCH             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.BloodRequestSearch"
    case CONFIRM_DONATE                   = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.ConfirmDonate"
    case GET_REQUEST_DETAILS              = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetRequestDetails"
    case GET_CAMPAGIN_DETAILS             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetCampaignDetails"
    case BLOOD_REQUIREMENT                = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.BloodRequirement"
    case GET_COLLECTION_CENTRE_LIST       = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetCollectionCentersList"
    case PROFILE_REGISTRATION             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.ProfileRegistration"
    case MY_REQUESTS                      = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.MyRequests"
    case REQUEST_STATUS_UPDATE            = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.RequestStatusUpdate"
    case  Device_Token_Reg                = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.DeviceDetails"
    case LIFELINE_Custom_Sign_Up          = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.CustomSignUp"
    case LIFELINE_Change_Password         = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.ChangePassword"
    case LIFELINE_UserIDAvilableityCheck  = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.UserIDAvilableityCheck"
    case LIFELINE_ForgetPassword          = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.ForgetPassword"
    case LIFELINE_CustomLogin             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.CustomLogin"
    case LIFELINE_Get_Profile             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetProfile"
    case LIFELINE_Get_VolunteerList       = "https://lifelineadmin-test.apigee.net/lifeline-dev/GetVolunteerList"
    case LIFELINE_Get_Inventory           = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetInventory"
    
}
//MARK:- STRING LIST
public enum StringList: String
{
    case GoogleClientID = "523732833608-82fkrlpmjpiupj9tv225ku5k5d86p5gf.apps.googleusercontent.com"
    case LifeLine_User_Name = "LifeLine_User_Name"
    case LifeLine_User_Email = "LifeLine_User_Email"
    case LifeLine_User_ID = "LifeLine_User_Unique_ID"
    case LL_Welcome_Message = "Welcome to LifeLine"
    case LifeLine_HostName = "api.lifeline.services"
    case LifeLine_Internet_Error_Message = "Unable to access service, Please try again leter."
}
