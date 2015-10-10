//
//  RightMenuViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/20.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messageClick(sender: UIButton) {
        self.revealViewController().performSegueWithIdentifier("message", sender: nil);
    }

    @IBAction func ContactsClick(sender: AnyObject) {
        self.revealViewController().performSegueWithIdentifier("Contacts", sender: nil);
    }
    @IBAction func watchSettingClick(sender: AnyObject) {
        self.revealViewController().performSegueWithIdentifier("watchSetting", sender: nil);
    }
    @IBAction func appSettingClick(sender: AnyObject) {
        self.revealViewController().performSegueWithIdentifier("appSetting", sender: nil);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
