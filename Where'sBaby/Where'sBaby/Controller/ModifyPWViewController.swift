//
//  ModifyPWViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/10.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class ModifyPWViewController: UIViewController {

    @IBOutlet weak var confirm: UIView!
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inputBackView.clipsToBounds = false
        self.inputBackView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
        IHKeyboardAvoiding.setAvoidingView(self.inputBackView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func doneClicked(sender: UIButton) {
        if self.checkTextFeild(){
            let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! NSNumber
            let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            let dic = ["oldpwd":self.userNameTextField.text!,"newpwd":self.passTextField.text!,"id":userId.stringValue]
            LoginRequest.UpdatePasswordWithParameters(dic, success: { (AnyObject object) -> Void in
                let dic:NSDictionary = object as! NSDictionary
                let state:Int = dic["state"] as! Int
                if(state==0)
                {
                    hud.mode = .Text
                    hud.labelText = "成功";
                    hud.hide(true, afterDelay: 1.5)
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else if(state==1)
                {
                    
                    hud.mode = .Text
                    hud.labelText = "用户名不存在";
                    hud.hide(true, afterDelay: 1.5)
                }
                else if(state==4)
                {
                    
                    hud.mode = .Text
                    hud.labelText = "旧密码错误";
                    hud.hide(true, afterDelay: 1.5)
                }
                else
                {
                    hud.mode = .Text
                    hud.labelText = "服务器内部错误";
                    hud.hide(true, afterDelay: 1.5)
                }
                }) { (NSError error) -> Void in
                    print(error)
                    hud.mode = .Text
                    hud.labelText = error.domain;
                    hud.hide(true, afterDelay: 1.5)
            }
        }
    }
    
    func checkTextFeild()->Bool{
        if self.userNameTextField.text!.isEmpty {
            let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            hud.mode = .Text
            hud.labelText = "请输入原密码"
            hud.hide(true, afterDelay: 1.5)
            return false;
        }
        if self.passTextField.text!.isEmpty{
            let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            hud.mode = .Text
            hud.labelText = "请输入新密码"
            hud.hide(true, afterDelay: 1.5)
            return false;
        }
        if self.passTextField.text!.compare(self.confirmPassTextField.text!) != .OrderedSame{
            let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            hud.mode = .Text
            hud.labelText = "两次密码不一致"
            hud.hide(true, afterDelay: 1.5)
            return false;
        }
        return true;
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
