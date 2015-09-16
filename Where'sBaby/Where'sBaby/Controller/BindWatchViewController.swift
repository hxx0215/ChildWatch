//
//  BindWatchViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/16.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit
import AVFoundation

class BindWatchViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var inputButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var bindView: UIView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var inputIDView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bindView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
        IHKeyboardAvoiding.setAvoidingView(self.bindView)
        self.inputButton.selected = true
        self.scanButton.selected = false
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
        sender.selected = true
        scanButton.selected = false
        refreshInputView()
        self.session.stopRunning()
    }
    @IBAction func scanClicked(sender: UIButton) {
        sender.selected = true
        inputButton.selected = false
        inputTextField.resignFirstResponder()
        refreshInputView()
        self.session.startRunning()
        self.preview.frame = self.scanView.bounds
    }

    func refreshInputView(){
        inputIDView.hidden = !inputButton.selected
        scanView.hidden = !scanButton.selected
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
