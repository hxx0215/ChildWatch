//
//  BabyHeightViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/15.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class BabyHeightViewController: UIViewController,ZHRulerViewDelegate {

    @IBOutlet weak var rulerView: ZHRulerView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var value:Int = 100
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
        
//        self.rulerView.layer.cornerRadius = 3;
//        self.rulerView.layer.borderWidth = 1;
//        self.rulerView.layer.borderColor = UIColor.grayColor().CGColor;
//        self.rulerView.layer.masksToBounds = true;
        self.rulerView.setWithMixNuber(35, maxNuber: 175, showType:rulerViewShowType.ViewshowVerticalType, rulerMultiple: 10)
        let height = ChildDeviceManager.sharedManager().curentDevice.dicBabyData["height"]?.integerValue
        if(height>=30&&height<=180)
        {
            value = height!
        }
        self.rulerView.defaultVaule = CGFloat.init(value)
        valueLabel.text = String.init(value) + "cm"
        self.rulerView.delegate=self;
        self.rulerView.backgroundColor = UIColor.whiteColor()// [UIColor colorWithRed:0xb5/255.0  green:0xb5/255.0 blue:0xb5/255.0 alpha:0.4f];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonClick(sender : AnyObject){
        let height = value+1
        if(height>=30&&height<=180)
        {
            value = height
        }
        rulerView.defaultVaule = CGFloat.init(value)
    }
    @IBAction func lowerButtonClick(sender : AnyObject){
        let height = value-1
        if(height>=30&&height<=180)
        {
            value = height
        }
        rulerView.defaultVaule = CGFloat.init(value)
    }

    @IBAction func okButtonClick(sender : AnyObject){
        ChildDeviceManager.sharedManager().curentDevice.dicBabyData.setObject("\(value)", forKey: "height")
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
        print(rulerValue)
        let height:Int = Int.init(rulerValue+1+0.2)
        if(height>=30&&height<=180)
        {
            value = height
            valueLabel.text = String.init(value) + "cm"
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
