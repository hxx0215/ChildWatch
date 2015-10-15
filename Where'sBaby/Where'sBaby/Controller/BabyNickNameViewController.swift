//
//  BabyNickNameViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/15.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class BabyNickNameViewController: UIViewController {

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameTextFileld: UITextField!
    @IBOutlet weak var inputBackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        IHKeyboardAvoiding.setAvoidingView(self.inputBackView)
        
        okButton.layer.cornerRadius = 15;
        //okButton.layer.borderWidth = 0;
        //okButton.layer.borderColor = UIColor.grayColor().CGColor;
        okButton.layer.masksToBounds = true;
        
        cancelButton.layer.cornerRadius = 15;
        //cancelButton.layer.borderWidth = 0;
        //cancelButton.layer.borderColor = UIColor.grayColor().CGColor;
        cancelButton.layer.masksToBounds = true;
        
        nameTextFileld.layer.cornerRadius = 5;
        nameTextFileld.layer.borderWidth = 1;
        nameTextFileld.layer.masksToBounds = true;
        nameTextFileld.layer.borderColor = UIColor.grayColor().CGColor;
        
        nameTextFileld.text = ChildDeviceManager.sharedManager().curentDevice.dicBabyData["nickname"] as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nameTextFileld.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func okButtonClick(sender : AnyObject){
        ChildDeviceManager.sharedManager().curentDevice.dicBabyData.setObject(nameTextFileld.text!, forKey: "nickname")
        let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        DeviceRequest .UpdateDeviceInfoWithParameters(ChildDeviceManager.sharedManager().curentDevice.dicBabyData, success: { (AnyObject object) -> Void in
            
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
