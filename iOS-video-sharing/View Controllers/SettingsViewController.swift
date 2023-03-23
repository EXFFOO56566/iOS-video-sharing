//
//  SettingsViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    lazy var contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
    
    let profileSettingsView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .white
        
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 12
        vw.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        vw.layer.zPosition = 2
        
        vw.layer.zPosition = 6
        
        return vw
        
    }()
    
    let basicLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Basic Info"
        lbl.textColor = .black
        
        return lbl
        
    }()
    
    let line: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .lightGray
        
        return vw
        
    }()
    
    let userIcon: UIButton = {
        
        let img = UIButton()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
        img.setImage(image, for: .normal)
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 25
        
        img.tintColor = .white
        
        img.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        img.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        return img
        
    }()
    
    let firstNameLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Firts Name"
        lbl.textColor = .lightGray
        
        return lbl
        
    }()
    
    let lastNameLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Last Name"
        lbl.textColor = .lightGray
        
        return lbl
        
    }()
    
    let firstNameValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .white
        txt.layer.shadowColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1).cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 0.0
        
        return txt
        
    }()
    
    
    let lastNameValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .white
        txt.layer.shadowColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1).cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 0.0
        
        return txt
        
    }()
    
    
    let userNameIcon: UIButton = {
        
        let img = UIButton()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "handle")?.withRenderingMode(.alwaysTemplate)
        img.setImage(image, for: .normal)
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 25
        
        img.tintColor = .white
        
        img.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        img.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        return img
        
    }()
    
    let userNameLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Username"
        lbl.textColor = .lightGray
        
        return lbl
        
    }()
    
    let userNameValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .white
        txt.layer.shadowColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1).cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 0.0
        
        txt.layer.zPosition = 7
        
        txt.isUserInteractionEnabled = true
        
        return txt
        
    }()
    
    
    
    let userPhoneIcon: UIButton = {
        
        let img = UIButton()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "phone")?.withRenderingMode(.alwaysTemplate)
        img.setImage(image, for: .normal)
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 25
        
        img.tintColor = .white
        
        img.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        img.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        return img
        
    }()
    
    let phoneLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Phone"
        lbl.textColor = .lightGray
        
        return lbl
        
    }()
    
    let phoneValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .white
        txt.layer.shadowColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1).cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 0.0
        
        txt.layer.zPosition = 7
        
        return txt
        
    }()
    
    
    
    let userEmailIcon: UIButton = {
        
        let img = UIButton()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
        img.setImage(image, for: .normal)
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 25
        
        img.tintColor = .white
        
        img.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        img.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        return img
        
    }()
    
    let emailLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Email"
        lbl.textColor = .lightGray
        
        return lbl
        
    }()
    
    let emailValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .white
        txt.layer.shadowColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1).cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 0.0
        
        txt.layer.zPosition = 7
        
        return txt
        
    }()
    
    
    
    let userMailIcon: UIButton = {
        
        let img = UIButton()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
        img.setImage(image, for: .normal)
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 25
        
        img.tintColor = .white
        
        img.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        img.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        return img
        
    }()
    
    let userBirthIcon: UIButton = {
        
        let img = UIButton()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
        img.setImage(image, for: .normal)
        img.tintColor = .white
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 25
        
        img.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        img.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        return img
        
    }()
    
    let birthDateLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Birth Date"
        lbl.textColor = .lightGray
        
        return lbl
        
    }()
    
    let birthDateValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        
        
        return txt
        
    }()
    
    let saveInfoBtn: UIButton = {
          
          let btn = UIButton()
          btn.translatesAutoresizingMaskIntoConstraints = false
          btn.setTitle("Save", for: .normal)
          btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
          btn.layer.masksToBounds = true
          btn.layer.cornerRadius = 8
          
          btn.layer.zPosition = 9
        
        btn.addTarget(self, action: #selector(saveF), for: .touchUpInside)
          
          return btn
      }()
    
    lazy var topScrollView: UIScrollView = {
        
        let sV = UIScrollView(frame: .zero)
        sV.translatesAutoresizingMaskIntoConstraints = false
        sV.backgroundColor = .clear
        sV.contentSize = contentSize
        sV.frame = self.view.bounds
        sV.layer.zPosition = 1
        
        
        return sV
        
    }()
    
    let settingsContainer: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return vw
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    func setup(){
        
        view.backgroundColor = .white
        
        view.addSubview(topScrollView)
        topScrollView.addSubview(profileSettingsView)
        
        profileSettingsView.addSubview(basicLbl)
        profileSettingsView.addSubview(line)
        
        profileSettingsView.addSubview(userIcon)
        profileSettingsView.addSubview(userNameIcon)
        profileSettingsView.addSubview(userPhoneIcon)
        profileSettingsView.addSubview(userEmailIcon)
        
        profileSettingsView.addSubview(firstNameLbl)
        profileSettingsView.addSubview(firstNameValue)
        profileSettingsView.addSubview(lastNameLbl)
        profileSettingsView.addSubview(lastNameValue)
        profileSettingsView.addSubview(userNameLbl)
        profileSettingsView.addSubview(userNameValue)
        profileSettingsView.addSubview(phoneLbl)
        profileSettingsView.addSubview(phoneValue)
        profileSettingsView.addSubview(emailLbl)
        profileSettingsView.addSubview(emailValue)
        profileSettingsView.addSubview(saveInfoBtn)
        
        topScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topScrollView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        topScrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        topScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        profileSettingsView.centerXAnchor.constraint(equalTo: topScrollView.centerXAnchor).isActive = true
        profileSettingsView.heightAnchor.constraint(equalToConstant: view.frame.height + 45).isActive = true
        profileSettingsView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        bottomConstraint = profileSettingsView.centerYAnchor.constraint(equalTo: topScrollView.centerYAnchor, constant: 50)
        bottomConstraint?.isActive = true
        
        basicLbl.topAnchor.constraint(equalTo: profileSettingsView.topAnchor, constant: 12).isActive = true
        basicLbl.leftAnchor.constraint(equalTo: profileSettingsView.leftAnchor, constant: 24).isActive = true
        basicLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        basicLbl.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        line.centerXAnchor.constraint(equalTo: profileSettingsView.centerXAnchor).isActive = true
        line.topAnchor.constraint(equalTo: basicLbl.bottomAnchor, constant: 12).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        
        userIcon.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        userIcon.leftAnchor.constraint(equalTo: profileSettingsView.leftAnchor, constant: 24).isActive = true
        userIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        firstNameLbl.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12).isActive = true
        firstNameLbl.topAnchor.constraint(equalTo: userIcon.topAnchor, constant: 0).isActive = true
        firstNameLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        firstNameLbl.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 74).isActive = true
        
        firstNameValue.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12).isActive = true
        firstNameValue.topAnchor.constraint(equalTo: firstNameLbl.bottomAnchor, constant: 0).isActive = true
        firstNameValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        firstNameValue.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 74).isActive = true
        
        lastNameLbl.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        lastNameLbl.topAnchor.constraint(equalTo: userIcon.topAnchor, constant: 0).isActive = true
        lastNameLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lastNameLbl.leftAnchor.constraint(equalTo: firstNameValue.rightAnchor, constant: 12).isActive = true
        
        lastNameValue.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        lastNameValue.topAnchor.constraint(equalTo: lastNameLbl.bottomAnchor, constant: 0).isActive = true
        lastNameValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lastNameValue.leftAnchor.constraint(equalTo: firstNameValue.rightAnchor, constant: 12).isActive = true
        
        userNameIcon.topAnchor.constraint(equalTo: userIcon.bottomAnchor, constant: 60).isActive = true
        userNameIcon.leftAnchor.constraint(equalTo: profileSettingsView.leftAnchor, constant: 24).isActive = true
        userNameIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userNameIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        userNameLbl.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12).isActive = true
        userNameLbl.topAnchor.constraint(equalTo: userNameIcon.topAnchor, constant: 0).isActive = true
        userNameLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userNameLbl.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        
        userNameValue.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12).isActive = true
        userNameValue.topAnchor.constraint(equalTo: userNameLbl.bottomAnchor, constant: 0).isActive = true
        userNameValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userNameValue.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        
        userPhoneIcon.topAnchor.constraint(equalTo: userNameIcon.bottomAnchor, constant: 60).isActive = true
        userPhoneIcon.leftAnchor.constraint(equalTo: profileSettingsView.leftAnchor, constant: 24).isActive = true
        userPhoneIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userPhoneIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        phoneLbl.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12).isActive = true
        phoneLbl.topAnchor.constraint(equalTo: userPhoneIcon.topAnchor, constant: 0).isActive = true
        phoneLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        phoneLbl.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        
        phoneValue.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12).isActive = true
        phoneValue.topAnchor.constraint(equalTo: phoneLbl.bottomAnchor, constant: 0).isActive = true
        phoneValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        phoneValue.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        
        userEmailIcon.topAnchor.constraint(equalTo: userPhoneIcon.bottomAnchor, constant: 60).isActive = true
        userEmailIcon.leftAnchor.constraint(equalTo: profileSettingsView.leftAnchor, constant: 24).isActive = true
        userEmailIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userEmailIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailLbl.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12).isActive = true
        emailLbl.topAnchor.constraint(equalTo: userEmailIcon.topAnchor, constant: 0).isActive = true
        emailLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        emailLbl.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        
        emailValue.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 12).isActive = true
        emailValue.topAnchor.constraint(equalTo: emailLbl.bottomAnchor, constant: 0).isActive = true
        emailValue.heightAnchor.constraint(equalToConstant: 20).isActive = true
        emailValue.rightAnchor.constraint(equalTo: line.rightAnchor).isActive = true
        
        saveInfoBtn.topAnchor.constraint(equalTo: userEmailIcon.bottomAnchor, constant: 60).isActive = true
        saveInfoBtn.leftAnchor.constraint(equalTo: profileSettingsView.leftAnchor, constant: 24).isActive = true
        saveInfoBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveInfoBtn.rightAnchor.constraint(equalTo: profileSettingsView.rightAnchor, constant: -24).isActive = true
        
        callUserProfile()
    }
    
    var uniqueId: String!
    
    @objc func callUserProfile(){
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            uniqueId = user.uid
            
            let itemReview = Database.database().reference().child("users").child(uniqueId)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    if let username = dict["fullName"] as? String {
                        
                        let token = username.components(separatedBy: " ")
                        
                        self.firstNameValue.text = token[0]
                        self.lastNameValue.text = token[1]
                        
                    }
                    
                    if let userEmail = dict["email"] as? String {
                        
                        self.emailValue.text = userEmail
                        
                    }
                    
                    if let userhandle = dict["userName"] as? String {
                        
                        self.userNameValue.text = userhandle.lowercased()
                        
                    }
                    
                }
                
            })
            
        }
        
    }
    
    @objc func saveF(){
        
        let itemReviewRef = Database.database().reference().child("users").child(self.uniqueId)
        
        let values = ["fullName": firstNameValue.text! + " " + lastNameValue.text!, "userName": self.userNameValue.text!, "email": self.emailValue.text!, "phone": self.phoneValue.text!]
        
        itemReviewRef.updateChildValues(values) {(error, reference) in
            
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: "The was a problem while trying to save your changes. Please try again.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }else {
                
                let alert = UIAlertController(title: "Success", message: "Your changes have been saved succesfully.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
        
        
    }

}
