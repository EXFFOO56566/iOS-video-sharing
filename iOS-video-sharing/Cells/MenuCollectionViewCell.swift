//
//  MenuCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/23.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    let menuIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        
        
        return img
        
    }()
    
    let menuTitle: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = .white
        lbl.font = UIFont(name: "Avenir-Light", size: 14)
        lbl.alpha = 1
        lbl.backgroundColor = .white
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 5
        
        return lbl
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    func setup(){
        
        addSubview(menuTitle)
        addSubview(menuIcon)
        
        menuTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        menuTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        menuTitle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        menuTitle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        menuIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        menuIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        menuIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        menuIcon.bottomAnchor.constraint(equalTo: menuTitle.topAnchor, constant: -15).isActive = true
        
        
    }
    
    override var isHighlighted: Bool {
        
        didSet {
            
            
        }
        
    }
    
    override var isSelected: Bool {
        
        didSet {
            
            menuIcon.tintColor = isSelected ? UIColor.black : UIColor.black
            
            menuTitle.textColor = isSelected ? UIColor.black : UIColor.black
            
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UITextField {
func setIcon(_ image: UIImage) {
   
}
}
