//
//  RelationViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/17.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class RelationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameField : UITextField!
    @IBOutlet weak var mobelField : UITextField!
    @IBOutlet weak var mobel_SortField : UITextField!
    @IBOutlet weak var backView : UIView!
    @IBOutlet weak var imageView : UIImageView!
    let array : [String] = ["爸爸","妈妈","爷爷","奶奶","姑姑","叔叔"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        IHKeyboardAvoiding.setAvoidingView(self.view, withTriggerView: self.mobel_SortField)
        IHKeyboardAvoiding.setKeyboardAvoidingMode(KeyboardAvoidingModeMinimum)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(sender: UIButton) {
        self.imageView.image = sender.backgroundImageForState(.Normal)
        if sender.tag>=7{
            self.nameField.text = ""
            self.nameField.enabled = true
        }
        else
        {
            self.nameField.text = array[sender.tag-1]
            self.nameField.resignFirstResponder()
            self.nameField.enabled = false
            
        }
    }
    
    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveClicked(sender: UIButton) {
        let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        if self.nameField.text!.isEmpty{
            hud.mode = .Text
            hud.detailsLabelText = "请输入称呼"
            hud.hide(true, afterDelay: 1.5)
            return
        }
        if self.mobelField.text!.isEmpty{
            hud.mode = .Text
            hud.detailsLabelText = "请输入手机号码"
            hud.hide(true, afterDelay: 1.5)
            return
        }
        let dic:NSDictionary = ["nickname":self.nameField.text!,"mobile":self.mobelField.text!,"mobileshort":self.mobel_SortField.text!,"deviceno":ChildDeviceManager.sharedManager().currentDeviceNo,"autoanswer":0,"sosflag":0]
        DeviceRequest.AddFriendsWithParameters(dic, success: { (object) -> Void in
            print(object)
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            if(state==0){
                hud.detailsLabelText = "添加成功"
                self.navigationController?.popViewControllerAnimated(true)
            }
            else if(state == 1)
            {
                hud.detailsLabelText = "手机号码已经在通讯录中"
            }
            else
            {
                hud.detailsLabelText = "添加失败"
            }
            hud.mode = .Text
            hud.hide(true, afterDelay: 1.5)
            }) { (NSError error) -> Void in
                hud.mode = .Text
                hud.detailsLabelText = error.domain
                hud.hide(true, afterDelay: 1.5)
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
