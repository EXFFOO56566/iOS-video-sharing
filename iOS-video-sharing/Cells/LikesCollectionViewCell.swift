//
//  LikesCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/28.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class LikesCollectionViewCell: UICollectionViewCell {
    
    lazy var commenterPicture: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "einstein")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.contentHorizontalAlignment = .left
        btn.backgroundColor = .clear
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 20
        
        return btn
    }()
    
    lazy var likedPostBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "smell")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.backgroundColor = .clear
        
        return btn
    }()
    
    
    lazy var commentValue: UITextView = {
        
        let btn = UITextView()
        btn.translatesAutoresizingMaskIntoConstraints = false
        //btn.setTitle("Comment", for: .normal)
        //btn.setTitleColor(.black, for: .normal)
        //btn.contentHorizontalAlignment = .left
        btn.backgroundColor = .clear
        btn.textColor = .black
        btn.isUserInteractionEnabled = false
        
        return btn
    }()
    
    lazy var commentTime: UILabel = {
        
        let btn = UILabel()
        btn.translatesAutoresizingMaskIntoConstraints = false
        //btn.setTitle("Comment", for: .normal)
        //btn.setTitleColor(.black, for: .normal)
        //btn.contentHorizontalAlignment = .left
        btn.backgroundColor = .clear
        btn.textColor = .lightGray
        btn.isUserInteractionEnabled = false
        btn.text = "18min"
        
        return btn
    }()
    
    lazy var replyBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Reply", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.backgroundColor = .clear
        
        return btn
    }()
    
    
    let line: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .lightGray
        vw.alpha = 0
        
        return vw
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    
    }
    
    func setup(){
        
        addSubview(commenterPicture)
        addSubview(likedPostBtn)
        addSubview(commentValue)
        //addSubview(commentTime)
        //addSubview(replyBtn)
        addSubview(line)
        
        commenterPicture.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 12).isActive = true
        commenterPicture.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        commenterPicture.heightAnchor.constraint(equalToConstant: 40).isActive = true
        commenterPicture.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        likedPostBtn.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -12).isActive = true
        likedPostBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        likedPostBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        likedPostBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentValue.leftAnchor.constraint(equalTo: commenterPicture.rightAnchor,constant: 12).isActive = true
        commentValue.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        commentValue.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -12).isActive = true
        commentValue.rightAnchor.constraint(equalTo: likedPostBtn.leftAnchor, constant: -12).isActive = true
        
        /*commentTime.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 32).isActive = true
        commentTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        commentTime.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -8).isActive = true
        commentTime.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        replyBtn.leftAnchor.constraint(equalTo: commentTime.rightAnchor,constant: 12).isActive = true
        replyBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        replyBtn.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -8).isActive = true
        replyBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true*/
        
        line.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 0).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
