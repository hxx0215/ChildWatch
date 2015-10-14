//
//  BabyDataTableViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/14.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class BabyDataTableViewController: UITableViewController {

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
    var first: Bool = true
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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if first{
            first = false
            let dic = ["deviceno":DeviceManager.sharedManager().curentDevice.dicBase["deviceno"] as! String]
            DeviceRequest .GetDeviceInfoWithParameters(NSDictionary(dictionary: dic), success: { (AnyObject object) -> Void in
        
                print(object)
                let dic:NSDictionary = object as! NSDictionary
                let state:Int = dic["state"] as! Int
                if(state==0)
                {
                    dic["state"].firstObject
                }
                
                }) { (NSError error) -> Void in
                    print(error)
                    let hud = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
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
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func unBindClicked(sender: UIButton) {
    }

    @IBAction func headImageClicked(sender: UIButton) {
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
