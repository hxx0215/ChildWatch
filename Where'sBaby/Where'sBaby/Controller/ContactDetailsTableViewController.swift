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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.nicknameLabel.text = self.currentDic["nickname"] as? String
        self.mobileshortLabel.text = self.currentDic["mobileshort"] as? String
        let sosflag:Int = self.currentDic["sosflag"] as! Int
        let autoanswer:Int = self.currentDic["autoanswer"] as! Int
        if sosflag == 1{
            self.sosflagButton.selected = true
        }
        if autoanswer == 1{
            self.autoanswerButton.selected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
