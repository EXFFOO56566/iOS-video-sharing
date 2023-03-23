//
//  HashtagsCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/27.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class HashtagsCollectionViewCell: UICollectionViewCell {
    
    let hashtagLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "#dance"
        lbl.textColor = .white
        lbl.layer.masksToBounds = true
        lbl.layer.borderColor = UIColor.white.cgColor
        lbl.layer.borderWidth = 2
        
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 12
        
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup(){
        
        addSubview(hashtagLbl)
        
        hashtagLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        hashtagLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        hashtagLbl.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -22).isActive = true
        hashtagLbl.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
