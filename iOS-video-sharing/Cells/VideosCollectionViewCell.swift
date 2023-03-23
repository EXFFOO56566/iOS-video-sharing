//
//  VideosCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import GSPlayer

class VideosCollectionViewCell: UICollectionViewCell {
    
    var videoViewVC: VideoViewController?
    
    lazy var userProfileImage: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .black
        img.image = UIImage(named: "smell")
        img.contentMode = .scaleAspectFill
        
        img.clipsToBounds = true
        img.layer.cornerRadius = 16
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewUserProfile)))
        
        
        
        return img
    }()
    
    let userName: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Thapelo Matlou"
        lbl.textColor = .white
        
        
        return lbl
    }()
    
    lazy var FollowBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Follow", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.white, for: .normal)
        
        return btn
    }()
    
    let userCaption: UITextView = {
        
        let lbl = UITextView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Thapelo Matlou You dig?"
        //lbl.numberOfLines = 2
        lbl.font = UIFont(name: lbl.font!.fontName, size: 15)
        lbl.isUserInteractionEnabled = false
        lbl.textColor = .white
        lbl.backgroundColor = .clear
        lbl.isHidden = true
        
        return lbl
    }()
    
    let videoLayer: VideoPlayerView = {
        
        let img = VideoPlayerView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .black
        //img.image = UIImage(named: "smell")
        //img.contentMode = .scaleAspectFill
        
        
        return img
    }()
    
    let viewsIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.image = UIImage(named: "views")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .white
        img.contentMode = .scaleAspectFill
        
        
        return img
    }()
    
    let viewsLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "1.7M"
        lbl.textColor = .white
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    let likesIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .white
        img.contentMode = .scaleAspectFill
        img.isHidden = true
        
        
        return img
    }()
    
    let likesLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "257K"
        lbl.textColor = .white
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    lazy var forwardBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .clear
        btn.alpha = 1
        
        btn.addTarget(self, action: #selector(shareF), for: .touchUpInside)
        
        btn.isHidden = true
        
        return btn
    }()
    
    lazy var commentBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "chat")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .clear
        btn.alpha = 1
        
        btn.addTarget(self, action: #selector(commentF), for: .touchUpInside)
        
        return btn
    }()
    
    let commentsLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "1.7M"
        lbl.textColor = .white
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    
    lazy var likeBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .clear
        btn.alpha = 1
        
        btn.addTarget(self, action: #selector(likeF), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var optionsBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "options")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        //btn.contentHorizontalAlignment = .left
        //btn.setTitleColor(.lightGray, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        btn.addTarget(self, action: #selector(optionsF), for: .touchUpInside)
        
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup(){
        
        self.backgroundColor = .black
        
        
        
        addSubview(videoLayer)
        addSubview(userProfileImage)
        addSubview(optionsBtn)
        addSubview(userName)
        //addSubview(FollowBtn)
        addSubview(userCaption)
        addSubview(viewsIcon)
        addSubview(viewsLbl)
        addSubview(likesIcon)
        addSubview(likesLbl)
        
        //addSubview(forwardBtn)
        addSubview(commentBtn)
        addSubview(commentsLbl)
        addSubview(likeBtn)
        
        videoLayer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        videoLayer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        videoLayer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        videoLayer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        userProfileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        optionsBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        optionsBtn.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor).isActive = true
        optionsBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        optionsBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        userName.leftAnchor.constraint(equalTo: userProfileImage.rightAnchor, constant: 12).isActive = true
        userName.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor, constant: -12).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userName.rightAnchor.constraint(equalTo: optionsBtn.leftAnchor, constant: -12).isActive = true
        
        /*FollowBtn.leftAnchor.constraint(equalTo: userName.rightAnchor, constant: 12).isActive = true
        FollowBtn.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor).isActive = true
        FollowBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        FollowBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true*/
        
        userCaption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        userCaption.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
        userCaption.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userCaption.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        /*viewsIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        viewsIcon.bottomAnchor.constraint(equalTo: userCaption.topAnchor, constant: -12).isActive = true
        viewsIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewsIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewsLbl.leftAnchor.constraint(equalTo: viewsIcon.rightAnchor, constant: 12).isActive = true
        viewsLbl.bottomAnchor.constraint(equalTo: userCaption.topAnchor, constant: -12).isActive = true
        viewsLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewsLbl.widthAnchor.constraint(equalToConstant: 45).isActive = true*/
        
        likesIcon.leftAnchor.constraint(equalTo: viewsLbl.rightAnchor, constant: 12).isActive = true
        likesIcon.centerYAnchor.constraint(equalTo: viewsLbl.centerYAnchor).isActive = true
        likesIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likesIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        viewsLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        viewsLbl.bottomAnchor.constraint(equalTo: userCaption.topAnchor, constant: -12).isActive = true
        viewsLbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        viewsLbl.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        viewsIcon.centerXAnchor.constraint(equalTo: viewsLbl.centerXAnchor, constant: 0).isActive = true
        viewsIcon.bottomAnchor.constraint(equalTo: viewsLbl.topAnchor, constant: -12).isActive = true
        viewsIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        viewsIcon.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        commentsLbl.centerXAnchor.constraint(equalTo: commentBtn.centerXAnchor).isActive = true
        commentsLbl.bottomAnchor.constraint(equalTo: viewsIcon.topAnchor, constant: -12).isActive = true
        commentsLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        commentsLbl.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        commentBtn.bottomAnchor.constraint(equalTo: commentsLbl.topAnchor, constant: -12).isActive = true
        commentBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        commentBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        likesLbl.centerXAnchor.constraint(equalTo: commentBtn.centerXAnchor).isActive = true
        likesLbl.bottomAnchor.constraint(equalTo: commentBtn.topAnchor, constant: -12).isActive = true
        likesLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likesLbl.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        likeBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        likeBtn.bottomAnchor.constraint(equalTo: likesLbl.topAnchor, constant: -12).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        likeBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        
        
    }
    
    @objc func viewUserProfile(){
        
        if videoViewVC != nil {
            
            videoViewVC?.viewUserProfileF(cell: self)
            
        }else {
            
            //homeVC?.sendPostF(cell: self)
            
        }
        
    }
    
    @objc func likeF(){
           
           videoViewVC?.likeF(cell: self)
           
       }
       
       @objc func commentF(){
           
           videoViewVC?.commentF(cell: self)
           
       }
       
       @objc func shareF(){
           
           videoViewVC?.shareF(cell: self)
           
       }
       
       @objc func viewAllCommentsF(){
           
           videoViewVC?.viewCommentsF(cell: self)
           
       }
    
    @objc func optionsF(){
        
        videoViewVC?.optionsF(cell: self)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
