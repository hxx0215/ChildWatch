//
//  BabySexSetViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/14.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class BabySexSetViewController: UIViewController {

    @IBOutlet weak var boyButton: UIButton!
    @IBOutlet weak var girlButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        okButton.layer.cornerRadius = 15;
        //okButton.layer.borderWidth = 0;
        //okButton.layer.borderColor = UIColor.grayColor().CGColor;
        okButton.layer.masksToBounds = true;
        
        cancelButton.layer.cornerRadius = 15;
        //cancelButton.layer.borderWidth = 0;
        //cancelButton.layer.borderColor = UIColor.grayColor().CGColor;
        cancelButton.layer.masksToBounds = true;
        
        let sex:String = DeviceManager.sharedManager().curentDevice.dicBabyData["sex"] as! String
        if sex == "男"{
            self.boyButtonClick(0)
        }
        else
        {
            self.girlButtonClick(0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.dismissViewControllerAnimated(false) { () -> Void in
//            
//        }
//    }
    
    @IBAction func boyButtonClick(sender : AnyObject){
        boyButton.selected = true;
        girlButton.selected = false;
    }
    @IBAction func girlButtonClick(sender : AnyObject){
        boyButton.selected = false;
        girlButton.selected = true;
    }
    @IBAction func okButtonClick(sender : AnyObject){
        if self.boyButton.selected{
            DeviceManager.sharedManager().curentDevice.dicBabyData .setObject("男", forKey: "sex")
        }
        else
        {
            DeviceManager.sharedManager().curentDevice.dicBabyData .setObject("女", forKey: "sex")
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        DeviceRequest .UpdateDeviceInfoWithParameters(DeviceManager.sharedManager().curentDevice.dicBabyData, success: { (AnyObject object) -> Void in
            
            print(object)
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            hud.mode = .Text
            if(state==0)
            {
                hud.labelText = "修改成功"
                self.dismissViewControllerAnimated(false) { () -> Void in
                    //通过通知中心发送通知
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "updateBabyData", object: nil))
                }
            }
            else
            {
                hud.labelText = "服务器内部错误"
            }
            
            hud.hide(true, afterDelay: 1.5)
            }) { (NSError error) -> Void in
                
                print(error)
                hud.mode = .Text
                hud.labelText = error.domain;
                hud.hide(true, afterDelay: 1.5)
        }
        
    }
    @IBAction func cancelButtonClick(sender : AnyObject){
        self.dismissViewControllerAnimated(false) { () -> Void in
            
        }
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
