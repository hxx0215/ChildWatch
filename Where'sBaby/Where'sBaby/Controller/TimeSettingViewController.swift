//
//  TimeSettingViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/22.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class TimeSettingViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    var titleText: String?
    var textField: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cancelButton.layer.cornerRadius = 15
        cancelButton.clipsToBounds = true
        confirmButton.layer.cornerRadius = 15
        confirmButton.clipsToBounds = true
        
        titleLabel.text = titleText
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let dateString = textField?.text,
            let date = dateFormatter.dateFromString(dateString){
                datePicker.date = date
            }
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
        let date = datePicker.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        textField?.text = dateFormatter.stringFromDate(date)
        self.cancelClicked(cancelButton)
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
