//
//  ChatViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/31.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class ChatViewController: JSQMessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    

    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewControllerAnimated(true)
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
