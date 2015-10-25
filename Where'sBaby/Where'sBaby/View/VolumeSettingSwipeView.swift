//
//  VolumeSettingSwipeView.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/25.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

@objc protocol VolumeSettingSwipeDelegate{
    func volumeChanged(view: VolumeSettingSwipeView,volume: Int)->()
}

class VolumeSettingSwipeView: UIView {

    weak var delegate:VolumeSettingSwipeDelegate?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let current = touch.locationInView(self)
            if let del = delegate{
                var volume = Int(current.x / self.bounds.width * 10)
                volume = max(min(volume, 9),0)
                del.volumeChanged(self, volume: volume)
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let current = touch.locationInView(self)
            if let del = delegate{
                var volume = Int(current.x / self.bounds.width * 10)
                volume = max(min(volume, 9),0)
                del.volumeChanged(self, volume: volume)
            }
        }
    }
}
