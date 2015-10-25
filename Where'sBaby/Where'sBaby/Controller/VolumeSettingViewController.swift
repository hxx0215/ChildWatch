//
//  VolumeSettingViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/25.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

@objc protocol VolumeSettingDelegate{
    func volumeChange(vc: VolumeSettingViewController, volume:Int)
}

class VolumeSettingViewController: UIViewController, VolumeSettingSwipeDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var volumeImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var swipeView: VolumeSettingSwipeView!
    weak var delegate: VolumeSettingDelegate?
    var volume:Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.swipeView.delegate = self
        if let _ = volume{
            
        }else{
            volume = 0
        }
        let imageName = "手表音量\(volume!).png"
        volumeImage.image = UIImage(named: imageName)
        titleLabel.text = "设置手表音量"
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
        if let del = delegate{
            del.volumeChange(self, volume: self.volume!)
        }
        cancelClicked(cancelButton)
    }
    func volumeChanged(view: VolumeSettingSwipeView, volume: Int) {
        let imageName = "手表音量\(volume).png"
        volumeImage.image = UIImage(named: imageName)
        self.volume = volume
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
