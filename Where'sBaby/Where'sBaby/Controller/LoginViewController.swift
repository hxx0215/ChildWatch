//
//  LoginViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/13.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit
enum LoginType: String{
    case Login
    case Register
    case Forget
}

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var phoneTop: NSLayoutConstraint!
    @IBOutlet weak var checkTop: NSLayoutConstraint!
    @IBOutlet weak var passTop: NSLayoutConstraint!
    @IBOutlet weak var doneTop: NSLayoutConstraint!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var forgetButton: UIButton!
    var loginType: LoginType = .Login
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inputBackView.clipsToBounds = false
        self.inputBackView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
        IHKeyboardAvoiding.setAvoidingView(self.inputBackView)
        self.layoutWithLoginType(self.loginType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutWithLoginType(loginType: LoginType){
        switch loginType{
        case .Login:
            self.checkView.hidden = true
            self.passTop.constant = -50
            self.phoneTop.constant = 40
            self.forgetButton.hidden = false
        case .Forget:
            print("Forget")
            self.checkView.hidden = false
            self.phoneTop.constant = 8
            self.passTop.constant = 15
            self.forgetButton.hidden = true
        case .Register:
            print("Register")
            self.forgetButton.hidden = true
        }
    }

    @IBAction func backClicked(sender: UIButton) {
        if self.loginType == .Forget {
            self.loginType = .Login
            self.layoutWithLoginType(self.loginType)
        }else{
            self.dismissViewControllerAnimated(true){
                
            }
        }
    }
    @IBAction func doneClicked(sender: UIButton) {
    }
    @IBAction func fogetClicked(sender: UIButton) {
        self.loginType = .Forget
        self.layoutWithLoginType(self.loginType)
    }
    @IBAction func receiveClicked(sender: UIButton) {
        sender.setTitle("发送中", forState: .Normal)
        let dic = ["username":self.userNameTextField.text!,"type":"1"]
        LoginRequest.GetAuthCodeWithParameters(NSDictionary(dictionary: dic), success: { (AnyObject object) -> Void in
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            if(state==0)
            {
                let randomDic:NSDictionary = dic["data"]?.firstObject as! NSDictionary
                let random:String = randomDic["random"] as! String
                print(random)
            }
            
            sender.setTitle("获取验证码", forState: .Normal)
            
            }) { (NSError error) -> Void in
               print(error)
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
