//
//  Message.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/14.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    @objc var fromId: String?
    @objc var toId: String?
    @objc var text: String?
    @objc var timeStamp: NSNumber?
    @objc var profileImageUrl: String?
    @objc var imageUrl: String?
    
    @objc var imageWidth: NSNumber?
    @objc var imageHeight: NSNumber?
    
    @objc var videoWidth: NSNumber?
    @objc var videoHeight: NSNumber?
    
    @objc var userId: String!
    @objc var userName: String!
    @objc var userProfileImage: String!
    @objc var videoImage: String!
    @objc var videoCaption: String!
    @objc var videoUrl: String!
    @objc var videoKey: String!
    
    func checkPartnerId() -> String? {
        
        var chatPartnerId: String?
        
        if fromId == Auth.auth().currentUser?.uid {
            
            chatPartnerId = toId
            
        }else {
            
            chatPartnerId = fromId
            
        }
        
        return chatPartnerId
        
    }

    
    init(dictionary: [String: AnyObject]){
        
        super.init()
        
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        text = dictionary["text"] as? String
        timeStamp = dictionary["timeStamp"] as? NSNumber
        profileImageUrl = dictionary["profileImageUrl"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
        videoUrl = dictionary["videoUrl"] as? String
        userId = dictionary["userId"] as? String
        videoImage = dictionary["videoImage"] as? String
        videoCaption = dictionary["videoCaption"] as? String
        userProfileImage = dictionary["userProfileImage"] as? String
        userName = dictionary["userName"] as? String
        videoWidth = dictionary["videoWidth"] as? NSNumber
        videoHeight = dictionary["videoHeight"] as? NSNumber
        videoKey = dictionary["videoKey"] as? String
    }
}
