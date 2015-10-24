//
//  WatchSettingViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/13.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

struct WatchSettingConstant{
    static let workModeSegueIdentifier = "WorkModeSettingSegueIndentifier"
    static let ringSegueIdentifier = "RingSegueIdentifier"
}

class WatchSettingViewController: UITableViewController {

    @IBOutlet weak var mode: UILabel!
    @IBOutlet weak var findWatch: UILabel!
    @IBOutlet weak var poweroff: UILabel!
    @IBOutlet weak var allSwitch: UIButton!
    @IBOutlet weak var friendSwitch: UIButton!
    @IBOutlet weak var strangeSwitch: UIButton!
    @IBOutlet weak var watchVersion: UILabel!
    @IBOutlet weak var watchModel: UILabel!
    @IBOutlet weak var calloff: UILabel!
    @IBOutlet weak var alarm: UILabel!
    @IBOutlet weak var ring: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var bindID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let deviceNo = ChildDeviceManager.sharedManager().currentDeviceNo
        let parameter = ["deviceno":deviceNo]
        DeviceRequest.GetDeviceConfigInfoWithParameters(parameter, success: { (response) -> Void in
            print(response)
            let data = response["data"] as! [AnyObject]
            let first = data.first as! NSDictionary
            self.watchModel.text = first["model"]! as? String
            self.watchVersion.text = first["version"] as? String
            self.poweroff.text = first["poweroff"] as? String
            self.alarm.text = first["alarm"] as? String
            self.allSwitch.selected = ((first["allcalloff"] as? String) == "1")
            self.bindID.text = first["deviceno"] as? String
            self.friendSwitch.selected = ((first["friendoff"] as? String) == "1")
            self.ring.text = first["ring"] as? String
            self.poweroff.text = first["poweroff"] as? String
            self.volume.text = first["volume"] as? String
            self.strangeSwitch.selected = ((first["strangeoff"] as? String) == "1")
            self.calloff.text = first["calloff"] as? String
            self.mode.text = first["mode"] as? String
            }) { (error) -> Void in
                print(error)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func backClicked(sender: UIBarButtonItem) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewControllerAnimated(true)
    }
    func refreshUI(){
        
    }
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

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
        let vc = segue.destinationViewController as! WatchSettingTableViewController
        if segue.identifier == WatchSettingConstant.workModeSegueIdentifier{
            vc.type = .Mode
        }
        if segue.identifier == WatchSettingConstant.ringSegueIdentifier{
            vc.type = .Ring
        }
    }

}
