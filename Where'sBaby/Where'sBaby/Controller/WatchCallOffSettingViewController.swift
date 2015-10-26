//
//  WatchCallOffSettingViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/25.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

struct WatchCallOffItem{
    var beginTime: String
    var endTime: String?
    var week: [Bool]
    var open = -1
    init(itemString: String, haveEndTime: Bool){
        beginTime = "06:00"
        if haveEndTime{
            endTime = "18:00"
        }else{
            endTime = nil
        }
        week = [false,false,false,false,false,false,false]
        let arr = itemString.characters.split{ $0 == ","}.map(String.init)
        if arr.count > 0{
            let time = arr[0].characters.split{ $0 == "-"}.map(String.init)
            beginTime = time[0]
            if time.count > 1{
                endTime = time[1]
            }else{
                endTime = nil
            }
            if arr.count > 1{
                let weekday = arr[1].characters.split{ $0 == "-"}.map(String.init)
                weekday.forEach({ (index) -> () in
                    if let i = Int(index){
                        week[i - 1] = true
                    }
                })
                if arr.count > 2{
                    if time[2] == "0"{
                        open = 0
                    }else if time[2] == "1"{
                        open = 1
                    }
                }
            }
        }
    }
    func itemStr()->String{
        var end = ""
        if let _ = endTime{
            end = "-" + endTime!
        }
        let time = beginTime + end
        var week = ""
        for i in 0..<7{
            if self.week[i]{
                week += "\(i + 1)-"
            }
        }
        var retWeek = String(week.characters.dropLast())
        if retWeek != ""{
            retWeek = "," + retWeek
        }
        var openStr = ""
        if open >= 0{
            openStr = ",\(open)"
        }
        return time + retWeek + openStr
    }
}

struct WatchCallOffConstant{
    static let cellIdentifier = "WatchCallOffIdentifier"
    static let CallOffTimeSettingSegueIdentifier = "CallOffTimeSettingSegueIdentifier"
}

enum WatchCallOffType: Int{
    case CallOff
    case Alarm
}

class WatchCallOffSettingViewModel: NSObject{
    var dataSource: [WatchCallOffItem]
    var type: WatchCallOffType
    init(calloff :String,type: WatchCallOffType){
        self.type = type
        dataSource = []
        let itemArr = calloff.characters.split{ $0 == "|"}.map(String.init)
        dataSource = itemArr.map { (itemString) -> WatchCallOffItem in
            return WatchCallOffItem(itemString: itemString,haveEndTime: type != .Alarm)
        }
    }
    
    func calloffString()->String{
        let a = dataSource.reduce("") { (str, item) -> String in
            if str == ""{
                return item.itemStr()
            }
            return str + "|" + item.itemStr()
        }
        return a
    }
    
    func state(index: Int)->Bool{
        let data = dataSource[index]
        return (data.open == 0)
    }
    func timeLabel(index: Int)->String{
        let data = dataSource[index]
        if let e = data.endTime{
            return "\(data.beginTime)-\(e)"
        }else{
            return data.beginTime
        }
    }
    
    func weekLabel(index: Int)->String{
        let weekMap = ["周一","周二","周三","周四","周五","周六","周日"]
        let data = dataSource[index].week
        var ret = ""
        for i in 0..<data.count{
            if data[i]{
                ret += weekMap[i]+","
            }
        }
        if ret != ""{
            let ans = String(ret.characters.dropLast())
            return ans
        }else{
            return "不重复"
        }
    }
}

@objc protocol WatchCallOffSettingDelegate{
    func callOffChange(type: Int,calloffString: String)
}

class WatchCallOffSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,PowerSettingDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableContainer: UIView!
    var viewModel: WatchCallOffSettingViewModel?
    var calloffString: String?
    var delegate: WatchCallOffSettingDelegate?
    var type: WatchCallOffType?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let str = calloffString{
            viewModel = WatchCallOffSettingViewModel(calloff: str, type: type!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableContainer.hidden = viewModel?.dataSource.count == 0
        if !tableContainer.hidden{
            tableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.dataSource.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WatchCallOffConstant.cellIdentifier) as! WatchCallOffSettingTableViewCell
        cell.timeLabel.text = viewModel?.timeLabel(indexPath.row)
        cell.weekLabel.text = viewModel?.weekLabel(indexPath.row)
        cell.stateButton.selected = (viewModel?.state(indexPath.row))!
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            viewModel?.dataSource.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        tableContainer.hidden = viewModel?.dataSource.count == 0
    }
    
    @IBAction func editClicked(sender: UIBarButtonItem) {
        if tableView.editing{
            tableView.setEditing(false, animated: true)
        }else{
            tableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func addCallOffTime(sender: UIButton) {
        self.performSegueWithIdentifier(WatchCallOffConstant.CallOffTimeSettingSegueIdentifier, sender: nil)
    }
    
    @IBAction func backClicked(sender: UIButton) {
        if let del = delegate{
            let str = viewModel?.calloffString()
            del.callOffChange((self.type?.rawValue)!, calloffString: str!)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    func powerSettingChange(type: Int, itemString: String) {
        let item = WatchCallOffItem(itemString: itemString,haveEndTime: self.type != .Alarm)
        viewModel?.dataSource.append(item)
        tableView.reloadData()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == WatchCallOffConstant.CallOffTimeSettingSegueIdentifier{
            let vc = segue.destinationViewController as! PowerSettingTableViewController
            switch type!{
            case .CallOff:
                vc.type = .Calloff
            case .Alarm:
                vc.type = .Alarm
            }
            vc.itemString = sender as? String
            vc.delegate = self
            vc.title = "禁用时段"
        }
    }

}
