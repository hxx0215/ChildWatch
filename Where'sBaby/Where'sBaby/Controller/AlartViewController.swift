//
//  AlartViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/26.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

protocol AlartViewControllerDelegate{
    func didClickButton(index:Int, tag:Int)
}

class AlartViewController: UIViewController {

    @IBOutlet weak var ringButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    var text:String! = ""
    var tag:Int = 0
    var delegate : AlartViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ringButton.layer.cornerRadius = 15
        ringButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 15
        cancelButton.clipsToBounds = true
        self.textLabel.text = self.text
    }
    
    @IBAction func cancelClicked(sender: UIButton) {
        dismissViewControllerAnimated(false) { () -> Void in
            self.delegate?.didClickButton(0, tag: self.tag)
        }
    }
    @IBAction func ringBellClicked(sender: UIButton) {
        dismissViewControllerAnimated(false) { () -> Void in
            self.delegate?.didClickButton(1, tag: self.tag)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
