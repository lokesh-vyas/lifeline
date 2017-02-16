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
    //case ACCESS      =               "http://api.lifeline.services/services/AccessV1.1"
    //case BLOOD_REQUEST_SEARCH  =     "http://api.lifeline.services/services/BloodRequestSearchV1.1"
    //case CONFIRM_DONATE      =       "http://api.lifeline.services/services/ConfirmDonateV1.1"
    //case GET_REQUEST_DETAILS   =     "http://api.lifeline.services/services/GetRequestDetailsV1.1"
    //case BLOOD_REQUIREMENT     =     "http://api.lifeline.services/services/BloodRequirementV1.1"
    //case GET_COLLECTION_CENTRE_LIST = "http://api.lifeline.services/services/GetCollectionCentersListV1.1"
    //case PROFILE_REGISTRATION   =    "http://api.lifeline.services/services/ProfileRegistrationV1.1"
    //case MY_REQUESTS           =     "http://api.lifeline.services/services/MyRequestsV1.1"
    //case REQUEST_STATUS_UPDATE  =     "http://api.lifeline.services/services/RequestStatusUpdateV1.1"
    //case  Device_Token_Reg     =     "http://api.lifeline.services/services/DeviceDetailsV1.1"
    //case LIFELINE_Get_Profile = "http://api.lifeline.services/services/GetProfileV1.1"
    //
    //case LIFELINE_Custom_Sign_Up = "https://api.lifeline.services/services/CustomSignUpV1.1"
    //case LIFELINE_Change_Password =  "https://api.lifeline.services/services/ChangePasswordV1.1"
    //case LIFELINE_UserIDAvilableityCheck = "https://api.lifeline.services/services/UserIDAvilableityCheckV1.1"
    //case LIFELINE_ForgetPassword = "https://api.lifeline.services/services/ForgetPasswordV1.1"
    //case LIFELINE_CustomLogin = "https://api.lifeline.services/services/CustomLoginV1.1"
    //case GET_CAMPAGIN_DETAILS   =    "http://api.lifeline.services/services/GetCampaignDetailsV1.1"
    
    case ACCESS                     = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.Access"
    case BLOOD_REQUEST_SEARCH       = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.BloodRequestSearch"
    case CONFIRM_DONATE             = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ConfirmDonate"
    case GET_REQUEST_DETAILS        = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetRequestDetails"
    case GET_CAMPAGIN_DETAILS       = "http://demo.frontman.isteer.com:8284/services/LifeLine.GetCampaignDetails"
    case BLOOD_REQUIREMENT          = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.BloodRequirement"
    case GET_COLLECTION_CENTRE_LIST = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetCollectionCentersList"
    case PROFILE_REGISTRATION       = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ProfileRegistration"
    case MY_REQUESTS                = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.MyRequests"
    case REQUEST_STATUS_UPDATE       = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.RequestStatusUpdate"
    case  Device_Token_Reg          = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.DeviceDetails"
    
    case LIFELINE_Custom_Sign_Up  = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.CustomSignUp"
    case LIFELINE_Change_Password  = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ChangePassword"
    case LIFELINE_UserIDAvilableityCheck   = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.UserIDAvilableityCheck"
    case LIFELINE_ForgetPassword  = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ForgetPassword"
    case LIFELINE_CustomLogin  = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.CustomLogin"
    case LIFELINE_Get_Profile   = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetProfile"
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
}
