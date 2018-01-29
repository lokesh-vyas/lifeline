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
    //   // MARK:- Production URL's
    case TrustHostProd                    = "api.lifeline.services"
    case ACCESS                           = "http://api.lifeline.services/services/AccessV1.1"
    case BLOOD_REQUEST_SEARCH             = "http://api.lifeline.services/services/BloodRequestSearchV1.1"
    case CONFIRM_DONATE                   = "http://api.lifeline.services/services/ConfirmDonateV1.1"
    case GET_REQUEST_DETAILS              = "http://api.lifeline.services/services/GetRequestDetailsV1.1"
    case BLOOD_REQUIREMENT                = "http://api.lifeline.services/services/BloodRequirementV1.1"
    case GET_COLLECTION_CENTRE_LIST       = "http://api.lifeline.services/services/GetCollectionCentersListV1.1"
    case PROFILE_REGISTRATION             = "http://api.lifeline.services/services/v1.2/ProfileRegistration"
    case MY_REQUESTS                      = "http://api.lifeline.services/services/MyRequestsV1.1"
    case REQUEST_STATUS_UPDATE            = "http://api.lifeline.services/services/RequestStatusUpdateV1.1"
    case Device_Token_Reg                 = "http://api.lifeline.services/services/DeviceDetailsV1.1"
    case LIFELINE_Get_Profile             = "http://api.lifeline.services/services/v1.2/GetProfile"
    case LIFELINE_Custom_Sign_Up          = "https://api.lifeline.services/services/v1.2/CustomSignUp"
    case LIFELINE_Change_Password         = "https://api.lifeline.services/services/ChangePasswordV1.1"
    case LIFELINE_UserIDAvilableityCheck  = "https://api.lifeline.services/services/UserIDAvilableityCheckV1.1"
    case LIFELINE_ForgetPassword          = "https://api.lifeline.services/services/ForgetPasswordV1.1"
    case LIFELINE_CustomLogin             = "https://api.lifeline.services/services/v1.2/CustomLogin"
    case GET_CAMPAGIN_DETAILS             = "http://api.lifeline.services/services/GetCampaignDetailsV1.1"
    case LIFELINE_Get_VolunteerList       = "http://api.lifeline.services/services/GetVolunteerListV1.1"
    case LIFELINE_Get_Inventory           = "http://api.lifeline.services/services/GetInventoryV1.1"
    case MY_DONATION                      = "http://api.lifeline.services/services/MyDonationV1.1"
    case LIFELINE_GET_NOTIFICATIONS       = "http://api.lifeline.services/services/GetNotificationsV1.1"
    case LIFELINE_DELETE_NOTIFICATION     = "http://api.lifeline.services/services/DeleteNotificationV1.1"
    case LIFELINE_UPDATE_NOTIFICATON      = "http://api.lifeline.services/services/UpdateNotificationV1.1"
    
    //    MARK:- Staging URL's For Production
    //    case TrustHostProd                    =   "staging.lifeline.services"
    //    case ACCESS                           =   "http://staging.lifeline.services/services/AccessV1.1"
    //    case BLOOD_REQUEST_SEARCH             =   "http://staging.lifeline.services/services/BloodRequestSearchV1.1"
    //    case CONFIRM_DONATE                   =   "http://staging.lifeline.services/services/ConfirmDonateV1.1"
    //    case GET_REQUEST_DETAILS              =   "http://staging.lifeline.services/services/GetRequestDetailsV1.1"
    //    case BLOOD_REQUIREMENT                =   "http://staging.lifeline.services/services/BloodRequirementV1.1"
    //    case GET_COLLECTION_CENTRE_LIST       =   "http://staging.lifeline.services/services/GetCollectionCentersListV1.1"
    //    case PROFILE_REGISTRATION             =   "http://staging.lifeline.services/services/v1.2/ProfileRegistration"
    //    case MY_REQUESTS                      =   "http://staging.lifeline.services/services/MyRequestsV1.1"
    //    case REQUEST_STATUS_UPDATE            =   "http://staging.lifeline.services/services/RequestStatusUpdateV1.1"
    //    case  Device_Token_Reg                =   "http://staging.lifeline.services/services/DeviceDetailsV1.1"
    //    case LIFELINE_Get_Profile             =   "http://staging.lifeline.services/services/v1.2/GetProfile"
    //    case LIFELINE_Custom_Sign_Up          =   "https://staging.lifeline.services/services/v1.2/CustomSignUp"
    //    case LIFELINE_Change_Password         =   "https://staging.lifeline.services/services/ChangePasswordV1.1"
    //    case LIFELINE_UserIDAvilableityCheck  =   "https://staging.lifeline.services/services/UserIDAvilableityCheckV1.1"
    //    case LIFELINE_ForgetPassword          =  "https://staging.lifeline.services/services/ForgetPasswordV1.1"
    //    case LIFELINE_CustomLogin             = "https://staging.lifeline.services/services/v1.2/CustomLogin"
    //    case GET_CAMPAGIN_DETAILS             =    "http://staging.lifeline.services/services/GetCampaignDetailsV1.1"
    //    case LIFELINE_Get_VolunteerList       = "http://staging.lifeline.services/services/GetVolunteerListV1.1"
    //    case LIFELINE_Get_Inventory           = "http://staging.lifeline.services/services/GetInventoryV1.1"
    //    case MY_DONATION                      = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.MyDonation"
    //    case LIFELINE_GET_NOTIFICATIONS       = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetNotifications"
    //    case LIFELINE_DELETE_NOTIFICATION     = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.DeleteNotification"
    //    case LIFELINE_UPDATE_NOTIFICATON      = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.UpdateNotification"
    
    
    //MARK:- Development URL's
    //MARK:- With API Key
    //    case ACCESS                           = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.Access"
    //    case BLOOD_REQUEST_SEARCH             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.BloodRequestSearch"
    //    case CONFIRM_DONATE                   = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.ConfirmDonate"
    //    case GET_REQUEST_DETAILS              = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetRequestDetails"
    //    case GET_CAMPAGIN_DETAILS             = "https://lifelineadmin-test.apigee.net/lifeline-dev/LifeLine.GetCampaignDetails"
    //    case BLOOD_REQUIREMENT                = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.BloodRequirement"
    //    case GET_COLLECTION_CENTRE_LIST       = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetCollectionCentersList"
    //    case PROFILE_REGISTRATION             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.ProfileRegistration"
    //    case MY_REQUESTS                      = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.MyRequests"
    //    case REQUEST_STATUS_UPDATE            = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.RequestStatusUpdate"
    //    case  Device_Token_Reg                = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.DeviceDetails"
    //    case LIFELINE_Custom_Sign_Up          = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.CustomSignUp"
    //    case LIFELINE_Change_Password         = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.ChangePassword"
    //    case LIFELINE_UserIDAvilableityCheck  = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.UserIDAvilableityCheck"
    //    case LIFELINE_ForgetPassword          = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.ForgetPassword"
    //    case LIFELINE_CustomLogin             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.CustomLogin"
    //    case LIFELINE_Get_Profile             = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetProfile"
    //    case LIFELINE_Get_VolunteerList       = "https://lifelineadmin-test.apigee.net/lifeline-dev/GetVolunteerList"
    //    case LIFELINE_Get_Inventory           = "https://lifelineadmin-test.apigee.net/lifeline-dev/DEV-LifeLine.GetInventory"
    //
    //    //MARK:- Development URL's
