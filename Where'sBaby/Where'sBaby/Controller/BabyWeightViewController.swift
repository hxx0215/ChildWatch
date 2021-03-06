//
//  BabyWeightViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/15.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class BabyWeightViewController: UIViewController,ZHRulerViewDelegate {

    @IBOutlet weak var rulerView: ZHRulerView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var value:Int = 30
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
        
        self.rulerView.setWithMixNuber(10, maxNuber: 80, showType:rulerViewShowType.ViewshowHorizontalType, rulerMultiple: 10)
        let weight = ChildDeviceManager.sharedManager().curentDevice.dicBabyData["weight"]?.integerValue
        if(weight>=5&&weight<=80)
        {
            value = weight!
        }
        self.rulerView.defaultVaule = CGFloat.init(value)
        valueLabel.text = String.init(value) + "kg"
        self.rulerView.delegate=self;
        self.rulerView.backgroundColor = UIColor.whiteColor()// [UIColor colorWithRed:0xb5/255.0  green:0xb5/255.0 blue:0xb5/255.0 alpha:0.4f];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonClick(sender : AnyObject){
        let weight = value+1
        if(weight>=5&&weight<=80)
        {
            value = weight
        }
        rulerView.defaultVaule = CGFloat.init(value)
    }
    @IBAction func lowerButtonClick(sender : AnyObject){
        let weight = value-1
        if(weight>=5&&weight<=80)
        {
            value = weight
        }
        rulerView.defaultVaule = CGFloat.init(value)
    }

    @IBAction func okButtonClick(sender : AnyObject){
        
        ChildDeviceManager.sharedManager().curentDevice.dicBabyData.setObject("\(value)", forKey: "weight")
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
    
    func getRulerValue(rulerValue: CGFloat, withScrollRulerView rulerView: ZHRulerView!) {
        let weight:Int = Int.init(rulerValue+0.5)
        if(weight>=5&&weight<=80)
        {
            value = weight
            valueLabel.text = String.init(value) + "kg"
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
