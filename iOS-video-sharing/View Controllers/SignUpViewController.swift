//
//  SignUpViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import Firebase

class SignUpViewController: UIViewController, UITextViewDelegate {
    
    lazy var contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 430)
    
    let signUpLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = "Sign Up"
        
        lbl.font = UIFont(name: "Australia", size: 40)
        
        lbl.layer.zPosition = 3
        
        return lbl
        
    }()
    
    
    let topImageTheme: UIImageView = {
        
        let logo = UIImageView()
        logo.image = UIImage(named: "blackdude")
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFill
        
        logo.layer.zPosition = 2
        
        return logo

    }()
    
    let fullName: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Full Name"
        
        let img = UIImage(named: "userProfile")
        
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        
        iconView.image = img!
        
        let iconContainer: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 35, height: 30))
        
        iconContainer.addSubview(iconView)
        
        txt.leftView = iconContainer
        txt.leftViewMode = .always
        
        return txt
        
    }()
    
    let email: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Email"
        
        let img = UIImage(named: "userMail")
        
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        
        iconView.image = img!
        
        let iconContainer: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 35, height: 30))
        
        iconContainer.addSubview(iconView)
        
        txt.leftView = iconContainer
        txt.leftViewMode = .always
        
        return txt
        
    }()
    
    let username: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Username"
        
        let img = UIImage(named: "userAt")
        
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        
        iconView.image = img!
        
        let iconContainer: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 35, height: 30))
        
        iconContainer.addSubview(iconView)
        
        txt.leftView = iconContainer
        txt.leftViewMode = .always
        
        return txt
        
    }()
    
    let password: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Password"
        
        let img = UIImage(named: "userPassword")
        
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        
        iconView.image = img!
        
        let iconContainer: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 35, height: 30))
        
        iconContainer.addSubview(iconView)
        
        txt.leftView = iconContainer
        txt.leftViewMode = .always
        
        return txt
        
    }()
    
    lazy var createBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.setTitle("CREATE ACCOUNT", for: .normal)
        
        btn.setTitleColor(.white, for: .normal)
        
        btn.addTarget(self, action: #selector(loginRegister), for: .touchUpInside)
        
        
        return btn
    }()
    
    lazy var switchBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setTitle("Already have an account ? Sign In", for: .normal)
        
        btn.setTitleColor(.lightGray, for: .normal)
        
        btn.addTarget(self, action: #selector(switchF), for: .touchUpInside)
        
        
        return btn
    }()
    
    let termsAndConditionsLbl: UITextView = {
        
        let lbl = UITextView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        
        let attributedString = NSMutableAttributedString(string: "By creating an account, you agree to our ")
        let secondString = NSMutableAttributedString(string: "terms and conditions and ")
        secondString.addAttribute(.link, value: "https://www.garlictechnologies.co.za/terms.html", range: NSRange(location: 0, length: 20))
        
        let thirdString = NSMutableAttributedString(string: "privacy policy.")
        thirdString.addAttribute(.link, value: "https://www.garlictechnologies.co.za/privacy.html", range: NSRange(location: 0, length: 14))
        
        attributedString.append(secondString)
        attributedString.append(thirdString)
        

        lbl.attributedText = attributedString
        
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    let loadingLoader: UIActivityIndicatorView = {
        
        let img = UIActivityIndicatorView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .black
        img.color = .white
        img.startAnimating()
        img.alpha = 0
        
        
        return img
        
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
    
    let loginContainer: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return vw
    }()
    lazy var scrollViewContainer: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.frame.size = contentSize
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
        topScrollView.addSubview(loginContainer)
        
        loginContainer.addSubview(signUpLbl)
        loginContainer.addSubview(topImageTheme)
        
        loginContainer.addSubview(fullName)
        loginContainer.addSubview(email)
        loginContainer.addSubview(username)
        loginContainer.addSubview(password)
        loginContainer.addSubview(createBtn)
        loginContainer.addSubview(switchBtn)
        loginContainer.addSubview(termsAndConditionsLbl)
        
        loginContainer.addSubview(loadingLoader)
        
        topScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topScrollView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        topScrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        topScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        //scrollViewContainer.centerXAnchor.constraint(equalTo: topScrollView.centerXAnchor).isActive = true
        //scrollViewContainer.centerYAnchor.constraint(equalTo: topScrollView.centerYAnchor).isActive = true
        
        loginContainer.centerXAnchor.constraint(equalTo: topScrollView.centerXAnchor).isActive = true
        loginContainer.heightAnchor.constraint(equalToConstant: view.frame.height + 180).isActive = true
        loginContainer.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        bottomConstraint = loginContainer.centerYAnchor.constraint(equalTo: topScrollView.centerYAnchor, constant: 50)
        bottomConstraint?.isActive = true
        
        
        signUpLbl.leftAnchor.constraint(equalTo: loginContainer.leftAnchor, constant: 24).isActive = true
        signUpLbl.centerYAnchor.constraint(equalTo: loginContainer.centerYAnchor, constant:  -60).isActive = true
        signUpLbl.widthAnchor.constraint(equalTo: loginContainer.widthAnchor, constant: 24).isActive = true
        signUpLbl.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        topImageTheme.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor).isActive = true
        topImageTheme.topAnchor.constraint(equalTo: loginContainer.topAnchor).isActive = true
        topImageTheme.bottomAnchor.constraint(equalTo: signUpLbl.topAnchor).isActive = true
        topImageTheme.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        fullName.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor).isActive = true
        fullName.topAnchor.constraint(equalTo: signUpLbl.bottomAnchor).isActive = true
        fullName.heightAnchor.constraint(equalToConstant: 45).isActive = true
        fullName.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        email.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor).isActive = true
        email.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 12).isActive = true
        email.heightAnchor.constraint(equalToConstant: 45).isActive = true
        email.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        username.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor).isActive = true
        username.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 12).isActive = true
        username.heightAnchor.constraint(equalToConstant: 45).isActive = true
        username.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        password.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor).isActive = true
        password.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 12).isActive = true
        password.heightAnchor.constraint(equalToConstant: 45).isActive = true
        password.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        createBtn.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor).isActive = true
        createBtn.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 12).isActive = true
        createBtn.heightAnchor.constraint(equalToConstant: 65).isActive = true
        createBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        switchBtn.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor).isActive = true
        switchBtn.topAnchor.constraint(equalTo: createBtn.bottomAnchor, constant: 12).isActive = true
        switchBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        switchBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        
        termsAndConditionsLbl.centerXAnchor.constraint(equalTo: loginContainer.centerXAnchor).isActive = true
        termsAndConditionsLbl.topAnchor.constraint(equalTo: switchBtn.bottomAnchor, constant: 12).isActive = true
        termsAndConditionsLbl.heightAnchor.constraint(equalToConstant: 45).isActive = true
        termsAndConditionsLbl.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        
        loadingLoader.centerXAnchor.constraint(equalTo: createBtn.centerXAnchor).isActive = true
        loadingLoader.centerYAnchor.constraint(equalTo: createBtn.centerYAnchor).isActive = true
        loadingLoader.heightAnchor.constraint(equalToConstant: 35).isActive = true
        loadingLoader.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        termsAndConditionsLbl.delegate = self
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        
        return false
        
    }
    
    var register = true
    
    @objc func loginRegister(){
        
        if register == true {
            
            signUpF()
            
        }else {
            
            signInF()
            
        }
        
    }
    
    var uniqueId: String!
    
    @objc func signUpF(){
        
        loadingLoader.alpha = 1
        
        createBtn.setTitle("", for: .normal)
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
            
            
            if error != nil {
                
                print(error)
                let alert = UIAlertController(title: "Registration Failed", message: "User already exists or password is too short.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                self.loadingLoader.alpha = 0
                
                self.createBtn.setTitle("CREATE ACCOUNT", for: .normal)
            
            }else {
                
                if Auth.auth().currentUser != nil {
                    
                    let user = Auth.auth().currentUser
                    
                    if let user = user {
                        
                        self.uniqueId = user.uid
                        
                        let itemReviewRef = Database.database().reference().child("users").child(self.uniqueId)
                        
                        let values = ["userId": self.uniqueId, "userName": self.username.text!.lowercased(), "email": self.email.text!, "fullName": self.fullName.text!, "phone": "unknown", "profileImageUrl": "https://firebasestorage.googleapis.com/v0/b/goofy-ea71a.appspot.com/o/blackdude.png?alt=media&token=2cbdeacc-9d06-456f-8cf7-e75d2d6194db"]
                        
                        itemReviewRef.updateChildValues(values) {(error, reference) in
                            
                            if error != nil {
                                
                                let alert = UIAlertController(title: "Error", message: "The was a problem while trying to create your account. Please try again.", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                
                                self.present(alert, animated: true, completion: nil)
                                
                                self.loadingLoader.alpha = 0
                                self.createBtn.setTitle("CREATE ACCOUNT", for: .normal)
                                
                            }else {
                                
                                let profileVC = HomeViewController()
                                
                                profileVC.modalPresentationStyle = .fullScreen
                                
                                self.present(profileVC, animated: true, completion: nil)
                                
                            }
                        
                        }
                    
                    }
                
                }
            
            }
            
        }
        
        
    }
    
    
    @objc func signInF(){
        
        loadingLoader.alpha = 1
        
        createBtn.setTitle("", for: .normal)
        
        Auth.auth().signIn(withEmail: fullName.text!, password: email.text!) { authResult, error in
        
        if error == nil {
            
            //self.dismiss(animated: true, completion: nil)
            
            let profileVC = HomeViewController()
            
            profileVC.modalPresentationStyle = .fullScreen
            
            self.present(profileVC, animated: true, completion: nil)
            
            
        }else {
            
            let alert = UIAlertController(title: "Login Failed", message: "The was a problem while trying to log you in. Please make sure you entered the correct credentials.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            self.loadingLoader.alpha = 0
            self.createBtn.setTitle("Login", for: .normal)
        
        }
            
        }
        
        
    }
    
    @objc func switchF(){
        
        if register == true {
            
            createBtn.setTitle("LOGIN", for: .normal)
            
            switchBtn.setTitle("Don't have an account ? Sign Up", for: .normal)
            
            password.isHidden = true
            username.isHidden = true
            
            let img = UIImage(named: "userMail")
            let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
            iconView.image = img!
            let iconContainer: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 35, height: 30))
            
            iconContainer.addSubview(iconView)
            
            fullName.leftView = iconContainer
            
            fullName.placeholder = "Email"
            
            let imgE = UIImage(named: "userPassword")
            let iconViewE = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
            iconViewE.image = imgE!
            let iconContainerE: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 35, height: 30))
            
            iconContainerE.addSubview(iconViewE)
            
            email.leftView = iconContainerE
            
            
            email.placeholder = "Password"
            
            
            
            register = false
        }else {
            
            createBtn.setTitle("CREATE ACCOUNT", for: .normal)
            
            switchBtn.setTitle("Already have an account ? Sign In", for: .normal)
            
            password.isHidden = false
            username.isHidden = false
            
            let img = UIImage(named: "userProfile")
            let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
            iconView.image = img!
            let iconContainer: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 35, height: 30))
            
            iconContainer.addSubview(iconView)
            
            fullName.leftView = iconContainer
            
            fullName.placeholder = "Full Name"
            
            let imgE = UIImage(named: "userMail")
            let iconViewE = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
            iconViewE.image = imgE!
            let iconContainerE: UIView = UIView(frame: CGRect(x: 10, y: 0, width: 35, height: 30))
            
            iconContainerE.addSubview(iconViewE)
            
            email.placeholder = "Email"
            
            register = true
        }
        
    }

}
