//
//  BabyDataTableViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/14.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class BabyDataTableViewController: UITableViewController,AlartViewControllerDelegate {

    @IBOutlet weak var headimageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nameEditeButton: UIButton!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var mobile_shortLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var brithLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var contactsLabel: UILabel!
    var first: Bool = true
    var contactsDic : NSDictionary = NSDictionary()
    var observer: NSObjectProtocol!
    //var babyDataDic : NSMutableDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        headimageView.layer.cornerRadius = 17;
        headimageView.layer.borderWidth = 0;
        headimageView.layer.borderColor = UIColor.grayColor().CGColor;
        headimageView.layer.masksToBounds = true;
        
        nameEditeButton.layer.cornerRadius = 15;
        nameEditeButton.layer.borderWidth = 0;
        nameEditeButton.layer.borderColor = UIColor.grayColor().CGColor;
        nameEditeButton.layer.masksToBounds = true;
        
        observer = NSNotificationCenter.defaultCenter().addObserverForName("updateBabyData", object: nil, queue: NSOperationQueue.mainQueue()) { (NSNotification) -> Void in
            self.updateBabyData()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateBabyData()
    }
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if first{
            first = false
            let hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let dic = ["deviceno":ChildDeviceManager.sharedManager().curentDevice.dicBase["deviceno"] as! String]
            DeviceRequest.GetDeviceInfoWithParameters(NSDictionary(dictionary: dic), success: { (AnyObject object) -> Void in
        
                print(object)
                let dic:NSDictionary = object as! NSDictionary
                let state:Int = dic["state"] as! Int
                if(state==0)
                {
                    let dicData:NSDictionary = dic["data"]!.firstObject as! NSDictionary
                    ChildDeviceManager.sharedManager().curentDevice.dicBabyData = NSMutableDictionary(dictionary: dicData)
                    self.updateBabyData()
                    if true{
                        let dic = ["deviceno":ChildDeviceManager.sharedManager().currentDeviceNo]
                        DeviceRequest.GetPhoneBookListWithParameters(dic, success: { (object) -> Void in
                            print(object)
                            let dic:NSDictionary = object as! NSDictionary
                            let state:Int = dic["state"] as! Int
                            if(state==0)
                            {
                                let dicArray:NSArray = dic["data"] as! NSArray
                                for dicDatat in dicArray{
                                    let mobile:String = dicDatat["mobile"] as! String
                                    let username:String = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
                                    if mobile == username {
                                        self.contactsDic = dicDatat as! NSDictionary
                                        
                                        break
                                    }
                                }
                                self.updateBabyData()
                            }
                            hud.hide(true)
                            }) { (NSError error) -> Void in
                                print(error)
                                hud.mode = .Text
                                hud.detailsLabelText = error.domain
                                hud.hide(true, afterDelay: 1.5)
                        }
                    }
                    
                }
                else
                {
                    hud.detailsLabelText = "获取信息失败";
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClicked(sender: UIButton) {
        NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func unBindClicked(sender: UIButton) {
        if contactsDic.count>0{
            let role:String = contactsDic["role"] as! String
            if role == "super"{
                self.performSegueWithIdentifier("alertIdentifier", sender: 0)
            }
            else
            {
                self.performSegueWithIdentifier("alertIdentifier", sender: 1)
            }
        }
    }

    @IBAction func headImageClicked(sender: UIButton) {
    }
    
    func updateBabyData()
    {
        let babyDataDic:NSDictionary! = ChildDeviceManager.sharedManager().curentDevice.dicBabyData
        if (babyDataDic != nil){
            self.headimageView.setImageWithURL(NSURL(string: FileRequest.imageURL(babyDataDic["headimage"] as? String))!)
            self.mobileLabel.text = babyDataDic["mobile"] as? String
            self.brithLabel.text = babyDataDic["brith"] as? String
            self.gradeLabel.text = babyDataDic["grade"] as? String
            self.heightLabel.text = babyDataDic["height"] as? String
            self.weightLabel.text = babyDataDic["weight"] as? String
            self.sexLabel.text = babyDataDic["sex"] as? String
            self.nicknameLabel.text = babyDataDic["nickname"] as? String
            self.mobile_shortLabel.text = babyDataDic["mobile_short"] as? String
        }
        if contactsDic.count>0{
            self.contactsLabel.text = contactsDic["nickname"] as? String
        }
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 3 {
            self.performSegueWithIdentifier("ContactDetailsIdentifier", sender: contactsDic)
        }
    }
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    func didClickButton(index: Int, tag: Int) {
        if tag == 0{
            if index == 1{
                self.performSegueWithIdentifier("Contacts", sender: contactsDic)
            }
        }
        else
        {
            if index == 1{
                let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
                let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! NSNumber
                let dic:[String:String] = ["deviceno":ChildDeviceManager.sharedManager().curentDevice.dicBase["deviceno"] as! String,"userid":userId.stringValue]
                DeviceRequest.RemoveDeviceBindWithParameters(dic, success: { (object) -> Void in
                    print(object)
                    let dic:NSDictionary = object as! NSDictionary
                    let state:Int = dic["state"] as! Int
                    if(state==0){
                        hud.detailsLabelText = "解绑成功"
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        })
                    }
                    else if(state == 1)
                    {
                        hud.detailsLabelText = "解绑失败"
                    }
                    else if(state == 4)
                    {
                        hud.detailsLabelText = "当前角色为超级管理员，必须先将超级管理员转让给其他家人后，才能解绑"
                    }
//                    else if(state == 5)
//                    {
//                        hud.detailsLabelText = "要转让的家人手机号不是APP用户"
//                    }
                    else
                    {
                        hud.detailsLabelText = "解绑失败"
                    }
                    hud.mode = .Text
                    hud.hide(true, afterDelay: 1.5)
                    }, failure: { (NSError error) -> Void in
                        
                        hud.mode = .Text
                        hud.detailsLabelText = error.domain
                        hud.hide(true, afterDelay: 1.5)
                })
                
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ContactDetailsIdentifier"{
            let vc:ContactDetailsTableViewController = segue.destinationViewController as! ContactDetailsTableViewController
            let dic:NSDictionary = sender as! NSDictionary
            vc.currentDic = NSMutableDictionary.init(dictionary: dic)
            vc.canAdmin = false
        }
        else if segue.identifier == "alertIdentifier"{
            let vc:AlartViewController = segue.destinationViewController as! AlartViewController
            vc.tag = sender as! Int
            if(vc.tag==0){
                vc.text = "解除绑定后,您将不能再查\n看宝贝信息,确定要解绑吗?"
            }
            else
            {
                vc.text = "解除绑定后,您将不能再查\n看宝贝信息,确定要解绑吗?"
            }
            vc.delegate = self
        }
        else if segue.identifier == "Contacts"{
            let vc:ContactsTableViewController = segue.destinationViewController as! ContactsTableViewController
            vc.type = 1;
        }
    }


}
