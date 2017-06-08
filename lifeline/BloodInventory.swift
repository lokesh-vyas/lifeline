//
//  BloodInventory.swift
//  lifeline
//
//  Created by Apple on 24/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class BloodInventory: UIViewController {
    
    @IBOutlet weak var tableInventoryView: UITableView!
    @IBOutlet weak var lblBloodInventory: UILabel!
    var TitleArray = ["GP","WB","PC","FFP","PLT","CR","SDP"]
    var TotalArray = ["TOTAL","0","0","0","0","0","0"]
    var APlusArray = ["A+","0","0","0","0","0","0"]
    var BPlusArray = ["B+","0","0","0","0","0","0"]
    var ABPlusArray = ["AB+","0","0","0","0","0","0"]
    var OPlusArray = ["O+","0","0","0","0","0","0"]
    var OMinusArray = ["O-","0","0","0","0","0","0"]
    var AMinusArray = ["A-","0","0","0","0","0","0"]
    var BMinusArray = ["B-","0","0","0","0","0","0"]
    var ABMinusArray = ["AB-","0","0","0","0","0","0"]
    
    var PCTotal = [0,0,0,0,0,0,0,0]
    var WBTotal = [0,0,0,0,0,0,0,0]
    var FFPTotal = [0,0,0,0,0,0,0,0]
    var PLTTotal = [0,0,0,0,0,0,0,0]
    var CRTotal = [0,0,0,0,0,0,0,0]
    var SDPTotal = [0,0,0,0,0,0,0,0]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableInventoryView.isHidden = true
        HudBar.sharedInstance.showHudWithMessage(message: "Loading...", view: self.view)
        self.navigationController?.completelyTransparentBar()
        tableInventoryView.contentInset = UIEdgeInsetsMake(-35, 0.0, 0, 0.0)
        let bloodbankIDDict = MarkerData.SharedInstance.markerData
        let bloodBankId:String = bloodbankIDDict["ID"] as! String
        let reqBody : Dictionary = ["GetBloodInventoryRequest":
            ["GetBloodInventoryRequestDetails":
                ["BloodBankID" : bloodBankId
                ]]]
        DonateInteractor.sharedInstance.delegate = self
        DonateInteractor.sharedInstance.findingDonateSources(urlString: URLList.LIFELINE_Get_Inventory.rawValue, params: reqBody)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension BloodInventory: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "TableCollectionCell"
        var tableCollectionCell = tableInventoryView.dequeueReusableCell(withIdentifier: identifier) as? InventoryTableCell
        if(tableCollectionCell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("InventoryTableCell", owner: self, options: nil)!
            tableCollectionCell = nib[0] as? InventoryTableCell
        }
        if ( indexPath.row % 2 == 0)
        {
            tableCollectionCell?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
        if indexPath.row == 0
        {
            tableCollectionCell?.post = TitleArray
        }else if indexPath.row == 1
        {
            tableCollectionCell?.post = APlusArray
        }
        else if indexPath.row == 2
        {
            tableCollectionCell?.post = BPlusArray
        }
        else if indexPath.row == 3
        {
            tableCollectionCell?.post = OPlusArray
        }
        else if indexPath.row == 4
        {
            tableCollectionCell?.post = ABPlusArray
        }
        else if indexPath.row == 5
        {
            tableCollectionCell?.post = AMinusArray
        }
        else if indexPath.row == 6
        {
            tableCollectionCell?.post = BMinusArray
        }
        else if indexPath.row == 7
        {
            tableCollectionCell?.post = OMinusArray
        }
        else if indexPath.row == 8
        {
            tableCollectionCell?.post = ABMinusArray
        }
        else if indexPath.row == 9
        {
            tableCollectionCell?.post = TotalArray
        }
        return tableCollectionCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
extension BloodInventory : DonateViewProtocol
{
    func successDonateSources(jsonArray: JSON)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if jsonArray["GetBloodInventoryResponse"]["BloodBankInventory"]["StatusCode"].int == 1
        {
            //self.lblBloodInventory.text = MultiLanguage.getLanguageUsingKey("INVENTORY_WARNING")
            self.tableInventoryView.isHidden = false
            tableInventoryView.reloadData()
        }
        else
        {
            self.lblBloodInventory.isHidden = true
            self.tableInventoryView.isHidden = false
            var dataArray = jsonArray["GetBloodInventoryResponse"]["BloodBankInventory"]
            if ((dataArray as? JSON)?.dictionary) != nil {
                dataArray = JSON.init(arrayLiteral: dataArray)
                
            }
            for (i, _) in dataArray.enumerated()
            {
                if dataArray[i]["BloodGroup"] == "A+"
                {
                    if dataArray[i]["BCType"] == "WB"
                    {
                        APlusArray[1] = String(describing: dataArray[i]["StockInHand"])
                        WBTotal[0] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PC"
                    {
                        APlusArray[2] = String(describing: dataArray[i]["StockInHand"])
                        PCTotal[0] = dataArray[i]["StockInHand"].int!
                    }
                    else if dataArray[i]["BCType"] == "FFP"
                    {
                        APlusArray[3] = String(describing: dataArray[i]["StockInHand"])
                        FFPTotal[0] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PLT"
                    {
                        APlusArray[4] = String(describing: dataArray[i]["StockInHand"])
                        PLTTotal[0] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "CR"
                    {
                        APlusArray[5] = String(describing: dataArray[i]["StockInHand"])
                        CRTotal[0] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "SDP"
                    {
                        APlusArray[6] = String(describing: dataArray[i]["StockInHand"])
                        SDPTotal[0] = dataArray[i]["StockInHand"].int!
                    }
                }else if dataArray[i]["BloodGroup"] == "B+"
                {
                    if dataArray[i]["BCType"] == "WB"
                    {
                        BPlusArray[1] = String(describing: dataArray[i]["StockInHand"])
                        WBTotal[1] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PC"
                    {
                        BPlusArray[2] = String(describing: dataArray[i]["StockInHand"])
                        PCTotal[1] = dataArray[i]["StockInHand"].int!
                    }
                    else if dataArray[i]["BCType"] == "FFP"
                    {
                        BPlusArray[3] = String(describing: dataArray[i]["StockInHand"])
                        FFPTotal[1] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PLT"
                    {
                        BPlusArray[4] = String(describing: dataArray[i]["StockInHand"])
                        PLTTotal[1] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "CR"
                    {
                        BPlusArray[5] = String(describing: dataArray[i]["StockInHand"])
                        CRTotal[1] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "SDP"
                    {
                        BPlusArray[6] = String(describing: dataArray[i]["StockInHand"])
                        SDPTotal[1] = dataArray[i]["StockInHand"].int!
                    }
                }
                else if dataArray[i]["BloodGroup"] == "AB+"
                {
                    if dataArray[i]["BCType"] == "WB"
                    {
                        ABPlusArray[1] = String(describing: dataArray[i]["StockInHand"])
                        WBTotal[2] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PC"
                    {
                        ABPlusArray[2] = String(describing: dataArray[i]["StockInHand"])
                        PCTotal[2] = dataArray[i]["StockInHand"].int!
                    }
                    else if dataArray[i]["BCType"] == "FFP"
                    {
                        ABPlusArray[3] = String(describing: dataArray[i]["StockInHand"])
                        FFPTotal[2] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PLT"
                    {
                        ABPlusArray[4] = String(describing: dataArray[i]["StockInHand"])
                        PLTTotal[2] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "CR"
                    {
                        ABPlusArray[5] = String(describing: dataArray[i]["StockInHand"])
                        CRTotal[2] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "SDP"
                    {
                        ABPlusArray[6] = String(describing: dataArray[i]["StockInHand"])
                        SDPTotal[2] = dataArray[i]["StockInHand"].int!
                    }
                }
                else if dataArray[i]["BloodGroup"] == "O+"
                {
                    if dataArray[i]["BCType"] == "WB"
                    {
                        OPlusArray[1] = String(describing: dataArray[i]["StockInHand"])
                        WBTotal[3] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PC"
                    {
                        OPlusArray[2] = String(describing: dataArray[i]["StockInHand"])
                        PCTotal[3] = dataArray[i]["StockInHand"].int!
                    }
                    else if dataArray[i]["BCType"] == "FFP"
                    {
                        OPlusArray[3] = String(describing: dataArray[i]["StockInHand"])
                        FFPTotal[3] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PLT"
                    {
                        OPlusArray[4] = String(describing: dataArray[i]["StockInHand"])
                        PLTTotal[3] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "CR"
                    {
                        OPlusArray[5] = String(describing: dataArray[i]["StockInHand"])
                        CRTotal[3] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "SDP"
                    {
                        OPlusArray[6] = String(describing: dataArray[i]["StockInHand"])
                        SDPTotal[3] = dataArray[i]["StockInHand"].int!
                    }
                }else if dataArray[i]["BloodGroup"] == "A-"
                {
                    if dataArray[i]["BCType"] == "WB"
                    {
                        AMinusArray[1] = String(describing: dataArray[i]["StockInHand"])
                        WBTotal[4] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PC"
                    {
                        AMinusArray[2] = String(describing: dataArray[i]["StockInHand"])
                        PCTotal[4] = dataArray[i]["StockInHand"].int!
                    }
                    else if dataArray[i]["BCType"] == "FFP"
                    {
                        AMinusArray[3] = String(describing: dataArray[i]["StockInHand"])
                        FFPTotal[4] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PLT"
                    {
                        AMinusArray[4] = String(describing: dataArray[i]["StockInHand"])
                        PLTTotal[4] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "CR"
                    {
                        AMinusArray[5] = String(describing: dataArray[i]["StockInHand"])
                        CRTotal[4] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "SDP"
                    {
                        AMinusArray[6] = String(describing: dataArray[i]["StockInHand"])
                        SDPTotal[4] = dataArray[i]["StockInHand"].int!
                    }
                }else if dataArray[i]["BloodGroup"] == "B-"
                {
                    if dataArray[i]["BCType"] == "WB"
                    {
                        BMinusArray[1] = String(describing: dataArray[i]["StockInHand"])
                        WBTotal[5] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PC"
                    {
                        BMinusArray[2] = String(describing: dataArray[i]["StockInHand"])
                        PCTotal[5] = dataArray[i]["StockInHand"].int!
                    }
                    else if dataArray[i]["BCType"] == "FFP"
                    {
                        BMinusArray[3] = String(describing: dataArray[i]["StockInHand"])
                        FFPTotal[5] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PLT"
                    {
                        BMinusArray[4] = String(describing: dataArray[i]["StockInHand"])
                        PLTTotal[5] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "CR"
                    {
                        BMinusArray[5] = String(describing: dataArray[i]["StockInHand"])
                        CRTotal[5] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "SDP"
                    {
                        BMinusArray[6] = String(describing: dataArray[i]["StockInHand"])
                        SDPTotal[5] = dataArray[i]["StockInHand"].int!
                    }
                }
                else if dataArray[i]["BloodGroup"] == "AB-"
                {
                    if dataArray[i]["BCType"] == "WB"
                    {
                        ABMinusArray[1] = String(describing: dataArray[i]["StockInHand"])
                        WBTotal[6] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PC"
                    {
                        ABMinusArray[2] = String(describing: dataArray[i]["StockInHand"])
                        PCTotal[6] = dataArray[i]["StockInHand"].int!
                    }
                    else if dataArray[i]["BCType"] == "FFP"
                    {
                        ABMinusArray[3] = String(describing: dataArray[i]["StockInHand"])
                        FFPTotal[6] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PLT"
                    {
                        ABMinusArray[4] = String(describing: dataArray[i]["StockInHand"])
                        PLTTotal[6] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "CR"
                    {
                        ABMinusArray[5] = String(describing: dataArray[i]["StockInHand"])
                        CRTotal[6] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "SDP"
                    {
                        ABMinusArray[6] = String(describing: dataArray[i]["StockInHand"])
                        SDPTotal[6] = dataArray[i]["StockInHand"].int!
                    }
                }
                else if dataArray[i]["BloodGroup"] == "O-"
                {
                    if dataArray[i]["BCType"] == "WB"
                    {
                        OMinusArray[1] = String(describing: dataArray[i]["StockInHand"])
                        WBTotal[7] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PC"
                    {
                        OMinusArray[2] = String(describing: dataArray[i]["StockInHand"])
                        PCTotal[7] = dataArray[i]["StockInHand"].int!
                        
                    }
                    else if dataArray[i]["BCType"] == "FFP"
                    {
                        OMinusArray[3] = String(describing: dataArray[i]["StockInHand"])
                        FFPTotal[7] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "PLT"
                    {
                        OMinusArray[4] = String(describing: dataArray[i]["StockInHand"])
                        PLTTotal[7] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "CR"
                    {
                        OMinusArray[5] = String(describing: dataArray[i]["StockInHand"])
                        CRTotal[7] = dataArray[i]["StockInHand"].int!
                    }else if dataArray[i]["BCType"] == "SDP"
                    {
                        OMinusArray[6] = String(describing: dataArray[i]["StockInHand"])
                        SDPTotal[7] = dataArray[i]["StockInHand"].int!
                    }
                }
            }
            //var TitleArray = ["GP","WB","PC","FFP","PLT","CR","SDP"]
            TotalArray[1] = String(WBTotal.reduce(0, {$0 + $1}))
            TotalArray[2] = String(PCTotal.reduce(0, {$0 + $1}))
            TotalArray[3] = String(FFPTotal.reduce(0, {$0 + $1}))
            TotalArray[4] = String(PLTTotal.reduce(0, {$0 + $1}))
            TotalArray[5] = String(CRTotal.reduce(0, {$0 + $1}))
            TotalArray[6] = String(SDPTotal.reduce(0, {$0 + $1}))
            
            tableInventoryView.reloadData()
        }
    }
    func failedDonateSources(Response:String)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}
