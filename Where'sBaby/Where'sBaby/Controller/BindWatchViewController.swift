//
//  BindWatchViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/16.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class BindWatchViewController: UIViewController {

    @IBOutlet weak var inputButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var bindView: UIView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var inputIDView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bindView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8)
        IHKeyboardAvoiding.setAvoidingView(self.bindView)
        self.inputButton.selected = true
        self.scanButton.selected = false
        refreshInputView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inputClicked(sender: UIButton) {
        sender.selected = true
        scanButton.selected = false
        refreshInputView()
    }
    @IBAction func scanClicked(sender: UIButton) {
        sender.selected = true
        inputButton.selected = false
        inputTextField.resignFirstResponder()
        refreshInputView()
    }

    func refreshInputView(){
        inputIDView.hidden = !inputButton.selected
        scanView.hidden = !scanButton.selected
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
