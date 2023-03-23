//
//  AllVideosCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/27.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class AllVideosCollectionViewCell: UICollectionViewCell {
    
    let videoPreview: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .black
        img.image = UIImage(named: "smell")
        img.contentMode = .scaleAspectFill
        
        img.clipsToBounds = true
        img.layer.cornerRadius = 1
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        
        return img
    }()
    
    let likesIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.image = UIImage(named: "playIco")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .white
        
        
        
        return img
    }()
    
    let likesLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "12.5k"
        lbl.textColor = .white
        
        return lbl
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup(){
        
        addSubview(videoPreview)
        addSubview(likesIcon)
        addSubview(likesLbl)
        
        videoPreview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        videoPreview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        videoPreview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        videoPreview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        likesIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        likesIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likesIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18).isActive = true
        likesIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        likesLbl.leftAnchor.constraint(equalTo: likesIcon.rightAnchor, constant: 12).isActive = true
        likesLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likesLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18).isActive = true
        likesLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
