//
//  ChatViewController.swift
//  Where'sBaby
//
//  Created by shadowPriest on 15/10/31.
//  Copyright © 2015年 coolLH. All rights reserved.
//

import UIKit

class ChatViewModel: NSObject{
    var messages: [JSQMessage]?
    var avatars: [String: JSQMessagesAvatarImage]?
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    var users: [String: String]?
    let displayNameMap = ["爸爸" : "头像1.png", "妈妈" : "头像2.png" , "爷爷" : "头像3.png" , "奶奶" : "头像4.png" , "姑姑" : "头像5.png", "叔叔" : "头像6.png"]
    init(senderId: String!,displayName: String!,displayAvatar : UIImage?){
        messages = []
        var avatarImage: JSQMessagesAvatarImage!
        if let image = displayAvatar{
            avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: 30)
        }else{
            avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: displayNameMap[displayName]!), diameter: 30)
        }
        avatars = [senderId : avatarImage]
    }
}

class ChatViewController: JSQMessagesViewController {
    
    var currentAvatar: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    

    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewControllerAnimated(true)
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
