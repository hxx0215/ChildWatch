//
//  RelationViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/17.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class RelationViewController: UIViewController {

    @IBOutlet weak var backView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        IHKeyboardAvoiding.setAvoidingView(self.view, withTriggerView: self.backView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