//        case TrustHostProd = "demo.frontman.isteer.com"
//        case ACCESS                           = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.Access"
//        case BLOOD_REQUEST_SEARCH             = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.BloodRequestSearch"
//        case CONFIRM_DONATE                   = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ConfirmDonate"
//        case GET_REQUEST_DETAILS              = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetRequestDetails"
//        case GET_CAMPAGIN_DETAILS             = "http://demo.frontman.isteer.com:8284/services/LifeLine.GetCampaignDetails"
//        case BLOOD_REQUIREMENT                = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.BloodRequirement"
//        case GET_COLLECTION_CENTRE_LIST       = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetCollectionCentersList"
//        case PROFILE_REGISTRATION             = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ProfileRegistration"
//        case MY_REQUESTS                      = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.MyRequests"
//        case REQUEST_STATUS_UPDATE            = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.RequestStatusUpdate"
//        case  Device_Token_Reg                = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.DeviceDetails"
//        case LIFELINE_Custom_Sign_Up          = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.CustomSignUp"
//        case LIFELINE_Change_Password         = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ChangePassword"
//        case LIFELINE_UserIDAvilableityCheck  = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.UserIDAvilableityCheck"
//        case LIFELINE_ForgetPassword          = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ForgetPassword"
//        case LIFELINE_CustomLogin             = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.CustomLogin"
//        case LIFELINE_Get_Profile             = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetProfile"
//        case LIFELINE_Get_VolunteerList       = "http://demo.frontman.isteer.com:8284/services/GetVolunteerList"
//        case LIFELINE_Get_Inventory           = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetInventory"
//
//        case MY_DONATION                      = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.MyDonation"
//        case LIFELINE_GET_NOTIFICATIONS       = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetNotifications"
//        case LIFELINE_DELETE_NOTIFICATION     = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.DeleteNotification"
//        case LIFELINE_UPDATE_NOTIFICATON      = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.UpdateNotification"
//
//        case LIFELINE_GET_COMMUNITY           = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetCommunityList"
//        case LIFELINE_CREATE_COMMUNITY        = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.CreateCommunity"
//        case LIFELINE_UPDATE_COMMUNITY        = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.UpdateCommunity"
//        case LIFELINE_REQUEST_COMMUNITY       = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.RequestCommunity"
//        case LIFELINE_UPDATE_COMMUNITY_MEMBER = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.UpdateCommunityMember"
//        case LIFELINE_GET_COMMUNITY_MEMBER    = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetCommunityMembers"
//        case LIFELINE_CREATE_INVITE           = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.InviteCommunity"
//        case LIFELINE_UPDATE_INVITE           = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.UpdateCommunityInvite"
//        case LIFELINE_GET_USER_INVITATION     = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetCommunityInviteList"
        //case LIFELINE_GET_ALL_INVITATION      = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetCommunityInviteList"
}
