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
        HudBar.sharedInstance.showHudWithMessage(message: "Please wait..", view: self.view)
        webView.loadRequest(NSURLRequest(url: NSURL(string: "www.google.com")! as URL) as URLRequest)
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
}
