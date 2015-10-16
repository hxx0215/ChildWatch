//
//  ContactsTableViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/16.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    var tableViewFamilyArray : NSMutableArray!
    var tableViewFrinedArray : NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableViewFamilyArray = NSMutableArray.init(array: [])
        self.tableViewFrinedArray = NSMutableArray.init(array: [])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let dic = ["deviceno":ChildDeviceManager.sharedManager().currentDeviceNo]
        DeviceRequest.GetPhoneBookListWithParameters(dic, success: { (object) -> Void in
            print(object)
            let dic:NSDictionary = object as! NSDictionary
            let state:Int = dic["state"] as! Int
            if(state==0)
            {
                self.tableViewFamilyArray.removeAllObjects()
                self.tableViewFrinedArray.removeAllObjects()
                let dicArray:NSArray = dic["data"] as! NSArray
                for dicDatat in dicArray{
                    let role:String = dicDatat["role"] as! String
                    if role == "friend"{
                        self.tableViewFrinedArray.addObject(dicDatat)
                    }
                    else
                    {
                        self.tableViewFamilyArray.addObject(dicDatat)
                        //self.tableViewFamilyArray.insertObject(dicDatat, atIndex: 0)
                    }
                }
                self.tableView.reloadData()
            }
            hud.hide(true)
            }) { (NSError error) -> Void in
                print(error)
                hud.mode = .Text
                hud.detailsLabelText = error.domain
                hud.hide(true, afterDelay: 1.5)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    @IBAction func addClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return tableViewFamilyArray.count
        }
        else{
            return tableViewFrinedArray.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if tableViewArray.count == 0{
//            return self.view.frame.size.width/2
//        }
//        return 74
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView();
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let label:UILabel = UILabel.init()
        let label2:UILabel = UILabel.init()
        if section==0{
            label.text = "家人"
            label2.text = "(注：家人有查看宝贝资料和控制手表的权限)"
        }
        else{
            label.text = "朋友"
            label2.text = "(注：朋友只能拨打和接听手表的电话)"
        }
        label.sizeToFit()
        label2.sizeToFit()
        label.frame.origin.x = 15;
        label2.frame.origin.x = label.frame.origin.x + label.frame.width + 1;
        label.center.y = view.center.y
        label2.center.y = view.center.y
        label.font = UIFont.systemFontOfSize(13)
        label2.font = UIFont.systemFontOfSize(13)
        label2.textColor = UIColor.darkGrayColor()
        view.addSubview(label)
        view.addSubview(label2)
        return view
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ContactsTableViewCell = tableView.dequeueReusableCellWithIdentifier("contactsIdentifier", forIndexPath: indexPath) as! ContactsTableViewCell

        // Configure the cell...

        var dic:NSDictionary;
        if(indexPath.section == 0)
        {
            dic = tableViewFamilyArray[indexPath.row] as! NSDictionary
        }
        else
        {
            dic = tableViewFrinedArray[indexPath.row] as! NSDictionary
        }
        let nickname:String = dic["nickname"] as! String
        let mobile:String = dic["mobile"] as! String
        var mobileshort:String = dic["mobileshort"] as! String
        if mobileshort.isEmpty{
            mobileshort = "未设置"
        }
        cell.mobelLabel.text = "\(nickname)  \(mobile)"
        cell.shortLabel.text = "\(mobileshort)"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

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
