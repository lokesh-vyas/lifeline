//
//  RequestedByIndividuals.swift
//  lifeline
//
//  Created by Apple on 28/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class RequestedByIndividuals: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var requestDetailsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        tblView.rowHeight = 100
        tblView.backgroundColor = UIColor.clear
        self.tblView.contentInset = UIEdgeInsetsMake(-35, 0, -20, 0);
        NotificationCenter.default.addObserver(self, selector: #selector(RequestedByIndividuals.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        
    }
    //MARK:-PushNotificationView
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
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnHomeTapped(_ sender: Any) {
        
//        dismiss(animated: true, completion: nil)
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealView, animated: true, completion: nil)
        
    }
}

extension RequestedByIndividuals : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MarkerData.SharedInstance.IndividualsArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellRequestDetails
        cell.lblUserName.text = MarkerData.SharedInstance.IndividualsArray[indexPath.row]["UserName"] as! String?
        cell.lblNeedDescription.text = MarkerData.SharedInstance.IndividualsArray[indexPath.row]["CName"] as! String?
        cell.lblContactNumber.text = MarkerData.SharedInstance.IndividualsArray[indexPath.row]["CContactNumber"] as! String?
        cell.btnDonate.tag = indexPath.row
        cell.btnDonate.addTarget(self, action: #selector(RequestedByIndividuals.doTry(sender:)), for: .touchUpInside)
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(RequestedByIndividuals.lblCallTapped(_:)))
        cell.lblContactNumber.addGestureRecognizer(tapRec)
        cell.lblContactNumber.isUserInteractionEnabled = true
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    func doTry(sender : UIButton) {
        print(sender.tag)
        MarkerData.SharedInstance.oneRequestOfDonate = MarkerData.SharedInstance.IndividualsArray[sender.tag]
        print("-:user name :-",MarkerData.SharedInstance.IndividualsArray[sender.tag]["UserName"]!)
        print("-:Typee name :-",MarkerData.SharedInstance.IndividualsArray[sender.tag]["CTypeOfOrg"]!)
    }
    
    func lblCallTapped(_ sender: UITapGestureRecognizer) {
        
        let button = sender.view?.tag
        let phoneNumber: String
        let formatedNumber: String
        if(MarkerData.SharedInstance.IndividualsArray[button!]["CContactNumber"] != nil)
        {
            phoneNumber = String(describing: MarkerData.SharedInstance.IndividualsArray[button!]["CContactNumber"])
            print("Requester phone number is : \(phoneNumber)")
            formatedNumber = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            print("calling \(formatedNumber)")
        }
        else
        {
            phoneNumber = (MarkerData.SharedInstance.IndividualsArray[button!]["CContactNumber"] as! String)
            print("Requester phone number is : \(phoneNumber)")
            formatedNumber = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            print("calling \(formatedNumber)")
        }
        if let url = URL(string: "tel://\(formatedNumber)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
}

//FIXME:- no need of this extension
extension RequestedByIndividuals : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let IndConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "IndividualConfirmDonate") as! IndividualConfirmDonate
//        self.navigationController?.pushViewController(IndConfirmDonate, animated: true)
//        present(IndConfirmDonate, animated: true, completion: nil)
        
    }
    

}


//MARK:- Custom Cell for request Details
class CustomCellRequestDetails: UITableViewCell {
    
    @IBOutlet weak var lblNeedDescription: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var btnDonate: UIButton!
    @IBAction func btnDonateTapped(_ sender: Any) {
        
        
//        let IndConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "IndividualConfirmDonate") as! IndividualConfirmDonate
//        self.navigationController?.pushViewController(IndConfirmDonate, animated: true)
    }
    
}
