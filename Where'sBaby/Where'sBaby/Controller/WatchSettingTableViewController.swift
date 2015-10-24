//
//  WatchSettingTableViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/24.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit
enum WatchSettingTableType: Int{
    case Mode
    case Ring
}

struct WatchSettingIdentifier{
    static let cellIdentifier = "WatchSettingTableViewCellIdentifier"
}

class WatchSettingTableViewModel: NSObject{
    
    let type : WatchSettingTableType
    let title : String
    let dataSource : [String]
    var selected = 0
    init(type: WatchSettingTableType, selected: Int){
        self.type = type
        self.selected = selected
        switch type {
        case .Mode:
            self.dataSource = ["关闭定位","每1分钟定位一次","每10分钟定位一次","单次定位"]
            self.title = "手表工作模式设置"
        case .Ring:
            self.dataSource = ["HelloBaby","Yesterday","You are so beatuiful"]
            self.title = "手表铃音设置"
        }
    }
}

class WatchSettingTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var viewModel: WatchSettingTableViewModel!
    var type: WatchSettingTableType = .Mode
    var selected = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = WatchSettingTableViewModel(type: type,selected: selected)
        tableHeightConstraint.constant = CGFloat(viewModel.dataSource.count * 44)
        titleLabel.text = viewModel.title
        
        cancelButton.layer.cornerRadius = 15
        cancelButton.clipsToBounds = true
        confirmButton.layer.cornerRadius = 15
        confirmButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(false) { () -> Void in
            
        }
    }

    @IBAction func confirmClicked(sender: UIButton) {
        
        cancelClicked(cancelButton)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WatchSettingIdentifier.cellIdentifier) as! WatchSettingTableViewCell
        cell.contentLabel.text = viewModel.dataSource[indexPath.row]
        cell.selectedButton.selected = (indexPath.row == viewModel.selected)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        viewModel.selected = indexPath.row
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
