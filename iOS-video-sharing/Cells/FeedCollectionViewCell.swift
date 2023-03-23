//
//  FeedCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/23.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Reactions
import GSPlayer

class FeedCollectionViewCell: UICollectionViewCell, ReactionFeedbackDelegate {
    
    let myReaction = Reaction(id: "id", title: "title", color: .red, icon: UIImage(named: "like")!)
 
    

    @objc func reactionDidChanged(_ sender: AnyObject) {
      print(select.selectedReaction)
    }
    
    let select = ReactionSelector()
    

    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
      // .slideFingerAcross, .releaseToCancel, .tapToSelectAReaction
    }
    
    var homeVC: HomeViewController?
    
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
        lbl.textColor = .black
        
        
        return lbl
    }()
    
    let timeStamp: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "30min ago"
        lbl.textColor = .lightGray
        
        
        return lbl
    }()
    
    let videoPreview: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.image = UIImage(named: "smell")
        img.contentMode = .scaleAspectFit
        img.backgroundColor = .black
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 12
        
        img.layer.shadowOffset = CGSize(width: 0, height: 3)
        img.layer.shadowColor = UIColor.lightGray.cgColor
        img.layer.shadowOpacity = 0.7
        
        img.layer.shadowRadius = 1
       
        return img
    }()
    
    let viewsIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.image = UIImage(named: "views")
        
        
        return img
    }()
    
    lazy var forwardIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.image = UIImage(named: "forward")
        img.isUserInteractionEnabled = true
        
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareF)))
        
        return img
    }()
    
    let numberOfForwardsLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "0"
        lbl.textColor = .black
        
        return lbl
    }()
    
    let numberOfViewsLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "0"
        lbl.textColor = .black
        
        return lbl
    }()
    
    lazy var likeIcon: UIImageView = {
           
           let img = UIImageView()
           img.translatesAutoresizingMaskIntoConstraints = false
           img.backgroundColor = .clear
           img.image = UIImage(named: "like")
        img.isUserInteractionEnabled = true
        
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeF)))
           
           
           return img
       }()
       
       let numberOfLikesLbl: UILabel = {
           
           let lbl = UILabel()
           lbl.translatesAutoresizingMaskIntoConstraints = false
           lbl.text = "0"
        lbl.textColor = .black
           
           return lbl
       }()
    
    lazy var commentsIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.image = UIImage(named: "chat")
        
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentF)))
        
        
        return img
    }()
    
    let numberOfCommentsLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "0"
        lbl.textColor = .black
        
        return lbl
    }()
    
    let userCaption: UITextView = {
        
        let lbl = UITextView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Thapelo Matlou You dig?"
        //lbl.numberOfLines = 2
        lbl.font = UIFont(name: lbl.font!.fontName, size: 15)
        lbl.backgroundColor = .white
        lbl.isUserInteractionEnabled = false
        lbl.textColor = .black
        
        return lbl
    }()
    
    lazy var viewAllCommentsBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("View All 1,2k Comments", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.lightGray, for: .normal)
        
        btn.addTarget(self, action: #selector(viewAllCommentsF), for: .touchUpInside)
        
        return btn
    }()
    
    let commentLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Pidima Matlou This some funny sh*t..."
        lbl.numberOfLines = 2
        lbl.textColor = .black
        
        return lbl
    }()
    
    let line: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .lightGray
        
        return vw
    }()
    
    let videoLayer: VideoPlayerView = {
        
        let img = VideoPlayerView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 12
        img.contentMode = .scaleAspectFit
        //img.image = UIImage(named: "smell")
        //img.contentMode = .scaleAspectFill
        
        
        return img
    }()
    
    lazy var optionsBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "options")
        btn.setImage(img, for: .normal)
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
        
        
        
        addSubview(userProfileImage)
        addSubview(optionsBtn)
        addSubview(userName)
        
        addSubview(timeStamp)
        addSubview(videoPreview)
        addSubview(videoLayer)
        //addSubview(viewsIcon)
        addSubview(forwardIcon)
        addSubview(numberOfForwardsLbl)
        //addSubview(numberOfViewsLbl)
        addSubview(likeIcon)
        addSubview(numberOfLikesLbl)
        addSubview(commentsIcon)
        addSubview(numberOfCommentsLbl)
        addSubview(userCaption)
        addSubview(viewAllCommentsBtn)
        addSubview(commentLbl)
        addSubview(line)
        
        select.reactions = Reaction.facebook.all

        // React to reaction change
        select.addTarget(self, action: #selector(reactionDidChanged), for: .valueChanged)

        // Conforming to the ReactionFeedbackDelegate
        select.feedbackDelegate = self
        
        
        userProfileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        optionsBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        optionsBtn.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor).isActive = true
        optionsBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        optionsBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        userName.leftAnchor.constraint(equalTo: userProfileImage.rightAnchor, constant: 12).isActive = true
        userName.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor, constant: -12).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userName.rightAnchor.constraint(equalTo: optionsBtn.leftAnchor, constant: -12).isActive = true
        
        
        
        timeStamp.leftAnchor.constraint(equalTo: userProfileImage.rightAnchor, constant: 12).isActive = true
        timeStamp.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 4).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 20).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        videoPreview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        videoPreview.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 12).isActive = true
        videoPreview.heightAnchor.constraint(equalToConstant: self.frame.width / 1.5).isActive = true
        videoPreview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        videoLayer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        videoLayer.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 12).isActive = true
        videoLayer.heightAnchor.constraint(equalToConstant: self.frame.width / 1.5).isActive = true
        videoLayer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        likeIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        likeIcon.topAnchor.constraint(equalTo: videoPreview.bottomAnchor, constant: 12).isActive = true
        likeIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likeIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        numberOfLikesLbl.leftAnchor.constraint(equalTo: likeIcon.rightAnchor, constant: 12).isActive = true
        numberOfLikesLbl.topAnchor.constraint(equalTo: videoPreview.bottomAnchor, constant: 12).isActive = true
        numberOfLikesLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfLikesLbl.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        commentsIcon.leftAnchor.constraint(equalTo: numberOfLikesLbl.rightAnchor, constant: 12).isActive = true
        commentsIcon.topAnchor.constraint(equalTo: videoPreview.bottomAnchor, constant: 12).isActive = true
        commentsIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        commentsIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        numberOfCommentsLbl.leftAnchor.constraint(equalTo: commentsIcon.rightAnchor, constant: 12).isActive = true
        numberOfCommentsLbl.topAnchor.constraint(equalTo: videoPreview.bottomAnchor, constant: 12).isActive = true
        numberOfCommentsLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfCommentsLbl.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        forwardIcon.leftAnchor.constraint(equalTo: numberOfCommentsLbl.rightAnchor, constant: 12).isActive = true
        forwardIcon.topAnchor.constraint(equalTo: videoPreview.bottomAnchor, constant: 12).isActive = true
        forwardIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        forwardIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        numberOfForwardsLbl.leftAnchor.constraint(equalTo: forwardIcon.rightAnchor, constant: 12).isActive = true
        numberOfForwardsLbl.topAnchor.constraint(equalTo: videoPreview.bottomAnchor, constant: 12).isActive = true
        numberOfForwardsLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfForwardsLbl.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        userCaption.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        userCaption.topAnchor.constraint(equalTo: likeIcon.bottomAnchor, constant: 8).isActive = true
        userCaption.bottomAnchor.constraint(equalTo: viewAllCommentsBtn.topAnchor, constant: -8).isActive = true
        userCaption.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        viewAllCommentsBtn.leftAnchor.constraint(equalTo: likeIcon.leftAnchor).isActive = true
        viewAllCommentsBtn.bottomAnchor.constraint(equalTo: commentLbl.topAnchor, constant: -8).isActive = true
        viewAllCommentsBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        viewAllCommentsBtn.rightAnchor.constraint(equalTo: videoPreview.rightAnchor).isActive = true
        
        commentLbl.leftAnchor.constraint(equalTo: likeIcon.leftAnchor).isActive = true
        commentLbl.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -24).isActive = true
        commentLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        commentLbl.rightAnchor.constraint(equalTo: videoPreview.rightAnchor).isActive = true
        
        line.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
    @objc func likeF(tapGesture: UITapGestureRecognizer){
        
        homeVC?.likeF(cell: self)
        
    }
    
    @objc func commentF(tapGesture: UITapGestureRecognizer){
        
        homeVC?.commentF(cell: self)
        
    }
    
    @objc func shareF(tapGesture: UITapGestureRecognizer){
        
        homeVC?.shareF(cell: self)
        
    }
    
    @objc func viewAllCommentsF(){
        
        homeVC?.viewCommentsF(cell: self)
        
    }
    
    @objc func optionsF(){
        
        homeVC?.optionsF(cell: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func viewUserProfile(){
        
        if homeVC != nil {
            
            homeVC?.viewUserProfileF(cell: self)
            
        }else {
            
            //homeVC?.sendPostF(cell: self)
            
        }
        
    }
    
}
