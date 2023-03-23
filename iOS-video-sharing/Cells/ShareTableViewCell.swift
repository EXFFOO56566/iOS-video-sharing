//
//  ShareTableViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/17.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class ShareTableViewCell: UITableViewCell {
    
    var fullVideoVC: FullVideoViewController?
    var homeVC: HomeViewController?
    
    var videoVC: VideoViewController?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: ((textLabel?.frame.origin.y)! - 2), width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 64, y: ((detailTextLabel?.frame.origin.y)! + 2), width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    let profileImageView: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 24
        
        return img
    }()
    
    let sendBtn: UILabel = {
        
        let btn = UILabel()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.text = "Send"
        btn.textColor = .white
        btn.textAlignment = NSTextAlignment.center
        btn.backgroundColor = .systemBlue
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 12
        
        //btn.addTarget(self, action: #selector(sendPostF), for: .touchUpInside)
        
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        setup()
    }
    
    func setup(){
        
        addSubview(profileImageView)
        addSubview(sendBtn)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        sendBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        sendBtn.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        sendBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func sendPostF(){
        
        
        
        if fullVideoVC != nil {
            
            fullVideoVC?.sendPostF(cell: self)
            
        }else if videoVC != nil {
            
            videoVC?.sendPostF(cell: self)
            
        }else {
            
            homeVC?.sendPostF(cell: self)
            
        }
        
        
        
    }
}
