//
//  WBWelcomeViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/12.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class WBWelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginClicked(sender: UIButton) {
        
    }

    @IBAction func registerClicked(sender: UIButton) {
        self.performSegueWithIdentifier("LoginRegisterSegueIdentifier", sender: sender)
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
