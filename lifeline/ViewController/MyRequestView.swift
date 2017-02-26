//
//  MyRequestView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MyRequestView: UIViewController {

    @IBOutlet weak var tableRequestView: UITableView!
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        tableRequestView.contentInset = UIEdgeInsetsMake(-35, 0.0, -20, 0.0)
        // Do any additional setup after loading the view.
    }
    //MARK:- BackButton
    @IBAction func BackButton(_ sender: Any)
    {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
}
extension MyRequestView:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:MyRequestCell? = tableRequestView.dequeueReusableCell(withIdentifier: "MyRequestCell") as? MyRequestCell
        if cell == nil
        {
            let nib:Array = Bundle.main.loadNibNamed("MyRequestCell", owner: self, options: nil)!
            cell = nib[0] as? MyRequestCell
        }
        return cell!
    }
}
