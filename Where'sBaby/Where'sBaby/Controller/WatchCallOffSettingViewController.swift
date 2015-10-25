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
    var endTime: String
    var week: [Bool]
    init(itemString: String){
        beginTime = "06:00"
        endTime = "18:00"
        week = [false,false,false,false,false,false,false]
        let arr = itemString.characters.split{ $0 == ","}.map(String.init)
        if arr.count > 0{
            let time = arr[0].characters.split{ $0 == "-"}.map(String.init)
            beginTime = time[0]
            endTime = time[1]
            if arr.count > 1{
                let weekday = arr[1].characters.split{ $0 == "-"}.map(String.init)
                weekday.forEach({ (index) -> () in
                    if let i = Int(index){
                        week[i - 1] = true
                    }
                })
            }
        }
    }
}

struct WatchCallOffConstant{
    static let cellIdentifier = "WatchCallOffIdentifier"
    static let CallOffTimeSettingSegueIdentifier = "CallOffTimeSettingSegueIdentifier"
}

class WatchCallOffSettingViewModel: NSObject{
    var dataSource: [WatchCallOffItem]
    
    init(calloff :String){
        dataSource = []
        let itemArr = calloff.characters.split{ $0 == "|"}.map(String.init)
        dataSource = itemArr.map { (itemString) -> WatchCallOffItem in
            return WatchCallOffItem(itemString: itemString)
        }
    }
    
    func timeLabel(index: Int)->String{
        let data = dataSource[index]
        return "\(data.beginTime)-\(data.endTime)"
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

class WatchCallOffSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableContainer: UIView!
    var viewModel: WatchCallOffSettingViewModel?
    var calloffString: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let str = calloffString{
            viewModel = WatchCallOffSettingViewModel(calloff: str)
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
        return cell
    }
    
    
    @IBAction func addCallOffTime(sender: UIButton) {
        self.performSegueWithIdentifier(WatchCallOffConstant.CallOffTimeSettingSegueIdentifier, sender: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == WatchCallOffConstant.CallOffTimeSettingSegueIdentifier{
            let vc = segue.destinationViewController as! PowerSettingTableViewController
            vc.type = .Calloff
            vc.itemString = sender as? String
        }
    }

}
