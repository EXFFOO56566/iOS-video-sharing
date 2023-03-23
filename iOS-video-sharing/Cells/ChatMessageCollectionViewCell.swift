//
//  ChatMessageCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/14.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class ChatMessageCollectionViewCell: UICollectionViewCell {
    
    var chatLogController: ChatLogController?
    
    let textView: UITextView = {
        
        let txt = UITextView()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.isUserInteractionEnabled = false
        txt.isEditable = false
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.backgroundColor = .clear
        txt.textColor = .white
        
        
        return txt
        
    }()
    
    static let blueColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
    
    let bubbleView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = blueColor
        vw.layer.masksToBounds = true
        vw.layer.cornerRadius = 16
        
        return vw
    }()
    
    let profileImageView: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 16
        
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userImageView: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "smell")
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 8
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        img.isUserInteractionEnabled = true
        
        return img
    }()

    let userNameLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.text = "yessir"
        
        return lbl
        
    }()
    
    lazy var messageImageView: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 16
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        
        return img
        
    }()
    
    let userCaptionLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.text = "yessir ha ha funny"
        
        return lbl
        
    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer){
        
        if let imageView = tapGesture.view as? UIImageView {
            
            self.chatLogController?.performZoomInForStartingImage(startingImageView: imageView)
            
        }
        
        
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    var messageImageViewTopAnchor: NSLayoutConstraint?
    var messageImageViewBottomAnchor: NSLayoutConstraint?
    
    func setup(){
        
        addSubview(profileImageView)
        addSubview(bubbleView)
        addSubview(textView)
        
        bubbleView.addSubview(userImageView)
        bubbleView.addSubview(userNameLbl)
        bubbleView.addSubview(userCaptionLbl)
        bubbleView.addSubview(messageImageView)
        
        userImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        userImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8).isActive = true
        userImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        
        userNameLbl.heightAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
        userNameLbl.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        userNameLbl.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        userNameLbl.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 8).isActive = true
        
        userCaptionLbl.heightAnchor.constraint(equalToConstant: 16).isActive = true
        userCaptionLbl.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -8).isActive = true
        userCaptionLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8).isActive = true
        userCaptionLbl.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        
        messageImageViewBottomAnchor = messageImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 0)
        messageImageViewBottomAnchor?.isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageViewTopAnchor = messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 0)
        messageImageViewTopAnchor?.isActive = true
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        
        
    }
       
    
}
