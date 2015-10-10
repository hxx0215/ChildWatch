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
    @IBOutlet weak var confirm: UIView!
    @IBOutlet weak var inputBackView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.layoutWithLoginType(self.loginType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutWithLoginType(loginType: LoginType){
        self.userNameTextField.text = "";
        self.codeTextField.text = "";
        self.passTextField.text = "";
        switch loginType{
        case .Login:
            self.checkView.hidden = true
            self.confirm.hidden = true
            self.phoneTop.constant = 40
            self.passTop.constant = -50
            self.forgetButton.hidden = false
        case .Forget:
            print("Forget")
            self.checkView.hidden = false
            self.confirm.hidden = false
            self.phoneTop.constant = 28
            self.passTop.constant = 10
            self.forgetButton.hidden = true
        case .Register:
            print("Register")
            self.forgetButton.hidden = true
            self.confirm.hidden = false
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
        if self.checkTextFeild(){
            switch loginType{
            case .Login:
                self.doLogin()
            case .Forget:
                self.doForget()
            case .Register:
                self.doRegister()
            }
        }
    }
    @IBAction func fogetClicked(sender: UIButton) {
        self.loginType = .Forget
        self.layoutWithLoginType(self.loginType)
    }
    @IBAction func receiveClicked(sender: UIButton) {
        let bo = NSString(UTF8String: self.userNameTextField.text!)?.checkTel()
        if bo==false {
            let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            hud.mode = .Text
            hud.labelText = "请输入正确的手机号码";
            hud.hide(true, afterDelay: 1.5)
        }
        else
        {
            sender.setTitle("发送中", forState: .Normal)
            sender.setTitle("发送中", forState: .Highlighted)
            let dic = ["username":self.userNameTextField.text!,"type":"1"]
            var codeType:Int32 = 0;
            if self.loginType == .Forget{
                codeType = 1;
            }
            LoginRequest.GetAuthCodeWithParameters(NSDictionary(dictionary: dic), type: codeType, success: { (AnyObject object) -> Void in
                let dic:NSDictionary = object as! NSDictionary
                let state:Int = dic["state"] as! Int
                if(state==0)
                {
                    let randomDic:NSDictionary = dic["data"]?.firstObject as! NSDictionary
                    let random:String = randomDic["random"] as! String
                    print(random)
                }
                else if(state==1)
                {
                    let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
                    hud.mode = .Text
                    if self.loginType == .Forget{
                        hud.labelText = "用户不存在";
                    }
                    else{
                        hud.labelText = "用户名已经被注册";
                    }
                    hud.hide(true, afterDelay: 1.5)
                }
                else
                {
                    let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
                    hud.mode = .Text
                    hud.labelText = "服务器内部错误";
                    hud.hide(true, afterDelay: 1.5)
                }
                
                sender.setTitle("获取验证码", forState: .Normal)
                
                }) { (NSError error) -> Void in
                    print(error)
                    let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
                    hud.mode = .Text
                    hud.labelText = error.domain;
                    hud.hide(true, afterDelay: 1.5)
            }
        }
        
    }
    
    func checkTextFeild()->Bool{
        let bo = NSString(UTF8String: self.userNameTextField.text!)?.checkTel()
        if bo==false {
            let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            hud.mode = .Text
            hud.labelText = "请输入正确的手机号码"
            hud.hide(true, afterDelay: 1.5)
            return false;
        }
        if self.codeTextField.text!.isEmpty&&self.loginType != .Login{
            let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            hud.mode = .Text
            hud.labelText = "请输入验证码"
            hud.hide(true, afterDelay: 1.5)
            return false;
        }
        if self.passTextField.text!.isEmpty{
            let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            hud.mode = .Text
            hud.labelText = "请输入密码"
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
    
    func doLogin(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        let dic = ["username":self.userNameTextField.text!,"password":self.passTextField.text!]
        LoginRequest.UserLoginWithParameters(dic, success: { (AnyObject object) -> Void in
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            if(state==0)
            {
                hud.mode = .Text
                hud.labelText = "登录成功";
                hud.hide(true, afterDelay: 1.5)
                let res = dic["data"] as! NSArray
                let f = res.firstObject as! [String:AnyObject]
                for (key,value) in f{
                    NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
                }
                self.dismissViewControllerAnimated(true){
                    
                }
                
                let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! NSNumber
                if (NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") != nil){
                    let token = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as! String
                    let dicTerminal:[String:String] = ["token":token,"model":"2","userid":userId.stringValue]
                    LoginRequest.InsertTerminalWithParameters(dicTerminal, success: { (AnyObject object) -> Void in
                        print(object)
                        }, failure: { (NSError) -> Void in
                            
                    })
                }
                
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
                hud.labelText = "密码有误";
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
    
    func doForget(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        if passTextField.text != confirmPassTextField.text{
            hud.mode = .Text
            hud.labelText = "两次输入密码不一致,请重新输入"
            hud.hide(true, afterDelay: 1.5)
            return
        }
        let dic = ["username":self.userNameTextField.text!,"password":self.passTextField.text!,"random":self.codeTextField.text!]
        LoginRequest.ResetPassWordWithParameters(dic, success: { (AnyObject object) -> Void in
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            if(state==0)
            {
                hud.mode = .Text
                hud.labelText = "成功";
                hud.hide(true, afterDelay: 1.5)
                self.loginType = .Login
                self.layoutWithLoginType(self.loginType)
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
                hud.labelText = "验证码有误";
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
    
    func doRegister(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        if passTextField.text != confirmPassTextField.text{
            hud.mode = .Text
            hud.labelText = "两次输入密码不一致,请重新输入"
            hud.hide(true, afterDelay: 1.5)
            return
        }
        let dic = ["username":self.userNameTextField.text!,"password":self.passTextField.text!,"random":self.codeTextField.text!]
        LoginRequest.UserRegisterWithParameters(dic, success: { (AnyObject object) -> Void in
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            if(state==0)
            {
                hud.mode = .Text
                hud.labelText = "注册成功";
                hud.hide(true, afterDelay: 1.5)
                self.loginType = .Login
                self.layoutWithLoginType(self.loginType)
            }
            else if(state==1)
            {
                
                hud.mode = .Text
                hud.labelText = "用户名已经被注册";
                hud.hide(true, afterDelay: 1.5)
            }
            else if(state==4)
            {
                
                hud.mode = .Text
                hud.labelText = "验证码有误";
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
