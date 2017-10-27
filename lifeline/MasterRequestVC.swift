//
//  MasterRequestVC.swift
//  lifeline
//
//  Created by Anjali on 11/10/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MasterRequestVC: UIViewController {

    @IBOutlet weak var segmentObj: UISegmentedControl!
    
    @IBOutlet weak var contentView: UIView!
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }

    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? =
    {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "MyRequestView")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? =
    {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "MyDonationView")
        
        return secondChildTabVC
    }()
    @IBAction func btnBackTapped(_ sender: Any) {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let font = UIFont.boldSystemFont(ofSize: 15)
        segmentObj.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        segmentObj.setTitle(MultiLanguage.getLanguageUsingKey("My Request"), forSegmentAt: 0)
        segmentObj.setTitle(MultiLanguage.getLanguageUsingKey("My Donation"), forSegmentAt: 1)
        segmentObj.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController
        {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    @IBAction func switchTabs(_ sender: UISegmentedControl)
    {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int)
    {
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex)
        {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController?
    {
        var vc: UIViewController?
        switch index
        {
        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
        default:
            return nil
        }
        return vc
    }
}
