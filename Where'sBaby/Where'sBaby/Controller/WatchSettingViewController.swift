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
    static let powerOffSegueIdentifier = "PowerOffSegueIdentifier"
    static let alarmSegueIdentifier = "AlarmSegueIdentifier"
    static let findWatchSegueIdentifier = "FindWatchSegueIdentifier"
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
    func modeText()->String{
        let map = ["关闭定位","每1分钟定位一次","每10分钟定位一次","单次定位"]
        if let index = data!["mode"].string,
            let i = Int(index){
            return map[i]
        }else{
            return map[0]
        }
    }
    
    func ringText()->String{
        let map = ["HelloBaby","Yesterday","You are so beatuiful"]
        if let index = Int(data!["ring"].stringValue){
            return map[index]
        }else{
            return map[0]
        }
    }
    
    func powerText()->String{
        return data!["poweroff"].stringValue
    }
}

class WatchSettingViewController: UITableViewController ,VolumeSettingDelegate,WatchSettingTableDelegate,PowerSettingDelegate,WatchCallOffSettingDelegate,FindWatchDelegate{

    @IBOutlet weak var qrcodeImage: UIImageView!
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
    var shouldBack = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let deviceNo = ChildDeviceManager.sharedManager().currentDeviceNo
        let parameter = ["deviceno":deviceNo]
        self.qrcodeImage.image = QRCodeGenerate.generateQRCode(deviceNo, size: 80.0)
        DeviceRequest.GetDeviceConfigInfoWithParameters(parameter, success: { (response) -> Void in
            let json = JSON(response)
            self.viewModel = WatchSettingViewModel(json: json)
            guard let vm = self.viewModel else{
                self.shouldBack = true
                return
            }
            guard let data = vm.data else{
                self.shouldBack = true
                return
            }
            self.watchModel.text = data["model"].stringValue
            self.watchVersion.text = data["version"].stringValue
            self.poweroff.text = data["poweroff"].stringValue
            self.alarm.text = ""//data["alarm"].stringValue
            self.allSwitch.selected = (data["allcalloff"].stringValue == "1")
            self.bindID.text = data["deviceno"].stringValue
            self.friendSwitch.selected = ((data["friendoff"].stringValue) == "1")
            self.ring.text = vm.ringText()//data["ring"].stringValue
            self.poweroff.text = data["poweroff"].stringValue
            self.volume.text = data["volume"].stringValue == "" ? "0" : data["volume"].stringValue
            self.strangeSwitch.selected = ((data["strangeoff"].stringValue) == "1")
            self.calloff.text = ""//data["calloff"].stringValue
            self.mode.text = vm.modeText()//data["mode"].stringValue
            }) { (error) -> Void in
                print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if shouldBack{
            self.backClicked(UIButton())
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func updateConfig(){
        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
        DeviceRequest.UpdateDeviceConfigInfoWithParameters(viewModel?.data?.object, success: { (response) -> Void in
            hud.mode = .Text
            let json = JSON(response)
            if json["state"].stringValue == "0"{
                hud.labelText = "修改成功"
            }else{
                hud.labelText = "修改失败,服务器内部错误"
            }
            hud.hide(true, afterDelay: 0.3)
            }) { (error) -> Void in
                print(error)
        }
    }
    
    @IBAction func strangeChange(sender: UIButton) {
        sender.selected = !sender.selected
        viewModel?.data!["strangeoff"].stringValue = sender.selected ? "1" : "0"
        updateConfig()
    }
    @IBAction func friendChange(sender: UIButton) {
        sender.selected = !sender.selected
        viewModel?.data!["friendoff"].stringValue = sender.selected ? "1" : "0"
        updateConfig()
    }
    @IBAction func allChange(sender: UIButton) {
        sender.selected = !sender.selected
        viewModel?.data!["allcalloff"].stringValue = sender.selected ? "1" : "0"
        updateConfig()
    }
    
    
    func volumeChange(vc: VolumeSettingViewController, volume: Int) {
        viewModel?.data!["volume"].string = "\(volume)"
        self.volume.text = "\(volume)"
        updateConfig()
    }
    
    func watchSettingChange(type: Int, index: Int, content: String) {
        switch type{
        case WatchSettingTableType.Mode.rawValue:
            viewModel?.data!["mode"].string = "\(index)"
            mode.text = viewModel?.modeText()
        case WatchSettingTableType.Ring.rawValue:
            viewModel?.data!["ring"].string = "\(index)"
            ring.text = viewModel?.ringText()
        default:
            break
        }
        updateConfig()
    }
    
    func powerSettingChange(type: Int, itemString: String) {
        switch type{
        case PowerSettingType.Power.rawValue:
            viewModel?.data!["poweroff"].string = itemString
            poweroff.text = viewModel?.powerText()
        default:
            break
        }
        updateConfig()
    }
    
    
    func callOffChange(type: Int, calloffString: String) {
        switch type{
        case WatchCallOffType.CallOff.rawValue:
            viewModel?.data!["calloff"].stringValue = calloffString
        case WatchCallOffType.Alarm.rawValue:
            viewModel?.data!["alarm"].stringValue = calloffString
        default:
            break
        }
        updateConfig()
    }
    
    func ringBell() {
        let deviceNo = ChildDeviceManager.sharedManager().currentDeviceNo
        let parameter = ["deviceno":deviceNo]
        DeviceRequest.FindDeviceWithParameters(parameter, success: { (response) -> Void in
            print(response)
            let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
            hud.mode = .Text
            hud.labelText = "响铃成功"
            hud.hide(true, afterDelay: 0.7)
            }) { (error) -> Void in
                print(error)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
            vc.settingDelegate = self
            if let index = Int((viewModel?.data!["mode"].stringValue)!){
                vc.selected = index
            }else{
                vc.selected = 0
            }
        }
        if segue.identifier == WatchSettingConstant.ringSegueIdentifier{
            let vc = segue.destinationViewController as! WatchSettingTableViewController
            vc.type = .Ring
            vc.settingDelegate = self
            if let index = Int((viewModel?.data!["ring"].stringValue)!){
                vc.selected = index
            }else{
                vc.selected = 0
            }
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
            vc.calloffString = viewModel?.data!["calloff"].stringValue
            vc.type = .CallOff
            vc.delegate = self
        }
        if segue.identifier == WatchSettingConstant.alarmSegueIdentifier{
            guard let vm = self.viewModel else{
                self.backClicked(UIButton())
                return
            }
            guard let _ = vm.data else{
                self.backClicked(UIButton())
                return
            }
            let vc = segue.destinationViewController as! WatchCallOffSettingViewController
            vc.calloffString = viewModel?.data!["alarm"].stringValue
            vc.type = .Alarm
            vc.delegate = self
            vc.title = "闹钟"
        }
        if segue.identifier == WatchSettingConstant.volumeSettingSegueIdentifier{
            let vc = segue.destinationViewController as! VolumeSettingViewController
            if let volume = viewModel?.data!["volume"].stringValue{
                vc.volume = Int(volume)
                vc.delegate = self
            }
        }
        if segue.identifier == WatchSettingConstant.powerOffSegueIdentifier{
            let vc = segue.destinationViewController as! PowerSettingTableViewController
            vc.type = .Power
            vc.itemString = viewModel?.data!["poweroff"].stringValue
            vc.delegate = self
        }
        if segue.identifier == WatchSettingConstant.findWatchSegueIdentifier{
            let vc = segue.destinationViewController as! FindWatchViewController
            vc.delegate = self
        }
    }

}
