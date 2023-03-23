//
//  SearchCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/27.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    let videoPreview: UIImageView = {
           
           let img = UIImageView()
           img.translatesAutoresizingMaskIntoConstraints = false
           img.backgroundColor = .clear
           img.image = UIImage(named: "smell")
        img.contentMode = .scaleAspectFit
        
        img.layer.masksToBounds = true
        img.layer.borderColor = UIColor.clear.cgColor
        img.layer.borderWidth = 2
           
           
           return img
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup(){
        
        addSubview(videoPreview)
        
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 2
        
        videoPreview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        videoPreview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        videoPreview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        videoPreview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
