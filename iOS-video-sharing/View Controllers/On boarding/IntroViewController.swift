//
//  IntroViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase

class IntroViewController: UIViewController {
    
    let logoImage: UIImageView = {
        
        let logo = UIImageView()
        logo.image = UIImage(named: "goofy2")
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        
        return logo

    }()
    
    let topImageTheme: UIImageView = {
        
        let logo = UIImageView()
        logo.image = UIImage(named: "topTheme")
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFill
        
        return logo

    }()
    
    let bottomImageTheme: UIImageView = {
        
        let logo = UIImageView()
        logo.image = UIImage(named: "bottomTheme")
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFill
        
        return logo

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup(){
        
        view.backgroundColor = .white
        
        view.addSubview(logoImage)
        view.addSubview(topImageTheme)
        view.addSubview(bottomImageTheme)
        
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        
        topImageTheme.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topImageTheme.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topImageTheme.bottomAnchor.constraint(equalTo: logoImage.topAnchor).isActive = true
        topImageTheme.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        bottomImageTheme.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomImageTheme.topAnchor.constraint(equalTo: logoImage.bottomAnchor).isActive = true
        bottomImageTheme.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomImageTheme.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        animate()
    }
    
    func animate(){
        
        UIView.animate(withDuration: 3, animations: {
            
            //self.logo.alpha = 1
            
        }) { (true) in
            
            self.perform(#selector(self.openHome), with: nil, afterDelay: 0.7)
            
        }
        
    }
    
    @objc func openHome(){
        
        if let user = Auth.auth().currentUser {
            
            let homeVC = HomeViewController()
            
            homeVC.modalPresentationStyle = .fullScreen
            
            present(homeVC, animated: true, completion: nil)
            
        }else {
            
            let vC = ViewController()
            
            vC.modalPresentationStyle = .fullScreen
            
            present(vC, animated: true, completion: nil)
            
        }
        
    }

}
