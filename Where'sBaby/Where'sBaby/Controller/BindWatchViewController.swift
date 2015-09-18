//
//  BindWatchViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/16.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit
import AVFoundation

enum BindType: String{
    case InputDeviceID
    case ScanDeviceID
    case InputNickName
    case WaitAdmin
    case AdminAgree
    case AdminReject
}

class BindWatchViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var inputButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bindView: UIView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var inputIDView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var inputTextFieldBGView: UIImageView!
    var bindType: BindType = .InputDeviceID
    var bindDeviceID: String?
    var nickName: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bindView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
        IHKeyboardAvoiding.setAvoidingView(self.bindView)
        self.bindType = .InputDeviceID
        refreshInputView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupCamera()
    }
    @IBAction func inputClicked(sender: UIButton) {
        bindType = .InputDeviceID
        refreshInputView()
        self.session.stopRunning()
    }
    @IBAction func scanClicked(sender: UIButton) {
        bindType = .ScanDeviceID
        inputTextField.resignFirstResponder()
        refreshInputView()
        self.session.startRunning()
        self.preview.frame = self.scanView.bounds
    }
    @IBAction func doneInputClicked(sender: UIButton) {
        if self.bindType == .InputDeviceID{
            self.bindDeviceID = self.inputTextField.text!
            bindType = .InputNickName
            refreshInputView()
        }
        else
        {
            self.nickName = self.inputTextField.text!
            self.inputTextField.resignFirstResponder()
            doBindDevice()
        }
    }
    
    func doBindDevice(){
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! NSNumber
        let dic:[String:String] = ["deviceno":self.bindDeviceID!,"nickname":self.nickName!,"userid":userId.stringValue]
        let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        hud.labelText = "绑定中"
        LoginRequest.AddDeviceBindWithParameters(dic, success: { (AnyObject object) -> Void in
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            
            //0是已经有超级管理员的
            //7是之前没有管理员，设备初次第一个人绑定，这个人就是超级管理员
            if(state==0  || state==7)
            {
                hud.mode = .Text
                hud.labelText = "绑定成功";
                hud.hide(true, afterDelay: 1.5)
                if state==0{
                    self.bindType = .WaitAdmin
                    self.refreshInputView()
                }
                else{
                    let res = dic["data"] as! NSArray
                    let f = res.firstObject as! [String:AnyObject]
                    for (key,value) in f{
                        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
                    }
                        
                    self.dismissViewControllerAnimated(true){
                        
                    }
                }
            }
            else if(state==1)
            {
                
                hud.mode = .Text
                hud.labelText = "用户已经和设备绑定";
                hud.hide(true, afterDelay: 1.5)
            }
            else if(state==4)
            {
                
                hud.mode = .Text
                hud.labelText = "用户不存在";
                hud.hide(true, afterDelay: 1.5)
            }
            else if(state==5)
            {
                
                hud.mode = .Text
                hud.labelText = "超过设备最大绑定数";
                hud.hide(true, afterDelay: 1.5)
            }
            else if(state==6)
            {
                
                hud.mode = .Text
                hud.labelText = "设备未启用";
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

    func refreshInputView(){
        inputTextField.resignFirstResponder()
        inputTextField.text = ""
        self.inputIDView.hidden = (self.bindType == .ScanDeviceID)
        self.scanView.hidden = (self.bindType != .ScanDeviceID)
        inputButton.hidden = !(self.bindType == .ScanDeviceID || self.bindType == .InputDeviceID)
        scanButton.hidden = !(self.bindType == .ScanDeviceID || self.bindType == .InputDeviceID)
        switch self.bindType{
        case .InputDeviceID:
            inputButton.selected = true;
            scanButton.selected = false;
            inputTextField.placeholder = "请输入设备码"
            doneButton.setTitle("立即绑定", forState: .Normal)
            inputLabel.hidden = false;
            inputTextField.keyboardType = .NumberPad
            inputLabel.text = "请在手表上找到16位绑定ID输入"
            inputTextField.hidden = false
            inputTextFieldBGView.hidden = false;
            doneButton.hidden = false
        case .ScanDeviceID:
            inputButton.selected = false
            scanButton.selected = true
        case .InputNickName:
            inputTextField.keyboardType = .Default
            inputTextField.placeholder = "请输入您的名称"
            doneButton.setTitle("确定", forState: .Normal)
            inputLabel.hidden = true
            inputTextField.hidden = false
            inputTextFieldBGView.hidden = false;
            doneButton.hidden = false
        case .WaitAdmin:
            inputLabel.text = "您的请求已发送给管理员,请等待管理员处理,如果等待时间过长请联系管理员"
            inputLabel.hidden = false
            inputTextField.hidden = true
            inputTextFieldBGView.hidden = true;
            doneButton.hidden = true
        case .AdminAgree: break
        case .AdminReject: break
        }
    }
    
    lazy var session: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSessionPreset1920x1080
        return s
    }()
    
    lazy var preview: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer.init(session: self.session)
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return layer
    }()
    func setupCamera(){
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput.init(device: device)
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            if self.session.canAddOutput(output){
                self.session.addOutput(output)
            }
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            self.scanView.layer.insertSublayer(self.preview, atIndex: 0)
        } catch{
            print(error)
        }
        
    }
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        self.session.stopRunning()
        var stringValue:String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0]
            if metadataObject.respondsToSelector(Selector("stringValue")){
                stringValue = metadataObject.stringValue
            }else{
                stringValue = nil
            }
        }else{
            stringValue = nil
        }
        print(stringValue)
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
