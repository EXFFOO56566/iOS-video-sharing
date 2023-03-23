//
//  FourthViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/29.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {
    
    let onboardImage: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.image = UIImage(named: "onboard3")
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 110
        
        return img
    }()
    
    let welcomeLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.textColor = .white
        
        lbl.text = "#Chat with and meet #new people"
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    let infoLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.textColor = .white
        
        lbl.text = "Make friends with people whom you share the same hobbies!"
        lbl.numberOfLines = 6
        lbl.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup(){
        
        view.backgroundColor = UIColor(red: 98/255, green: 72/255, blue: 246/255, alpha: 1)
        
        view.addSubview(onboardImage)
        
        view.addSubview(welcomeLbl)
        
         view.addSubview(infoLbl)
        
        onboardImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        onboardImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        onboardImage.heightAnchor.constraint(equalToConstant: 220).isActive = true
        onboardImage.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        welcomeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        welcomeLbl.topAnchor.constraint(equalTo: onboardImage.bottomAnchor, constant: 15).isActive = true
        welcomeLbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        welcomeLbl.widthAnchor.constraint(equalToConstant: 255).isActive = true
        
        infoLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        infoLbl.topAnchor.constraint(equalTo: welcomeLbl.bottomAnchor, constant: 15).isActive = true
        infoLbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        infoLbl.widthAnchor.constraint(equalToConstant: 225).isActive = true
        
    }


}
