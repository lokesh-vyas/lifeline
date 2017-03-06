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
    var tagg : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.rowHeight = 100
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnHomeTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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
        return cell
    }
    func doTry(sender : UIButton) {
        print(sender.tag)
        MarkerData.SharedInstance.oneRequestOfDonate = MarkerData.SharedInstance.IndividualsArray[sender.tag]
        print("-:user name :-",MarkerData.SharedInstance.IndividualsArray[sender.tag]["UserName"]!)
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
