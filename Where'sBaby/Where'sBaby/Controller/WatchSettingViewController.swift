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
    static let watchCallOffSegueIdentifier = "WatchCallOffSegueIdentifier"
    static let volumeSettingSegueIdentifier = "VolumeSettingSegueIdentifier"
}

class WatchSettingViewModel: NSObject{
    var json:JSON
    var data:JSON?
    init(json:JSON){
        self.json = json
        if let data = json["data"].array,
            let arr = data.first {
                self.data = arr
        }
    }
}

class WatchSettingViewController: UITableViewController ,VolumeSettingDelegate{

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
    var viewModel: WatchSettingViewModel?
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
            let json = JSON(response)
            self.viewModel = WatchSettingViewModel(json: json)
            guard let vm = self.viewModel else{
                self.backClicked(UIButton())
                return
            }
            guard let data = vm.data else{
                self.backClicked(UIButton())
                return
            }
            self.watchModel.text = data["model"].stringValue
            self.watchVersion.text = data["version"].stringValue
            self.poweroff.text = data["poweroff"].stringValue
            self.alarm.text = data["alarm"].stringValue
            self.allSwitch.selected = (data["allcalloff"].stringValue == "1")
            self.bindID.text = data["deviceno"].stringValue
            self.friendSwitch.selected = ((data["friendoff"].stringValue) == "1")
            self.ring.text = data["ring"].stringValue
            self.poweroff.text = data["poweroff"].stringValue
            self.volume.text = data["volume"].stringValue
            self.strangeSwitch.selected = ((data["strangeoff"].stringValue) == "1")
            self.calloff.text = data["calloff"].stringValue
            self.mode.text = data["mode"].stringValue
            }) { (error) -> Void in
                print(error)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func refreshUI(){
        
    }
    
    func volumeChange(vc: VolumeSettingViewController, volume: Int) {
        viewModel?.data!["volume"].string = "\(volume)"
        self.volume.text = "\(volume)"
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
        if segue.identifier == WatchSettingConstant.workModeSegueIdentifier{
            let vc = segue.destinationViewController as! WatchSettingTableViewController
            vc.type = .Mode
        }
        if segue.identifier == WatchSettingConstant.ringSegueIdentifier{
            let vc = segue.destinationViewController as! WatchSettingTableViewController
            vc.type = .Ring
        }
        if segue.identifier == WatchSettingConstant.watchCallOffSegueIdentifier{
            guard let vm = self.viewModel else{
                self.backClicked(UIButton())
                return
            }
            guard let _ = vm.data else{
                self.backClicked(UIButton())
                return
            }
            let vc = segue.destinationViewController as! WatchCallOffSettingViewController
//            vc.calloffString = data["calloff"].stringValue
            vc.calloffString = "8:30-12:00,1-2-3-4-5|2:30-5:30,5-6"
        }
        if segue.identifier == WatchSettingConstant.volumeSettingSegueIdentifier{
            let vc = segue.destinationViewController as! VolumeSettingViewController
            if let volume = viewModel?.data!["volume"].stringValue{
                vc.volume = Int(volume)
                vc.delegate = self
            }
        }
    }

}
