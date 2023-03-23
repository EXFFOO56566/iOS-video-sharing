//
//  ThirdIntroViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/26.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class ThirdIntroViewController: UIViewController {
    
    let onboardImage: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.image = UIImage(named: "onboard2")
        img.contentMode = .scaleAspectFill
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 110
        
        
        return img
    }()
    
    let welcomeLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.textColor = .white
        
        lbl.text = "Stream your #favorite"
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    let infoLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.textColor = .white
        
        lbl.text = "Lightning fast video streaming so that you don't ever miss a thing!"
        lbl.numberOfLines = 6
        lbl.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        setup()
    }
    

    func setup(){
        
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
        welcomeLbl.widthAnchor.constraint(equalToConstant: 205).isActive = true
        
        infoLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        infoLbl.topAnchor.constraint(equalTo: welcomeLbl.bottomAnchor, constant: 15).isActive = true
        infoLbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        infoLbl.widthAnchor.constraint(equalToConstant: 225).isActive = true
        
    }

}
