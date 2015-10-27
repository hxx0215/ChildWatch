//
//  PowerSettingTableViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/21.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

enum PowerSettingType: Int{
    case Power
    case Calloff
    case Alarm
}

@objc protocol PowerSettingDelegate{
    func powerSettingChange(type: Int,itemString: String)
}

class PowerSettingViewModel: NSObject{
    let type: PowerSettingType
    var item: WatchCallOffItem
    init(type: PowerSettingType,itemString: String){
        self.type = type
        self.item = WatchCallOffItem(itemString: itemString,haveEndTime: type != .Alarm)
    }
    func tableCount()->Int{
        if type == .Power{
            return 0
        }else{
            return 7
        }
    }
}

class PowerSettingTableViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var powerOnLabel: UILabel!
    @IBOutlet weak var powerOffLabel: UILabel!
    @IBOutlet weak var powerOffTime: UITextField!
    @IBOutlet weak var powerOnTime: UITextField!
    @IBOutlet var selectedButton: [UIButton]!
    weak var delegate: PowerSettingDelegate?
    var viewModel: PowerSettingViewModel?
    var type: PowerSettingType?
    var itemString: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if let type = self.type{
            if let itemString = self.itemString{
                viewModel = PowerSettingViewModel(type: type,itemString: itemString)
            }else{
                viewModel = PowerSettingViewModel(type: type, itemString: "")
            }
            switch type{
            case .Alarm:
                powerOffTime.hidden = true
                powerOffLabel.hidden = true
                powerOnLabel.text = "闹铃时间"
            case .Calloff:
                powerOffTime.hidden = false
                powerOffLabel.hidden = false
                powerOnLabel.text = "开始时间"
                powerOffLabel.text = "结束时间"
            default:
                powerOffTime.hidden = false
                powerOffLabel.hidden = false
                powerOnLabel.text = "开机时间"
                powerOffLabel.text = "关机时间"
                break
            }
        }
        self.addObserver(self, forKeyPath: "powerOffTime.text", options: [.New, .Old], context: &powerOffTime)
        self.addObserver(self, forKeyPath: "powerOnTime.text", options: [.New, .Old], context: &powerOnTime)
        if viewModel?.tableCount() > 0{
            selectedButton.forEach({ (btn) -> () in
                btn.selected = (self.viewModel?.item.week[btn.tag - 100])!
            })
        }
        powerOnTime.text = viewModel?.item.beginTime
        powerOffTime.text = viewModel?.item.endTime
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let ob = object,
            let keyP = keyPath{
                let keyarr = keyP.componentsSeparatedByString(".")//keyP.characters.split{ $0 == "."}.map(String.init)
                let txtField = ob.valueForKey(keyarr[0]) as! UITextField
                let newValue = change?[NSKeyValueChangeNewKey] as! String
                if txtField == powerOnTime{
                    viewModel?.item.beginTime = newValue
                }
                if txtField == powerOffTime{
                    viewModel?.item.endTime = newValue
                }
        }else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.performSegueWithIdentifier("SettingPowerTimeIdentifier", sender: textField)
        return false
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedButton.forEach { (button) -> () in
            if button.tag == 100 + indexPath.row{
                button.selected = !button.selected
                viewModel?.item.week[indexPath.row] = button.selected
            }
        }
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveClicked(sender: UIButton) {
        if let del = delegate{
            del.powerSettingChange((type?.rawValue)!, itemString: (viewModel?.item.itemStr())!)
        }
        cancelClicked(UIButton())
    }
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewM = viewModel{
            return viewM.tableCount()
        }
        else{
            return 0
        }
    }

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
        let vc = segue.destinationViewController as! TimeSettingViewController
        vc.textField = (sender as! UITextField)
        if type == .Power{
            if powerOnTime == (sender as! UITextField){
                vc.titleText = "开机时间"
            }else{
                vc.titleText = "关机时间"
            }
        }else if type == .Calloff{
            if powerOnTime == (sender as! UITextField){
                vc.titleText = "设置开始时间"
            }else{
                vc.titleText = "设置结束时间"
            }
        }
    }

    deinit{
        self.removeObserver(self, forKeyPath: "powerOffTime.text")
        self.removeObserver(self, forKeyPath: "powerOnTime.text")
    }
}
