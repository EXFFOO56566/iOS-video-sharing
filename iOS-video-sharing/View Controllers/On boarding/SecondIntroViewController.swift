//
//  SecondIntroViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/26.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class SecondIntroViewController: UIViewController {
    
    let onboardImage: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.image = UIImage(named: "onboard1")
        img.contentMode = .scaleAspectFit
        
        
        return img
    }()
    
    let welcomeLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.textColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        lbl.text = "Discover #trending looping videos"
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    let infoLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.textColor = .black
        
        lbl.text = "Find out what's new and hot on the block through versatile video feeds"
        lbl.numberOfLines = 6
        lbl.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        
        setup()
    }
    

    func setup(){
        
        view.addSubview(onboardImage)
        view.addSubview(welcomeLbl)
        view.addSubview(infoLbl)
        
        onboardImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -35).isActive = true
        onboardImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        onboardImage.heightAnchor.constraint(equalToConstant: 275).isActive = true
        onboardImage.widthAnchor.constraint(equalToConstant: 275).isActive = true
        
        welcomeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -35).isActive = true
        welcomeLbl.topAnchor.constraint(equalTo: onboardImage.bottomAnchor, constant: 15).isActive = true
        welcomeLbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        welcomeLbl.widthAnchor.constraint(equalToConstant: 275).isActive = true
        
        infoLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -35).isActive = true
        infoLbl.topAnchor.constraint(equalTo: welcomeLbl.bottomAnchor, constant: 15).isActive = true
        infoLbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        infoLbl.widthAnchor.constraint(equalToConstant: 225).isActive = true
        
    }

}
