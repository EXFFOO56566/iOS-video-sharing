//
//  ProfileViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let titleIcons = ["home", "search", "add", "like", "user"]
    let titles = ["Home", "Categories", "Deals", "My Account", "Cart"]
    
    var videos = [Video]()
    
    var videoUrls = [String]()
    var videoLikes = [Int]()
    var videoViews = [Int]()
    var videoOwnersIds = [String]()
    var videoCaptions = [String]()
    var videoKeys = [String]()
    var videoImages = [String]()
    var videoImageWidths = [CGFloat]()
    var videoImageHeights = [CGFloat]()
    
    var summaryValues = ["0", "0", "0"]
    var summaryValuesLbl = ["Followers", "Following", "Videos"]
    
    
    var userId = ""
    
    var setUser = User()
    
    
    let topView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .white
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 56
        vw.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        return vw
        
    }()
    
    lazy var profileImageBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "smell")
        
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 60
        btn.layer.zPosition = 4
        
        btn.addTarget(self, action: #selector(changeProfile), for: .touchUpInside)
        
        
        return btn
    }()
    
    lazy var backBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "backIco")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .clear
        btn.setTitleColor(.white, for: .normal)
        
        btn.addTarget(self, action: #selector(backF), for: .touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        
        return btn
    }()
    
    let userFullName: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.textAlignment = NSTextAlignment.center
        
        lbl.text = "Thapelo Matlou"
        //lbl.font = UIFont(name: lbl.font.fontName, size: 20)
        lbl.font = UIFont.boldSystemFont(ofSize: 21.0)
        lbl.layer.zPosition = 3
        
        return lbl
    }()
    
    let userHandle: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.textAlignment = NSTextAlignment.center
        
        lbl.text = "@thapelomatlou"
        
        lbl.layer.zPosition = 3
        
        return lbl
    }()
    
    let aboutUser: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.textAlignment = NSTextAlignment.center
        
        lbl.text = "King king King king King king King king King king King king King king King king King king King king King king King king"
        
        lbl.layer.zPosition = 3
        
        return lbl
    }()
    
    
    let topViewMiniPatcher: UIView = {
           
           let vw = UIView()
           vw.translatesAutoresizingMaskIntoConstraints = false
           vw.backgroundColor = .black
        
        vw.layer.zPosition = 3
           
           return vw
    }()
    
    let topViewPatcher: UIView = {
           
           let vw = UIView()
           vw.translatesAutoresizingMaskIntoConstraints = false
           vw.backgroundColor = .white
           vw.clipsToBounds = true
           vw.layer.cornerRadius = 56
           vw.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        vw.layer.zPosition = 3
           
           return vw
    }()
    
    let bottomView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .white
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 56
        vw.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        
        vw.layer.zPosition = 3
        
        return vw
        
    }()
    
    let menuBottomView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        view.layer.zPosition = 7
        
        return view
    }()
    
    lazy var menuCV: UICollectionView = {
    
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuId")
        cv.backgroundColor = .clear
        
        cv.layer.zPosition = 7
        
        
        return cv
    
    }()
    
    
    lazy var addBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 35
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        let img = UIImage(named: "add")
        
        btn.setImage(img, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        
        btn.addTarget(self, action: #selector(postVideoF), for: .touchUpInside)
        
        btn.layer.zPosition = 7
        
        return btn
    }()
    
    @objc func postVideoF(){
        
        let story = UIStoryboard(name: "Main", bundle:nil)
           let vc = story.instantiateViewController(withIdentifier: "NewViewController") as! OptiViewController
        vc.videoCategory = "videos"
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
    
    
    
    let bottomViewMiniPatcher: UIView = {
           
           let vw = UIView()
           vw.translatesAutoresizingMaskIntoConstraints = false
           vw.backgroundColor = .white
        vw.layer.zPosition = 3
           
           return vw
    }()
    
    let bottomViewPatcher: UIView = {
           
           let vw = UIView()
           vw.translatesAutoresizingMaskIntoConstraints = false
           vw.backgroundColor = .white
           vw.clipsToBounds = true
           vw.layer.cornerRadius = 56
           vw.layer.maskedCorners = [.layerMinXMaxYCorner]
        vw.layer.zPosition = 5
           
           return vw
    }()
    
    let summaryCollectionView: UICollectionView = {
           
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           layout.minimumInteritemSpacing = 0
           layout.minimumLineSpacing = 0
        
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
           collectionView.register(SummaryCollectionViewCell.self, forCellWithReuseIdentifier: "Summary")
           collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
           collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = false
           collectionView.translatesAutoresizingMaskIntoConstraints = false
           
        collectionView.layer.zPosition = 20
           
           return collectionView
           
       }()
    
    let allVideosLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "All Videos"
        lbl.textColor = .white
        lbl.layer.zPosition = 3
        
        return lbl
    }()
    
    let allVideosCollectionView: UICollectionView = {
        
        let layout = PinterestLayout()
        layout.cellPadding = 8
        //layout.scrollDirection = .vertical
        //layout.minimumInteritemSpacing = 1
        //layout.minimumLineSpacing = 1
     
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AllVideosCollectionViewCell.self, forCellWithReuseIdentifier: "AllVideos")
        collectionView.contentInset = UIEdgeInsets(top: 1, left: 1, bottom: 50, right: 1)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.layer.zPosition = 4
        
        
        return collectionView
        
    }()
    
    let actionsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
     
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HashtagsCollectionViewCell.self, forCellWithReuseIdentifier: "Actions")
        collectionView.contentInset = UIEdgeInsets(top: 1, left: 50, bottom: 1, right: 50)
        collectionView.alwaysBounceHorizontal = false
        collectionView.backgroundColor = .clear
     collectionView.alwaysBounceHorizontal = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.layer.zPosition = 3
        
        
        return collectionView
        
    }()

    let messageBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Message", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 21
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 2
        
        btn.layer.zPosition = 5
        
        btn.addTarget(self, action: #selector(messageF), for: .touchUpInside)
        
        return btn
    }()
    
    let followBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Follow", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 21
        
        btn.layer.zPosition = 5
        
        btn.addTarget(self, action: #selector(followF), for: .touchUpInside)
        
        return btn
    }()
    
    let moreBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Settings", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 21
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 2
        
        btn.layer.zPosition = 5
        btn.isHidden = true
        
        btn.addTarget(self, action: #selector(showSettingsF), for: .touchUpInside)
        
        return btn
    }()
    
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
        
        img.backgroundColor = .red
        
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
        txt.layer.shadowColor = UIColor.red.cgColor
        txt.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        txt.layer.shadowOpacity = 1.0
        txt.layer.shadowRadius = 0.0
        
        return txt
        
    }()
    
    
    let lastNameValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .white
        txt.layer.shadowColor = UIColor.red.cgColor
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
        
        img.backgroundColor = .red
        
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
        txt.layer.shadowColor = UIColor.red.cgColor
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
        
        img.backgroundColor = .red
        
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
        txt.layer.shadowColor = UIColor.red.cgColor
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
        
        img.backgroundColor = .red
        
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
        txt.layer.shadowColor = UIColor.red.cgColor
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
        
        img.backgroundColor = .red
        
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
        
        img.backgroundColor = .red
        
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
        btn.backgroundColor = .red
          btn.layer.masksToBounds = true
          btn.layer.cornerRadius = 8
          
          btn.layer.zPosition = 9
        
        btn.addTarget(self, action: #selector(saveF), for: .touchUpInside)
          
          return btn
      }()
    
    
    let loadingLoader: UIActivityIndicatorView = {
        
        let img = UIActivityIndicatorView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .white
        img.color = .white
        img.startAnimating()
        img.alpha = 0
        
        
        return img
        
    }()
    
    let bottomCurve: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.layer.cornerRadius = 26
        vw.layer.shadowColor = UIColor.black.cgColor
        vw.layer.shadowOpacity = 0.1
        vw.layer.shadowOffset = CGSize(width: 0, height: 7)
        vw.layer.masksToBounds = false
        vw.backgroundColor = .white
        
        
        return vw
    }()
    
    let norch: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        vw.layer.masksToBounds = true
        vw.layer.cornerRadius = 3
        vw.layer.zPosition = 20
        
        vw.backgroundColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
        
        
        return vw
    }()
    
    lazy var optionsBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "options")
        btn.setImage(img, for: .normal)
        //btn.contentHorizontalAlignment = .left
        //btn.setTitleColor(.lightGray, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        btn.addTarget(self, action: #selector(optionsF), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    
    }
    
    var topMovingAnchor: NSLayoutConstraint?
    
    var canSendMessageFrom = true
    
    func setup(){
        
        view.backgroundColor = .white
        
        summaryCollectionView.dataSource = self
        summaryCollectionView.delegate = self
        
        allVideosCollectionView.dataSource = self
        allVideosCollectionView.delegate = self
        
        actionsCollectionView.dataSource = self
        actionsCollectionView.delegate = self
        
        menuCV.dataSource = self
        menuCV.delegate = self
        
        view.addSubview(topView)
        topView.addSubview(profileImageBtn)
        topView.addSubview(loadingLoader)
        view.addSubview(profileSettingsView)
        
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
        
        topView.addSubview(userFullName)
        //topView.addSubview(userHandle)
        topView.addSubview(aboutUser)
        
        topView.addSubview(backBtn)
        topView.addSubview(optionsBtn)
        
        view.addSubview(bottomView)
        
        
        view.addSubview(allVideosCollectionView)
        
        view.addSubview(summaryCollectionView)
         view.addSubview(messageBtn)
        view.addSubview(followBtn)
        view.addSubview(moreBtn)
        view.addSubview(bottomCurve)
        bottomCurve.addSubview(norch)
        
        view.addSubview(menuBottomView)
        view.addSubview(addBtn)
        view.addSubview(menuCV)
        
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        topView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        optionsBtn.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        optionsBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor).isActive = true
        optionsBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        optionsBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileImageBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        profileImageBtn.heightAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        loadingLoader.leftAnchor.constraint(equalTo: profileImageBtn.rightAnchor, constant: 12).isActive = true
        loadingLoader.centerYAnchor.constraint(equalTo: profileImageBtn.centerYAnchor).isActive = true
        loadingLoader.heightAnchor.constraint(equalToConstant: 35).isActive = true
        loadingLoader.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        profileSettingsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topMovingAnchor = profileSettingsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        topMovingAnchor?.isActive = true
        profileSettingsView.heightAnchor.constraint(equalToConstant: view.frame.height - 200).isActive = true
        profileSettingsView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        basicLbl.topAnchor.constraint(equalTo: profileSettingsView.topAnchor, constant: 12).isActive = true
        basicLbl.leftAnchor.constraint(equalTo: profileSettingsView.leftAnchor, constant: 24).isActive = true
        basicLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        basicLbl.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
        
        
        userFullName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userFullName.topAnchor.constraint(equalTo: profileImageBtn.bottomAnchor, constant: 12).isActive = true
        userFullName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userFullName.widthAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true
        
        
        /*userHandle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userHandle.topAnchor.constraint(equalTo: userFullName.bottomAnchor, constant: 0).isActive = true
        userHandle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userHandle.widthAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true*/
        
        aboutUser.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        aboutUser.topAnchor.constraint(equalTo: userFullName.bottomAnchor, constant: 12).isActive = true
        aboutUser.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aboutUser.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        
        
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        bottomView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        messageBtn.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 8).isActive = true
        messageBtn.topAnchor.constraint(equalTo: userFullName.bottomAnchor, constant: 12).isActive = true
        messageBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        messageBtn.widthAnchor.constraint(equalToConstant: 155).isActive = true
        
        followBtn.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -8).isActive = true
        followBtn.topAnchor.constraint(equalTo: userFullName.bottomAnchor, constant: 12).isActive = true
        followBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        followBtn.widthAnchor.constraint(equalToConstant: 155).isActive = true
        
        moreBtn.leftAnchor.constraint(equalTo: followBtn.leftAnchor, constant: 0).isActive = true
        moreBtn.topAnchor.constraint(equalTo: userFullName.bottomAnchor, constant: 12).isActive = true
        moreBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        moreBtn.rightAnchor.constraint(equalTo: messageBtn.rightAnchor).isActive = true
        
        bottomCurve.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        bottomCurve.topAnchor.constraint(equalTo: summaryCollectionView.bottomAnchor, constant: 0).isActive = true
        bottomCurve.heightAnchor.constraint(equalToConstant: 15).isActive = true
        bottomCurve.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        norch.centerXAnchor.constraint(equalTo: bottomCurve.centerXAnchor, constant: 0).isActive = true
        norch.bottomAnchor.constraint(equalTo: bottomCurve.bottomAnchor, constant: -8).isActive = true
        norch.heightAnchor.constraint(equalToConstant: 5).isActive = true
        norch.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        allVideosCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        allVideosCollectionView.topAnchor.constraint(equalTo: bottomCurve.bottomAnchor, constant: 12).isActive = true
        allVideosCollectionView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        allVideosCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 16).isActive = true
        
        
        summaryCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        summaryCollectionView.topAnchor.constraint(equalTo: followBtn.bottomAnchor, constant: 12).isActive = true
        summaryCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        summaryCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        
        menuBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        menuBottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuBottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuBottomView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        addBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true
        addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        menuCV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuCV.bottomAnchor.constraint(equalTo: menuBottomView.bottomAnchor).isActive = true
        menuCV.heightAnchor.constraint(equalToConstant: view.frame.width / 5).isActive = true
        
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createBezierPath().cgPath
        
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0

        // add the new layer to our custom view
        menuBottomView.layer.addSublayer(shapeLayer)
        
        menuBottomView.layer.shadowOffset = .zero
        menuBottomView.layer.shadowColor = UIColor.white.cgColor
        menuBottomView.layer.shadowRadius = 20
        menuBottomView.layer.shadowOpacity = 1
        
        if (userId == ""){
            
            callUserProfile()
            moreBtn.isHidden = false
            followBtn.isHidden = true
            messageBtn.isHidden = true
            
            
        }else {
            
            callUnkownUserProfile()
            moreBtn.isHidden = true
            followBtn.isHidden = false
            messageBtn.isHidden = false
            
            let itemReview = Database.database().reference().child("users").child(userId)
            
            itemReview.observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                       
                       if let blocked = dict["blocked"] as? [String: AnyObject]{
                           
                           for iB in blocked {
                               
                            if iB.key == Auth.auth().currentUser!.uid {
                                   
                                self.canSendMessageFrom = false
                                   
                               }
                           }
                           
                       }
                    
                }
                
            })
            
            
        }
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            uniqueId = user.uid
            
            if uniqueId == userId {
                
                moreBtn.isHidden = false
                followBtn.isHidden = true
                messageBtn.isHidden = true
                
            }
            
        }
        
        
        
        if let layout = allVideosCollectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self as! PinterestLayoutDelegate
        }
        
        
        
        
        
    }
    
    
    @objc func optionsF(){
        
        if userId == "" {
            
            let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
            
            let settingsF = UIAlertAction(title: "Settings", style: .default) { (action) in
                
                self.showSettingsF()
            
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            }
            
            alertController.addAction(settingsF)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
            
            return
            
        }
        
        var reportF: UIAlertAction!
        
        if canSendMessageFrom == true {
            
            reportF = UIAlertAction(title: "Block Account", style: .default) { (action) in
                
                self.blockUnblock()
            
            }
            
        }else {
            
            reportF = UIAlertAction(title: "Unblock Account", style: .default) { (action) in
                
                self.blockUnblock()
            
            }
            
            
        }
        
        let alertController = UIAlertController(title: "Info", message: nil, preferredStyle: .actionSheet)
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
        }
        
        alertController.addAction(reportF)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @objc func blockUnblock(){
        
        if self.canSendMessageFrom == true {
            
            let childValues = ["uniqueId": Auth.auth().currentUser!.uid]
            
            Database.database().reference().child("users").child(self.userId).child("blocked").child(Auth.auth().currentUser!.uid).updateChildValues(childValues as [AnyHashable : Any])
            
            self.canSendMessageFrom = false
            
        }else {
            
            Database.database().reference().child("users").child(self.userId).child("blocked").child(Auth.auth().currentUser!.uid).removeValue()
            
            self.canSendMessageFrom = true
        }
        
    }
    
    
    var following = false
    var numOfFollowers = 0
    var numOfVideos = 0
    var numOfFollowings = 0
    
    @objc func followF(){
        
        if userId == "" {
            
            return
            
        }
        
        let childValues = ["uniqueId": uniqueId]
        
        if following == false {
            
            Database.database().reference().child("users").child(userId).child("followers").child(uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            //self.numOfFollowers += 1
            
            /*likesLbl.text = "\(numOfLikes)"
            
            self.likeBtn.tintColor = .red*/
            
            self.summaryValues[0] = "\(self.numOfFollowers)"
            
            self.summaryCollectionView.reloadData()
            
            followBtn.setTitle("Following", for: .normal)
            
            following = true
            
        }else {
            
            Database.database().reference().child("users").child(userId).child("followers").child(uniqueId).removeValue()
            
            self.numOfFollowers -= 1
            
            self.summaryValues[0] = "\(self.numOfFollowers)"
            
            self.summaryCollectionView.reloadData()
            
            /*likesLbl.text = "\(numOfLikes)"
            
            self.likeBtn.tintColor = .white*/
            
            followBtn.setTitle("Follow", for: .normal)
            
            following = false
            
        }
        
    }
    
    var chatsController: ChatsTableViewController?
    
    @objc func messageF(){
        
        if userId == "" {
            
            return
            
        }
        
        
        let user = setUser
        
        let chatsVC = ChatsTableViewController()
        chatsVC.openChatLog = true
        chatsVC.user = user
        
        present(UINavigationController(rootViewController: chatsVC), animated: true, completion: nil)
        
        
        
    }
    
    @objc func moreF(){
        
        
    }
    
    @objc func saveF(){
        
        print("hello")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            self.uniqueId = user.uid
            
            let itemReview = Database.database().reference().child("users").child(uniqueId)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    if let userimage = dict["profileImageUrl"] as? String {
                        
                        if (self.userId != ""){
                            
                            return
                            
                        }
                        
                        
                        self.profileImageBtn.imageView!.sd_setImage(with: URL(string: userimage)) { (image, error, cachType, url) in
                            
                            self.profileImageBtn.setImage(image, for: .normal)
                            
                            
                        }
                        
                    }
                    
                }
                
            })
           
           
       }
        
        
    }
    
    
    var globalUserId: String!
    
    @objc func changeProfile(){
        
        if (userId != ""){
            
            return
        }
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            globalUserId = user.uid
            
            addImageF()
            
        }
        
    }
    
    let imagePickerController = UIImagePickerController()
    
    @objc func addImageF(){
        
        let alert = UIAlertController(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
            
            //self.menuCV.selectItem(at: [0,0], animated: true, scrollPosition: [])
        
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
            
            //self.menuCV.selectItem(at: [0,0], animated: true, scrollPosition: [])
        
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
        }
        
        alert.addAction(photoLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    var globalImage: UIImage!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            return self.imagePickerControllerDidCancel(picker)
        
        }
        
        globalImage = image
        
        uploadImage()
        
        //mergeBackgroundImageF()
        
        picker.dismiss(animated: true, completion: nil)
    
    }
    
    func uploadImage(){
        
        let imageName = NSUUID().uuidString
        
        loadingLoader.alpha = 1
        
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        
        let uploadData = globalImage.pngData()!
        
        storageRef.putData(uploadData, metadata: nil) { (mdata, error) in
            
            if error != nil {
            
            }else {
                
                storageRef.downloadURL { (url, error) in
                    
                    guard let downloadURL = url else {
                        
                        // Uh-oh, an error occurred!
                        
                        return
                    
                    }
                    
                    let itemReviewRef = Database.database().reference().child("users").child(self.globalUserId)
                    
                    let values = ["profileImageUrl": downloadURL.absoluteString]
                    
                    itemReviewRef.updateChildValues(values) {(error, reference) in
                        
                        if error != nil {
                            
                            //failure
                        
                        }else {
                            
                            //success
                            
                            self.loadingLoader.alpha = 0
                            
                            
                            self.profileImageBtn.imageView!.sd_setImage(with: URL(string: downloadURL.absoluteString)) { (image, error, cachType, url) in
                                
                                self.profileImageBtn.setImage(image, for: .normal)
                                
                                
                            }
                        
                        }
                    
                    }
                
                }
            
            }
        
        }
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        picker.delegate = nil
    
    }
    
    
    @objc func backF(){
        
        dismiss(animated: true, completion: nil)
    }
    
    var reloadingTimer = Timer()
    
    @objc func reloadTable(){
        
        self.allVideosCollectionView.reloadData()
        self.allVideosCollectionView.collectionViewLayout.invalidateLayout()
        
        
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
                        
                        self.userFullName.text = username
                        
                        
                        
                    }
                    
                    
                    if let userhandle = dict["userName"] as? String {
                        
                        self.userHandle.text = "@" + userhandle.lowercased()
                        
                    }
                    
                }
                
            })
            
            //get followers and followings:
            
            Database.database().reference().child("users").child(self.uniqueId).child("followers").observe(.childAdded, with: {(snapshot) in
                
                let numOfChildren = snapshot.childrenCount
                
                self.numOfFollowers += Int(numOfChildren)
                
                self.summaryValues[0] = "\(numOfChildren)"
                
                //self.likesLbl.text = "\(numOfChildren)"  //number of followers
                
                
            })
            
            Database.database().reference().child("users").child(self.uniqueId).child("followings").observe(.childAdded, with: {(snapshot) in
                
                let numOfChildren = snapshot.childrenCount
                
                self.numOfFollowings += Int(numOfChildren)
                
                self.summaryValues[1] = "\(self.numOfFollowings)"
                
                //self.numOfLikes = Int(numOfChildren)
                
                //self.likesLbl.text = "\(numOfChildren)"  //number of followngs
                
                
            })
            
            
            //get videos:
            
            let topProducts = Database.database().reference().child("videos").queryOrdered(byChild: "userId").queryStarting(atValue: uniqueId).queryEnding(atValue: uniqueId+"\u{f8ff}")
            
            topProducts.observe(.childAdded) { (snapshotKey) in
                
                let key = snapshotKey.key
                
             
                let itemReview = Database.database().reference().child("videos").child(key)
                
                
                itemReview.observe(.value, with: {(snapshot) in
                    
                    
                    
                    self.summaryCollectionView.reloadData()
                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        
                        if let videoUrl = dict["videoUrl"] as? String {
                              
                              self.videoUrls.append(videoUrl)
                            
                            self.numOfVideos += 1
                            
                            self.summaryValues[2] = "\(self.numOfVideos)"
                            
                            self.summaryCollectionView.reloadData()
                              
                          }
                          
                          if let videoOwnerId = dict["userId"] as? String {
                              
                              self.videoOwnersIds.append(videoOwnerId)
                          }
                          
                          if let videoImageUrl = dict["videoImageUrl"] as? String {
                              
                              self.videoImages.append(videoImageUrl)
                              
                          }
                          
                          if let videoImageWidth = dict["videoImageWidth"] as? CGFloat {
                              
                              self.videoImageWidths.append(videoImageWidth)
                                                      
                          }
                          
                          if let videoImageHeight = dict["videoImageHeight"] as? CGFloat {
                              
                              self.videoImageHeights.append(videoImageHeight)
                              
                          }
                          
                          if let videoCaption = dict["caption"] as? String {
                              
                              self.videoCaptions.append(videoCaption)
                              
                          }
                          
                        
                          
                          if let videoKey = dict["videoId"] as? String {
                              
                              self.videoKeys.append(videoKey)
                              
                          }
                        
                        let video = Video()
                        video.setValuesForKeys(dict)
                        self.videos.append(video)
                        
                    }
                    
                })
                
                self.allVideosCollectionView.reloadData()
                self.reloadingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: true)
                
            }
            
            
            
            
        }
        
    }
    
    @objc func callUnkownUserProfile(){
        
        
        let itemReview = Database.database().reference().child("users").child(userId)
        
        itemReview.observe(.value, with: {(snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                self.setUser.setValuesForKeys(dict)
                
                if let username = dict["fullName"] as? String {
                    
                    self.userFullName.text = username
                    
                }
                
                if let userhandle = dict["userName"] as? String {
                    
                    self.userHandle.text = "@" + userhandle.lowercased()
                    
                }
                
                if let userimage = dict["profileImageUrl"] as? String {
                    
                    self.profileImageBtn.imageView!.sd_setImage(with: URL(string: userimage)) { (image, error, cachType, url) in
                        
                        self.profileImageBtn.setImage(image, for: .normal)
                        
                        
                    }
                    
                }
                
                
                
            }
            
        })
        
        //get number of followers and followings
        
        Database.database().reference().child("users").child(self.userId).child("followers").observe(.childAdded, with: {(snapshot) in
            
            let numOfChildren = snapshot.childrenCount
            
            self.numOfFollowers += Int(numOfChildren)
            
            
            let indexP = IndexPath(row: 0, section: 0)
            
            self.summaryValues[0] = "\(self.numOfFollowers)"
            
            self.summaryCollectionView.reloadData()
            
            if let cell = self.summaryCollectionView.cellForItem(at: indexP) as? SummaryCollectionViewCell {
                
                cell.numbersLbl.text = "\(self.numOfFollowers)"
                
            }
            
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let followersIds = rest.value as? String {
                    
                    if followersIds == self.uniqueId {
                        
                        self.following = true
                        self.followBtn.setTitle("Following", for: .normal)
                    }
                }
                
            }
            
            
        })
        
        Database.database().reference().child("users").child(self.userId).child("followings").observe(.childAdded, with: {(snapshot) in
            
            let numOfChildren = snapshot.childrenCount
            
            self.numOfFollowings += Int(numOfChildren)
            
            if let cell = self.summaryCollectionView.cellForItem(at: [0,1]) as? SummaryCollectionViewCell {
                
                cell.numbersLbl.text = "\(numOfChildren)"
                
            }
            
            self.summaryValues[1] = "\(self.numOfFollowings)"
            
            self.summaryCollectionView.reloadData()
            
            //self.numOfLikes = Int(numOfChildren)
            
            //self.likesLbl.text = "\(numOfChildren)" // number of followings
            
            
            
            
        })
        
        //get videos:
        
        let topProducts = Database.database().reference().child("videos").queryOrdered(byChild: "userId").queryStarting(atValue: userId).queryEnding(atValue: userId+"\u{f8ff}")
        
        topProducts.observe(.childAdded) { (snapshotKey) in
            
            let key = snapshotKey.key
            
            
            
            let itemReview = Database.database().reference().child("videos").child(key)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                 
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    if let videoUrl = dict["videoUrl"] as? String {
                          
                          self.videoUrls.append(videoUrl)
                        
                        self.numOfVideos += 1
                        
                        self.summaryValues[2] = "\(self.numOfVideos)"
                        
                        self.summaryCollectionView.reloadData()
                          
                      }
                      
                      if let videoOwnerId = dict["userId"] as? String {
                          
                          self.videoOwnersIds.append(videoOwnerId)
                      }
                      
                      if let videoImageUrl = dict["videoImageUrl"] as? String {
                          
                          self.videoImages.append(videoImageUrl)
                          
                      }
                      
                      if let videoImageWidth = dict["videoImageWidth"] as? CGFloat {
                          
                          self.videoImageWidths.append(videoImageWidth)
                                                  
                      }
                      
                      if let videoImageHeight = dict["videoImageHeight"] as? CGFloat {
                          
                          self.videoImageHeights.append(videoImageHeight)
                          
                      }
                      
                      if let videoCaption = dict["caption"] as? String {
                          
                          self.videoCaptions.append(videoCaption)
                          
                      }
                      
                    
                      
                      if let videoKey = dict["videoId"] as? String {
                          
                          self.videoKeys.append(videoKey)
                          
                      }
                    
                    let video = Video()
                    video.setValuesForKeys(dict)
                    self.videos.append(video)
                    
                }
                
            })
            
            self.allVideosCollectionView.reloadData()
            self.reloadingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: true)
            
        }
        
    }
    
    var shouldViewSettings = false
    
    @objc func showSettingsF(){
        
        let settingsVC = SettingsViewController()
        
        present(settingsVC, animated: true, completion: nil)
        
        /*if shouldViewSettings == false {
            
            topMovingAnchor?.isActive = false
            topMovingAnchor?.constant = 200
            topMovingAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.9) {
                
                self.view.layoutIfNeeded()
            }
            
            shouldViewSettings = true
        }else {
            
            topMovingAnchor?.isActive = false
            topMovingAnchor?.constant = view.frame.height
            topMovingAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.9) {
                
                self.view.layoutIfNeeded()
            }
            
            shouldViewSettings = false
        }
        */
        
        
    }
    
    func createBezierPath() -> UIBezierPath {
        
        let tabWidth: CGFloat = view.frame.width / 5
        let index: CGFloat = 2

        let bezPath = UIBezierPath()

        let firstPoint = CGPoint(x: (index * tabWidth) - 45, y: 0)
        let firstPointFirstCurve = CGPoint(x: ((tabWidth * index) + tabWidth / 4), y: 0)
        let firstPointSecondCurve = CGPoint(x: ((index * tabWidth) - 34) + tabWidth / 8, y: 44)

        let middlePoint = CGPoint(x: (tabWidth * index) + tabWidth / 2, y: 54)
        let middlePointFirstCurve = CGPoint(x: (((tabWidth * index) + tabWidth) - tabWidth / 8) + 34, y: 44)
        let middlePointSecondCurve = CGPoint(x: (((tabWidth * index) + tabWidth) - tabWidth / 4), y: 0)

        let lastPoint = CGPoint(x: (tabWidth * index) + tabWidth + 45, y: 0)
        bezPath.move(to: firstPoint)
        
        bezPath.addCurve(to: middlePoint, controlPoint1: firstPointFirstCurve, controlPoint2: firstPointSecondCurve)
        bezPath.addCurve(to: lastPoint, controlPoint1: middlePointFirstCurve, controlPoint2: middlePointSecondCurve)
        
        
        let right = CGPoint(x: view.frame.width, y: 0)
        
        bezPath.addLine(to: right)
        
        let down = CGPoint(x: view.frame.width, y: 90)
        
        bezPath.addLine(to: down)
        
        let left = CGPoint(x: 0, y: 90)
        
        bezPath.addLine(to: left)
        
        let up = CGPoint(x: 0, y: 0)
        
        bezPath.addLine(to: up)
        
        let closer = CGPoint(x: (index * tabWidth) - 45, y: 0)
        
        bezPath.addLine(to: closer)
        
        bezPath.append(UIBezierPath(rect: bottomView.bounds))
        bezPath.close()
        
        return bezPath
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == summaryCollectionView {
            
            return 1
        }else if collectionView == menuCV {
            
            return 1
            
        }else if collectionView == actionsCollectionView {
            
            return 1
            
        }else {
            
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == summaryCollectionView {
            
            return 3
        }else if collectionView == menuCV {
            
            return 5
            
        }else if collectionView == actionsCollectionView {
            
            return 3
            
        }else {
            
            return videoKeys.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == summaryCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Summary", for: indexPath) as! SummaryCollectionViewCell
            
            cell.numbersLbl.text = summaryValues[indexPath.row]
            cell.valuesLbl.text = summaryValuesLbl[indexPath.row]
            
            if indexPath.row == 2 {
                
                cell.rightView.isHidden = true
            }else {
                
                cell.rightView.isHidden = false
            }
            
            return cell
        }else if collectionView == menuCV {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuId", for: indexPath) as! MenuCollectionViewCell
                       
            cell.menuIcon.image = UIImage(named: titleIcons[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.menuIcon.tintColor = .black
            
            //cell.menuTitle.text = titles[indexPath.row]
            
            if indexPath.row == 4 {
                
                cell.menuTitle.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
            }
            
            if indexPath.row == 2 {
                
                cell.menuIcon.alpha = 0
            }
                       
            return cell
            
        }else if collectionView == actionsCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Actions", for: indexPath) as! HashtagsCollectionViewCell
            
            cell.hashtagLbl.layer.borderColor = UIColor.black.cgColor
            cell.hashtagLbl.textColor = .black
            
            return cell
            
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllVideos", for: indexPath) as! AllVideosCollectionViewCell
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 0.03 * videoImageHeights[indexPath.row]
            
            cell.videoPreview.sd_setImage(with: URL(string: videoImages[indexPath.row]), placeholderImage: UIImage(named: "smell"))
            
            if let numbers = videos[indexPath.row].views?.count{
                
                cell.likesLbl.text = "\(numbers)"
            }else {
                
                cell.likesLbl.text = "0"
            }
            
            
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == menuCV {
            
            let indexP = indexPath.row
            
            if indexP == 0 {
                
                let tbv = HomeViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }else if indexP == 1 {
                
                let tbv = DiscoverViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
                
            }else if indexP == 3 {
               
                let tbv = LikesViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }else if indexP == 4 {
                
                let tbv = SettingsViewController()
                
                
                present(tbv, animated: true, completion: nil)
                
            }
            
        }else if collectionView == allVideosCollectionView {
            
            let fullVideoVC = FullVideoViewController()
            fullVideoVC.videoUrl = videoUrls[indexPath.row]
            fullVideoVC.videoOwnerId = videoOwnersIds[indexPath.row]
            fullVideoVC.userCaption.text += videoCaptions[indexPath.row]
            fullVideoVC.videoKey = videoKeys[indexPath.row]
            //fullVideoVC.modalPresentationStyle = .fullScreen
            
            present(fullVideoVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == summaryCollectionView {
            
            let size = CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
            
            return size
        }else if collectionView == menuCV {
            
            let size = CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
            
            return size
            
        }else if collectionView == actionsCollectionView {
            
            let size = CGSize(width: view.frame.width / 3 - 25, height: 60)
            
            return size
            
        }else {
            
            let heightInPixels = videoImageHeights[indexPath.row] // view.frame.width
            
            let widthInPixels = videoImageWidths[indexPath.row]
            
            let size = CGSize(width: view.frame.width / 2 - 24, height: (heightInPixels / widthInPixels) * view.frame.width)
            
            return size
            
        }
    }
    
    
    
    

}

extension ProfileViewController: PinterestLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    let heightInPixels = videoImageHeights[indexPath.row] // view.frame.width
    
    let widthInPixels = videoImageWidths[indexPath.row]
    
    let finalHeight = (heightInPixels / widthInPixels) * view.frame.width / 2
    
    return finalHeight//UIImage(named: searchImages[indexPath.row])!.size.height
  }
}
