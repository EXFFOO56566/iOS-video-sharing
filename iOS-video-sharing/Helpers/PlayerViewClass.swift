//
//  PlayerViewClass.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/23.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewClass: UIImageView {
    
    override class var layerClass: AnyClass {
        
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        
        return layer as! AVPlayerLayer
        
    }
    
    var player: AVPlayer? {
        
        get {
            
            return playerLayer.player
        }
        
        set {
            
            playerLayer.player = newValue
        }
    }
}

