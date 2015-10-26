//
//  FindWatchViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/25.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit
@objc protocol FindWatchDelegate{
    func ringBell()
}
class FindWatchViewController: UIViewController {

    @IBOutlet weak var ringButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    weak var delegate: FindWatchDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ringButton.layer.cornerRadius = 15
        ringButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 15
        cancelButton.clipsToBounds = true
    }

    @IBAction func cancelClicked(sender: UIButton) {
        dismissViewControllerAnimated(false) { () -> Void in
            
        }
    }
    @IBAction func ringBellClicked(sender: UIButton) {
        if let del = delegate{
            del.ringBell()
        }
        cancelClicked(cancelButton)
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
