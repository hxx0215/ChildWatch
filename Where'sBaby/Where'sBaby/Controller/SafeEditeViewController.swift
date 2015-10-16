//
//  SafeEditeViewController.swift
//  Where'sBaby
//
//  Created by 刘向宏 on 15/10/15.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class SafeEditeViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var constraintLabel: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var schollButton: UIButton!
    @IBOutlet weak var inAlarmButton: UIButton!
    @IBOutlet weak var outAlarmButton: UIButton!
    @IBOutlet weak var inAndOutAlarmButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var mapBackView : UIView!
    @IBOutlet weak var valueBackView : UIView!
    var value : Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        homeButton.layer.cornerRadius = 15;
        homeButton.layer.masksToBounds = true;
        
        schollButton.layer.cornerRadius = 15;
        schollButton.layer.masksToBounds = true;
        
        valueLabel.layer.cornerRadius = 11;
        valueLabel.layer.masksToBounds = true;
        
        self.updateValueLabelConstraint()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateValueLabelConstraint()
    }

    @IBAction func backButtonClick(sender : AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func saveButtonClick(sender : AnyObject){
    }
    @IBAction func inAlarmButtonClick(sender : AnyObject){
        self.inAlarmButton.selected = true
        self.outAlarmButton.selected = false
        self.inAndOutAlarmButton.selected = false
    }
    @IBAction func outAlarmButtonClick(sender : AnyObject){
        self.inAlarmButton.selected = false
        self.outAlarmButton.selected = true
        self.inAndOutAlarmButton.selected = false
    }
    @IBAction func inAndOutAlarmButtonClick(sender : AnyObject){
        self.inAlarmButton.selected = false
        self.outAlarmButton.selected = false
        self.inAndOutAlarmButton.selected = true
    }
    @IBAction func homeButtonClick(sender : AnyObject){
        self.nameTextField.text = "家"
    }
    @IBAction func schollButtonClick(sender : AnyObject){
        self.nameTextField.text = "学校"
    }
    @IBAction func addButtonClick(sender : AnyObject){
        if value == 7{
            return
        }
        value++
        self.updateValueLabelConstraint()
    }
    @IBAction func lowerButtonClick(sender : AnyObject){
        if value == 1{
            return
        }
        value--
        self.updateValueLabelConstraint()
    }
    
    func updateValueLabelConstraint(){
        constraintLabel.constant = self.valueBackView.frame.size.width/8 * (CGFloat.init(value))
        var m:String = "500米"
        switch value{
        case 1:
            m = "500米"
        case 2:
            m = "1千米"
        case 3:
            m = "1.5千米"
        case 4:
            m = "2千米"
        case 5:
            m = "3千米"
        case 6:
            m = "4千米"
        case 7:
            m = "5千米"
        default:
            m = "500米"
        }
        self.valueLabel.text = "  \(m)  "
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
