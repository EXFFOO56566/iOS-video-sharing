//
//  SummaryCollectionViewCell.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/27.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class SummaryCollectionViewCell: UICollectionViewCell {
    
    let numbersLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "23K"
        lbl.textAlignment = NSTextAlignment.center
        lbl.textColor = .black
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: 21.0)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 35
        
        return lbl
    }()
    
    let valuesLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Followers"
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: "Azonix", size: 16)
        lbl.textColor = UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1)
        
        //lbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        

        
        return lbl
    }()
    
    let rightView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = UIColor(red: 187/255, green: 187/255, blue: 192/255, alpha: 1)
        
        return vw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    
    }
    
    func setup(){
        
        addSubview(numbersLbl)
        addSubview(valuesLbl)
        addSubview(rightView)
        
        numbersLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        numbersLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        numbersLbl.heightAnchor.constraint(equalToConstant: 70).isActive = true
        numbersLbl.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        valuesLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        valuesLbl.topAnchor.constraint(equalTo: numbersLbl.bottomAnchor, constant: -30).isActive = true
        valuesLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        valuesLbl.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        rightView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        rightView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        rightView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
       
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
