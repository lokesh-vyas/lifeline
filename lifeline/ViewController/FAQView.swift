//
//  FAQView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class FAQView: UIViewController,UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        HudBar.sharedInstance.showHudWithMessage(message: "TOAST_PLEASE_WAIT", view: self.view)
        webView.loadRequest(NSURLRequest(url: NSURL(string: "http://www.lifeline.services/faq")! as URL) as URLRequest)
        NotificationCenter.default.addObserver(self, selector: #selector(FAQView.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        // Do any additional setup after loading the view.
    }
    //MARK:- Back Button
    @IBAction func BackButton(_ sender: Any)
    {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
  
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
         HudBar.sharedInstance.hideHudFormView(view: self.view)
    }
    //MARK:- Share Application URL With Activity
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
}
