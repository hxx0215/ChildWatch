//
//  ContactDetailsTableViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/17.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class ContactDetailsTableViewController: UITableViewController {

    @IBOutlet weak var nicknameLabel : UILabel!
    @IBOutlet weak var mobileshortLabel : UILabel!
    @IBOutlet weak var sosflagButton : UIButton!
    @IBOutlet weak var autoanswerButton : UIButton!
    var currentDic : NSMutableDictionary!
    var observer: NSObjectProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.nicknameLabel.text = self.currentDic["nickname"] as? String
        self.title = self.nicknameLabel.text
        self.mobileshortLabel.text = self.currentDic["mobileshort"] as? String
        let sosflag:Int = self.currentDic["sosflag"] as! Int
        let autoanswer:Int = self.currentDic["autoanswer"] as! Int
        if sosflag == 1{
            self.sosflagButton.selected = true
        }
        if autoanswer == 1{
            self.autoanswerButton.selected = true
        }
        
        observer = NSNotificationCenter.defaultCenter().addObserverForName("updateMobileshort", object: nil, queue: NSOperationQueue.mainQueue()) { (NSNotification) -> Void in
            self.mobileshortLabel.text = self.currentDic["mobileshort"] as? String
            self.nicknameLabel.text = self.currentDic["nickname"] as? String
            self.title = self.nicknameLabel.text
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backClicked(sender: UIButton) {
        NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deleteClicked(sender: AnyObject?) {
        let ac:UIAlertController = UIAlertController(title: "", message: "确定要删除该联系人吗？", preferredStyle: UIAlertControllerStyle.Alert)
        let a:UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            
        }
        let b:UIAlertAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            DeviceRequest.DeletePhoneBookWithParameters(self.currentDic, success: { (object) -> Void in
                print(object)
                let dic:NSDictionary = object as! NSDictionary
                let state:Int = dic["state"] as! Int
                if(state==0){
                    hud.detailsLabelText = "删除成功"
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else if(state == 1)
                {
                    hud.detailsLabelText = "数据库异常"
                }
                else
                {
                    hud.detailsLabelText = "删除失败"
                }
                hud.mode = .Text
                hud.hide(true, afterDelay: 1.5)
                
                }) { (NSError error) -> Void in
                    hud.mode = .Text
                    hud.detailsLabelText = error.domain
                    hud.hide(true, afterDelay: 1.5)
            }
        }
        ac.addAction(a)
        ac.addAction(b)
        self.presentViewController(ac, animated: true) { () -> Void in
        }
    }
    
    @IBAction func sosflagButtonClicked(sender: UIButton) {
        var sos:Int = 0
        if !self.sosflagButton.selected{
            sos = 1
        }
        self.currentDic.setObject(sos, forKey: "sosflag")
        let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        DeviceRequest.UpdatePhoneBookWithParameters(self.currentDic, success: { (object) -> Void in
            print(object)
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            if(state==0){
                hud.hide(true)
                self.sosflagButton.selected = !self.sosflagButton.selected
                return
            }
            else if(state == 1)
            {
                hud.detailsLabelText = "手机号码已经在通讯录中"
            }
            else
            {
                hud.detailsLabelText = "修改失败"
            }
            hud.mode = .Text
            hud.hide(true, afterDelay: 1.5)
            
            }) { (NSError error) -> Void in
                hud.mode = .Text
                hud.detailsLabelText = error.domain
                hud.hide(true, afterDelay: 1.5)
        }
    }
    
    @IBAction func autoanswerButtonClicked(sender: UIButton) {
        
        var autoanswer:Int = 0
        if !self.autoanswerButton.selected{
            autoanswer = 1
        }
        self.currentDic.setObject(autoanswer, forKey: "autoanswer")
        let hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        DeviceRequest.UpdatePhoneBookWithParameters(self.currentDic, success: { (object) -> Void in
            print(object)
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            if(state==0){
                hud.hide(true)
                self.autoanswerButton.selected = !self.autoanswerButton.selected
                return
            }
            else if(state == 1)
            {
                hud.detailsLabelText = "手机号码已经在通讯录中"
            }
            else
            {
                hud.detailsLabelText = "修改失败"
            }
            hud.mode = .Text
            hud.hide(true, afterDelay: 1.5)
            
            }) { (NSError error) -> Void in
                hud.mode = .Text
                hud.detailsLabelText = error.domain
                hud.hide(true, afterDelay: 1.5)
        }
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0{
            self.performSegueWithIdentifier("relation", sender: nil)
        }
        else if indexPath.row == 1{
            self.performSegueWithIdentifier("phoneShort", sender: nil)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "phoneShort"{
            let vc:BabyPhoneShortViewController = segue.destinationViewController as! BabyPhoneShortViewController
            vc.currentDic = self.currentDic
        }
        else if segue.identifier == "relation"{
            let vc:RelationViewController = segue.destinationViewController as! RelationViewController
            vc.currentDic = self.currentDic
        }
    }


}
