//
//  Video.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/19.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    @objc var videoUrl: String?
    @objc var videoImageUrl: String?
    @objc var userId: String?
    @objc var caption: String?
    @objc var videoLikes: NSNumber?
    @objc var views: [NSNumber]?
    @objc var shares: [NSNumber]?
    @objc var videoId: String?
    @objc var timeStamp: NSNumber?
    @objc var videoImageWidth: NSNumber?
    @objc var videoImageHeight: NSNumber?
    @objc var comments: [NSNumber]?
    @objc var likes: [NSNumber]?
    @objc var blockedFromViewing: NSNumber?

}
