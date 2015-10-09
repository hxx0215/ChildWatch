//
//  WBWelcomeViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/9/12.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

struct LoginSegueIdentifer{
    static let login = "LoginRegisterSegueIdentifier"
    static let username = "id"
}
class WBWelcomeViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (NSUserDefaults.standardUserDefaults().objectForKey(LoginSegueIdentifer.username) != nil){
            self.dismissViewControllerAnimated(true){
                
            }
        }
    }
    
    @IBAction func LoginClicked(sender: UIButton) {
        self.performSegueWithIdentifier(LoginSegueIdentifer.login, sender: LoginType.Login.rawValue)
    }

    @IBAction func registerClicked(sender: UIButton) {
        self.performSegueWithIdentifier(LoginSegueIdentifer.login, sender: LoginType.Register.rawValue)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destinationViewController as! LoginViewController
        vc.loginType = LoginType(rawValue: sender as! String)!
    }

}
