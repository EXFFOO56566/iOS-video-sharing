//
//  HomeViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/22.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let titleIcons = ["home", "search", "add", "like", "user"]
    let titles = ["Home", "Categories", "Deals", "My Account", "Cart"]
    
    let userCaptions = ["Thapelo Matlou You dig ?", "Pidima Matlou I never really thought about it going the other way round... Lol #mafiatownrocks #nofronting #roadtodurbanjuly Pidima Matlou I never really thought about it going the other way round... Lol #mafiatownrocks #nofronting #roadtodurbanjuly", "", "", "", "", "", "", "", ""]
    
    var storyOwners = [String]()
    
    var videoUrls = [String]()
    var videoImages = [String]()
    var videoOwnersIds = [String]()
    var videoCaptions = [String]()
    var videoLikes = [Int]()
    var videoViews = [Int]()
    var videoShares = [Int]()
    var videoKeys = [String]()
    
    var videoImageWidths = [CGFloat]()
    var videoImageHeights = [CGFloat]()
    
    var videos = [Video]()
    
    var stories = [Video]()
    
    var ownerProfileImageUrls = [String]()
    var ownerNames = [String]()
    
    var liked = [Bool]()
    var watched = [Bool]()
    
    var got = [Bool]()
    
    var users = [User]()
    
    var likes = [[String]]()
    
    var comments = [[String]]()
    var solidComments = [Comment]()
    var singleComments = [NSMutableAttributedString]()
    
    var videosOwnerNames = [String]()
    var videosCaptions = [NSMutableAttributedString]()
    var videosOwnerProfileUrls = [String]()
    
    let topView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var videoBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        
        let img = UIImage(named: "video1")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        
        btn.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        btn.addTarget(self, action: #selector(postVideoF), for: .touchUpInside)
        
        
        return btn
    }()
    
    let topSeperatorLine: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .white
        /*vw.layer.shadowColor = UIColor.black.cgColor
        vw.layer.shadowOpacity = 0.1
        vw.layer.shadowOffset = CGSize(width: 0, height: -6)*/
        vw.layer.masksToBounds = false
        vw.layer.cornerRadius = 24
        
        return vw
        
    }()
    
    let logoLbl: UIImageView = {
        
        let lbl = UIImageView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.image = UIImage(named: "goofy2")?.withRenderingMode(.alwaysTemplate)
        
        lbl.tintColor = .white
        lbl.contentMode = .scaleAspectFill
        
        
        return lbl
    }()
    
    lazy var chatBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        
        let img = UIImage(named: "feather")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        
        btn.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        btn.addTarget(self, action: #selector(openChatsF), for: .touchUpInside)
        
        
        return btn
    }()
    
    let storiesCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StoriesCollectionViewCell.self, forCellWithReuseIdentifier: "Stories")
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.backgroundColor = .white
        
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        collectionView.layer.shadowOpacity = 1.0
        collectionView.layer.shadowRadius = 0.0
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return collectionView
        
    }()
    
    let collectionsSeperator: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        vw.backgroundColor = .lightGray
        
        return vw
    }()
    
    let bottomView: UIView = {
        
        
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        

        
        
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
        
        return cv
    
    }()
    
    let feedCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "Feed")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        collectionView.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return collectionView
        
    }()
    
    
    lazy var homeBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 35
        btn.backgroundColor = .clear
        
        let img = UIImage(named: "home")
        
        btn.setImage(img, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        
        return btn
    }()
    
    lazy var searchBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        
        let img = UIImage(named: "search")
        
        btn.setImage(img, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        
        return btn
    }()
    
    lazy var addBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 35
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        let img = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        
        btn.imageView?.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        
        btn.addTarget(self, action: #selector(postVideoF), for: .touchUpInside)
        
        
        return btn
    }()
    
    lazy var likesBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        
        let img = UIImage(named: "like")
        
        btn.setImage(img, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        
        return btn
    }()
    
    lazy var userBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        
        let img = UIImage(named: "user")
        
        btn.setImage(img, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        
        return btn
    }()
    
    var loadingLoader: NVActivityIndicatorView = {
        
        let loader = NVActivityIndicatorView(frame: .zero)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.type = .ballScaleMultiple
        loader.tintColor = UIColor.init(red: 255/255, green: 1/255, blue: 73/255, alpha: 1)
        loader.color = UIColor.init(red: 255/255, green: 1/255, blue: 73/255, alpha: 1)
        
        loader.startAnimating()
        
        return loader
        
    }()
    
    lazy var shareBackground: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .black
        vw.isUserInteractionEnabled = true
        vw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeSharebackground)))
        vw.alpha = 0.5
        vw.isHidden = true
        
        return vw
    }()
    
    let tagsView: UIView = {
           
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
    
    let sharePicture: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 12
        img.contentMode = .scaleAspectFill
        
        return img
    }()
    
    let shareMessage: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Say something.."
        
        return txt
    }()
    
    let shareLine: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .lightGray
        
        return vw
    }()
    
    lazy var cancelTags: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.backgroundColor = .clear
        
        btn.addTarget(self, action: #selector(tagF), for: .touchUpInside)
        
        return btn
    }()
    
    let tagsValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "@Username"
        txt.layer.masksToBounds = true
        txt.layer.borderColor = UIColor.lightGray.cgColor
        txt.layer.borderWidth = 1
        txt.layer.cornerRadius = 8
        txt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txt.frame.height))
        txt.leftViewMode = .always
        txt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        return txt
    }()
    
    let friendsTable: UITableView = {
           
           let table = UITableView()
           table.translatesAutoresizingMaskIntoConstraints = false
           table.register(ShareTableViewCell.self, forCellReuseIdentifier: "FriendsCell")
           
           return table
           
       }()
       
       lazy var doneBtn: UIButton = {
           
           let btn = UIButton()
           btn.translatesAutoresizingMaskIntoConstraints = false
           btn.setTitle("Done", for: .normal)
           btn.setTitleColor(.white, for: .normal)
           btn.contentHorizontalAlignment = .center
           btn.backgroundColor = .systemBlue
           
           btn.layer.zPosition = 7
           
           //btn.addTarget(self, action: #selector(tagF), for: .touchUpInside)
           
           return btn
       }()
          
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    var topMovingAnchor: NSLayoutConstraint?
    var bottomAnchor: NSLayoutConstraint?
    
    func setup(){
        
        view.backgroundColor = .red
        
        storiesCollectionView.dataSource = self
        storiesCollectionView.delegate = self
        
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        
        menuCV.dataSource = self
        menuCV.delegate = self
        
        friendsTable.dataSource = self
        friendsTable.delegate = self
        
        
        view.addSubview(topView)
        
        topView.addSubview(videoBtn)
        topView.addSubview(logoLbl)
        topView.addSubview(chatBtn)
        view.addSubview(topSeperatorLine)
        
        view.addSubview(feedCollectionView)
        view.addSubview(storiesCollectionView)
        view.addSubview(collectionsSeperator)
        view.addSubview(bottomView)
        view.addSubview(addBtn)
        view.addSubview(menuCV)
        
        view.addSubview(loadingLoader)
        
        view.addSubview(shareBackground)
        
        
        
        shareBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        shareBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        shareBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        shareBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(tagsView)
        tagsView.addSubview(sharePicture)
        tagsView.addSubview(shareMessage)
        tagsView.addSubview(shareLine)
        tagsView.addSubview(tagsValue)
        tagsView.addSubview(friendsTable)
        
        view.addSubview(doneBtn)
        
        
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        videoBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0).isActive = true
        videoBtn.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 12).isActive = true
        videoBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        topSeperatorLine.topAnchor.constraint(equalTo: videoBtn.bottomAnchor, constant: 0).isActive = true
        topSeperatorLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        topSeperatorLine.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        topSeperatorLine.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        logoLbl.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0).isActive = true
        logoLbl.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        logoLbl.widthAnchor.constraint(equalToConstant: 70).isActive = true
        logoLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        chatBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0).isActive = true
        chatBtn.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -12).isActive = true
        chatBtn.widthAnchor.constraint(equalToConstant: 55).isActive = true
        chatBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        storiesCollectionView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        storiesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        storiesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        storiesCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        
        collectionsSeperator.topAnchor.constraint(equalTo: storiesCollectionView.bottomAnchor).isActive = true
        collectionsSeperator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionsSeperator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionsSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        feedCollectionView.topAnchor.constraint(equalTo: storiesCollectionView.bottomAnchor).isActive = true
        feedCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        feedCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        feedCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        addBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true
        addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        menuCV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuCV.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        menuCV.heightAnchor.constraint(equalToConstant: view.frame.width / 5).isActive = true
        
        loadingLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLoader.widthAnchor.constraint(equalToConstant: 45).isActive = true
        loadingLoader.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        tagsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        topMovingAnchor = tagsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        topMovingAnchor?.isActive = true
        tagsView.heightAnchor.constraint(equalToConstant: view.frame.height - 100).isActive = true
        tagsView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        sharePicture.leftAnchor.constraint(equalTo: tagsView.leftAnchor, constant: 8).isActive = true
        sharePicture.topAnchor.constraint(equalTo: tagsView.topAnchor, constant: 8).isActive = true
        sharePicture.heightAnchor.constraint(equalToConstant: 60).isActive = true
        sharePicture.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        shareMessage.leftAnchor.constraint(equalTo: sharePicture.rightAnchor, constant: 8).isActive = true
        shareMessage.bottomAnchor.constraint(equalTo: sharePicture.bottomAnchor, constant: 0).isActive = true
        shareMessage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        shareMessage.rightAnchor.constraint(equalTo: tagsView.rightAnchor).isActive = true
        
        shareLine.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        shareLine.topAnchor.constraint(equalTo: sharePicture.bottomAnchor, constant: 8).isActive = true
        shareLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        shareLine.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        tagsValue.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        tagsValue.topAnchor.constraint(equalTo: shareLine.bottomAnchor, constant: 8).isActive = true
        tagsValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tagsValue.widthAnchor.constraint(equalToConstant: view.frame.width - 8).isActive = true
        
        friendsTable.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        friendsTable.topAnchor.constraint(equalTo: tagsValue.bottomAnchor, constant: 8).isActive = true
        friendsTable.bottomAnchor.constraint(equalTo: tagsView.bottomAnchor, constant: -8).isActive = true
        friendsTable.widthAnchor.constraint(equalToConstant: view.frame.width - 8).isActive = true
              
        
        doneBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        doneBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bottomAnchor = doneBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:60)
        bottomAnchor!.isActive = true
        doneBtn.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createBezierPath().cgPath
        
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        
        
        
        // add the new layer to our custom view
        bottomView.layer.addSublayer(shapeLayer)
        
        
        getCurrentUser()
        
        fetchVideos()
        fetchStories()
        
        /*let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bottomView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bottomView.addSubview(blurEffectView)*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let indexP = NSIndexPath(row: currentRow, section: 0) as IndexPath
        
        if let cell = feedCollectionView.cellForItem(at: indexP) as? FeedCollectionViewCell {
            
            if playingVideos == true {
                
                cell.videoLayer.pause(reason: .userInteraction)
                
                playingVideos = false
                
            }
        }
        
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var uniqueId: String!
    
    var globalProfileUrl: String!
    
    @objc func getCurrentUser(){
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            
            uniqueId = user.uid
            
        }else {
            
            let signUpVC = SignUpViewController()
            
            signUpVC.modalPresentationStyle = .fullScreen
            
            present(signUpVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func openChatsF(){
        
        let chatsVC = ChatsTableViewController()
        chatsVC.modalPresentationStyle = .fullScreen
        
        let controller = UINavigationController(rootViewController: chatsVC)
        controller.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true, completion: nil)
        
    }
    
    var shouldViewTags = false
    
    @objc func tagF(){
        
        if shouldViewTags == false {
            
            topMovingAnchor?.isActive = false
            topMovingAnchor?.constant = 200
            topMovingAnchor?.isActive = true
            
            shareBackground.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
            }
            
            shouldViewTags = true
        }else {
            
            topMovingAnchor?.isActive = false
            topMovingAnchor?.constant = view.frame.height
            topMovingAnchor?.isActive = true
            
            shareBackground.isHidden = true
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
            }
            
            shouldViewTags = false
        }
        
        
        
    }
    
    
    var searchKeyResults = [String]()
    
    @objc func searchUsers(){
        
    }
    
    var searchResults = [String]()
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        searchResults = []
     searchKeyResults = []
        users = []
        
     
     if tagsValue.text! == ""{
         
         //searchCV.alpha = 0
         
     }else {
         
         //searchCV.alpha = 1
        
        callFirebaseSearch(toSearch: tagsValue.text!.lowercased())
         
     }
        
        
    }
    
    var reloadingTagsTimer = Timer()
    
    @objc func reloadTagsTable(){
        
        self.friendsTable.reloadData()
        
        
    }
    
    func callFirebaseSearch(toSearch: String){
        
        
        
        let topProducts = Database.database().reference().child("users").queryOrdered(byChild: "userName").queryStarting(atValue: toSearch).queryEnding(atValue: toSearch+"\u{f8ff}")
        
        topProducts.observe(.childAdded) { (snapshotKey) in
            
            let key = snapshotKey.key
         
         var shouldAdd = false
         
         if self.searchKeyResults.contains(key) == false {
             
             shouldAdd = true
             
             self.searchKeyResults.append(key)
             
         }
         
            
            
            let itemReview = Database.database().reference().child("users").child(key)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    let user = User()
                    user.setValuesForKeys(dict)
                    
                    self.users.append(user)
                    
                }
                
            })
            
            self.friendsTable.reloadData()
            self.reloadingTagsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTagsTable), userInfo: nil, repeats: false)
            //self.loadingLoader.alpha = 0
            
        }
        
    }
    
    
    @objc func removeSharebackground(tapGesture: UITapGestureRecognizer){
        
        print("lol")
        tagF()
        
    }
    
    var reloadingTimer = Timer()
    
    @objc func reloadTable(){
        
        self.feedCollectionView.reloadData()
        self.feedCollectionView.collectionViewLayout.invalidateLayout()
        
        
    }
    
    var allVideosFetched = false
    
    var globalCount = 0
    
    var blockedVideos = [String]()
    
    @objc func fetchVideos(){
        
        let topProducts = Database.database().reference().child("videos")
        
        topProducts.observeSingleEvent(of: .value, with: { snapshot in
            
            let count = Int(snapshot.childrenCount)
            
            self.globalCount = count
            
            topProducts.observe(.childAdded) { (snapshotKey) in
                
                let key = snapshotKey.key
                
                let itemReview = Database.database().reference().child("videos").child(key)
                
                itemReview.observe(.value, with: {(snapshot) in
                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        
                        
                        if self.allVideosFetched == false {
                            
                            let video = Video()
                            
                            video.setValuesForKeys(dict)
                            
                            self.liked.append(false)
                            
                            let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
                            let attributedString = NSMutableAttributedString(string:"...", attributes:attrs)
                            
                            self.singleComments.append(attributedString)
                            
                            self.got.append(false)
                            
                            self.videos.append(video)
                            
                            
                            self.attemptReloadofTable()
                            
                        }
                        
                        if self.videos.count == count {
                            
                            self.allVideosFetched = true
                        }
                         
                        
                    }
                    
                })
               
                
            }
            
            
        })
        
        
        
    }
    
    var allStoriesFetched = false
    
    var globalWatchesCount = 0
    
    var numOfStoryOwners = 0
    
    @objc func fetchStories(){
        
        let topProducts = Database.database().reference().child("stories")
        
        topProducts.observeSingleEvent(of: .value, with: { snapshot in

            let count = Int(snapshot.childrenCount)
            
            self.numOfStoryOwners = count
            
            self.globalWatchesCount = count
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                for id in dict {
                    
                    if let valueDic = id.value as? [String: AnyObject] {
                        
                        if let videoUrl = valueDic["videoUrl"] as? String {
                            
                            
                        }else {
                            
                            self.globalWatchesCount -= 1
                        }
                    }
                
                }
                
            }
            
            topProducts.observe(.childAdded) { (snapshotKey) in
                
                let key = snapshotKey.key
                
                let itemReview = Database.database().reference().child("stories").child(key)
                
                itemReview.observe(.value, with: {(snapshot) in
                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        
                        if self.allStoriesFetched == false {
                            
                            if let videoUrl = dict["videoUrl"] as? String {
                                
                                let story = Video()
                                
                                story.setValuesForKeys(dict)
                                
                                self.watched.append(false)
                                
                                self.stories.append(story)
                                
                                self.attemptReloadofTableStories()
                                
                                if self.stories.count == count {
                                    
                                    self.allStoriesFetched = true
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                })
               
                
            }
            
            
        })
        
        
        
    }
    
    var timer: Timer?
    
    @objc func attemptReloadofTable(){
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadCollectionView), userInfo: nil, repeats: false)
        
    }
    
    @objc func reloadCollectionView(){
    
        
        if videos.count == globalCount {
            
            print("CHECKER 1:")
            
            for i in videos {
                
                print(i.userId!)
            }
            
            self.videos.sort { (message1, message2) -> Bool in
                
                let m1Time = message1.timeStamp!.intValue
                
                let m2Time = message2.timeStamp!.intValue
                
                return m1Time > m2Time
                
            }
            
            print("CHECKER 2:")
            
            for i in videos {
                
                print(i.userId!)
            }
            
            perform(#selector(self.callVideosF), with: nil, afterDelay: 1)
            
            
            
        }
        
        
        
    }
    
    @objc func callVideosF(){
        
        callVideos()
    }
    
    let myGroup = DispatchGroup()
    
    @objc func callVideos(){
        
        
        print("CALLED")
        self.loadingLoader.alpha = 0
        
        videos.forEach { i in
            
            let video = i
            
            
            if let videoId = video.videoId {
            Database.database().reference().child("videos").child(videoId).child("likes").observe(.value, with: {(snapshot) in

                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    
                    for id in dict {
                        
                        if id.key == self.uniqueId {
                            
                            let position = self.videos.firstIndex(of: i)!
                            
                            self.liked[position] = true
                            
                        }else {
                            
                            //cell.likeIcon.image = UIImage(named: "like")
                        }
                    }
                    
                }
                
            
            })
                
                Database.database().reference().child("videos").child(videoId).child("comments").observe(.value, with: {(snapshot) in

                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        
                        
                        
                        for id in dict {
                            
                            
                            print("ID:")
                            print(id)
                            
                            if let idDict = id.value as? [String: AnyObject]{
                                
                                if let comment = idDict["comment"] as? String {
                                    
                                    if let commenter = idDict["userName"] as? String {
                                        
                                        let boldText = commenter + " "
                                        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
                                        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

                                        let normalText = comment
                                        let normalAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
                                        let normalString = NSMutableAttributedString(string: normalText, attributes: normalAttrs)

                                        attributedString.append(normalString)
                                        
                                        let iP = self.videos.firstIndex(of: video)
                                        
                                        self.singleComments[iP!] = attributedString
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                        }
                        
                    }
                    
                
                })
                   
                
            }
            
            
            
            
        }
        
        print(globalCount)
        let semaphore = DispatchSemaphore(value: 0)
        
        
        firstUserCaller()
        
        
    }
    
    var starterNumber = 0

    var shouldBlockVideos = true
    
    @objc func firstUserCaller(){
        
        if globalCount > 0 && starterNumber < globalCount {
            
            let video = videos[starterNumber]
            
            if let videoOwnerId = video.userId {
            
                self.videoOwnersIds.append(videoOwnerId)
                
                let itemReview = Database.database().reference().child("users").child(videoOwnerId)
                
                itemReview.observe(.value, with: {(snapshot) in
                    
                    if let userDict = snapshot.value as? [String: AnyObject] {
                        
                        // BLOCKED:
                        
                        if let blocked = userDict["blocked"] as? [String: AnyObject]{
                            
                            for i in blocked {
                                
                                if i.key == self.uniqueId {
                                    
                                    if self.shouldBlockVideos == true {
                                        
                                        self.blockedVideos.append(self.videos[self.starterNumber].videoId!)
                                        
                                    }
                                    
                                    
                                    //self.videos.remove(at: self.starterNumber)
                                    
                                }
                            }
                            
                        }
                        
                        if let profileUrl = userDict["profileImageUrl"] as? String {
                            
                            self.videosOwnerProfileUrls.append(profileUrl)
                            
                        }
                        
                        
                        if let username = userDict["userName"] as? String {
                            
                            self.videosOwnerNames.append(username)
                            
                            
                            
                            let boldText = username + " "
                            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
                            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

                            let normalText = video.caption!
                            let normalAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
                            let normalString = NSMutableAttributedString(string: normalText, attributes: normalAttrs)

                            attributedString.append(normalString)
                            
                            self.videosCaptions.append(attributedString)
                            
                            
                            
                        }
                        
                    }
                    
                    self.starterNumber += 1
                    self.secondUserCaller()
                    
                    if self.starterNumber == self.globalCount {
                        
                        for blockedVideoId in self.blockedVideos {
                            
                            
                            for allVideos in self.videos {
                                
                                if allVideos.videoId == blockedVideoId {
                                    
                                    let index = self.videos.firstIndex(of: allVideos)
                                    
                                    self.videos.remove(at: index!)
                                    self.videoOwnersIds.remove(at: index!)
                                    self.videosOwnerProfileUrls.remove(at: index!)
                                    self.videosOwnerNames.remove(at: index!)
                                    self.videosCaptions.remove(at: index!)
                                    
                                }
                            }
                        }
                        
                        self.shouldBlockVideos = false
                        
                        DispatchQueue.main.async {
                            
                            self.feedCollectionView.reloadData()
                        }
                    }
                    
                    
                })
                
                
            }
            
        }
        
        
    }
    
    @objc func secondUserCaller(){
        
        firstUserCaller()
        
    }
    
    var storiesTimer: Timer?
    
    @objc func attemptReloadofTableStories(){
        
        self.storiesTimer?.invalidate()
        self.storiesTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadStoriesCollectionView), userInfo: nil, repeats: false)
        
    }
    
    var blockedStories = [String]()
    
    @objc func reloadStoriesCollectionView(){
        
        
        self.stories.sort { (message1, message2) -> Bool in
            
            let m1Time = message1.timeStamp!.intValue
            
            let m2Time = message2.timeStamp!.intValue
            
            return m1Time > m2Time
        }
        
        if globalWatchesCount == stories.count - 1 {
            
            
        }
        
        
        for i in stories {
            
            if let videoId = i.videoId {
                
                if watchCalls != globalWatchesCount {
                    
                    Database.database().reference().child("stories").child(videoId).child("views").observeSingleEvent(of: .value, with: {(snapshot) in
                        
                        let numOfChildren = snapshot.childrenCount
                        
                        if let dict = snapshot.value as? [String: AnyObject] {
                            
                            
                            for id in dict {
                                
                                if id.key == self.uniqueId {
                                    
                                    let storyIndex = self.stories.firstIndex(of: i)
                                    
                                    self.stories.remove(at: storyIndex!)
                                    
                                }else {
                                    
                                    //cell.likeIcon.image = UIImage(named: "like")
                                }
                            }
                            
                        }
                        
                        let itemReview = Database.database().reference().child("users").child(i.userId!)
                        
                        itemReview.observeSingleEvent(of: .value, with: {(snapshot) in
                            
                            if let dict = snapshot.value as? [String: AnyObject] {
                                
                                if let blocked = dict["blocked"] as? [String: AnyObject]{
                                    
                                    for iB in blocked {
                                        
                                        if iB.key == self.uniqueId {
                                            
                                            let index = self.stories.firstIndex(of: i)
                                            
                                            self.blockedStories.append(self.stories[index!].videoId!)
                                            //self.videos.remove(at: self.starterNumber)
                                            
                                        }
                                    }
                                    
                                }
                                
                                if let userhandle = dict["userName"] as? String {
                                    
                                    self.storyOwners.append(userhandle)
                                    
                                    for blockedStoryId in self.blockedStories {
                                        
                                        for allStories in self.stories {
                                            
                                            if allStories.videoId == blockedStoryId {
                                                
                                                let index = self.stories.firstIndex(of: allStories)
                                                
                                                self.stories.remove(at: index!)
                                                self.storyOwners.remove(at: index!)
                                            }
                                        }
                                    }
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.storiesCollectionView.reloadData()
                                    }
                                    
                                }
                                
                            }
                            
                        })
                        
                        
                    })
                    
                    
                }
                
                
                if (watchCalls != globalWatchesCount){
                    
                    watchCalls += 1
                }
                
            }
            
        }
        
        
        
        
    }
    
    
    @objc func postVideoF(){
        
        let story = UIStoryboard(name: "Main", bundle:nil)
           let vc = story.instantiateViewController(withIdentifier: "NewViewController") as! OptiViewController
        vc.videoCategory = "videos"
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
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
        
        if collectionView == storiesCollectionView {
            
            return 1
            
        } else if collectionView == menuCV {
            
            return 1
            
        }else {
            
            return 1
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == storiesCollectionView {
            
            return stories.count + 1
            
        } else if collectionView == menuCV {
            
            return 5
            
        } else {
            
            return videos.count
            
        }
    }
    
    var cellCalls = 0
    var watchCalls = 0
    
    var completedFetch = false
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == storiesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Stories", for: indexPath) as! StoriesCollectionViewCell
            
            if indexPath.row == 0 {
                
                cell.addStory.isHidden = false
                cell.storyOwner.text = "You"
                
                let itemReview = Database.database().reference().child("users").child(uniqueId)
                
                itemReview.observe(.value, with: {(snapshot) in
                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        
                        if let profile = dict["profileImageUrl"] as? String {
                            
                            cell.storyImage.sd_setImage(with: URL(string: profile), placeholderImage: UIImage(named: "smell"))
                        }
                        
                        if let userhandle = dict["userName"] as? String {
                            
                            //self.userHandle.text = "@" + userhandle.lowercased()
                            
                        }
                        
                    }
                    
                })
                
                
                
            }else {
                
                cell.addStory.isHidden = true
                
                let story = stories[indexPath.row - 1]
                
                cell.storyImage.sd_setImage(with: URL(string: story.videoImageUrl!), placeholderImage: UIImage(named: "smell"))
                
                print("Story owners:")
                print(storyOwners.count)
                
                if (storyOwners.count == numOfStoryOwners){
                    
                    cell.storyOwner.text = storyOwners[indexPath.row - 1]
                    
                }
                
                
                
                
                
                
            }
            
            
            return cell
            
        } else if collectionView == menuCV {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuId", for: indexPath) as! MenuCollectionViewCell
                       
            cell.menuIcon.image = UIImage(named: titleIcons[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.menuIcon.tintColor = .black
            //cell.menuTitle.text = titles[indexPath.row]
            
            if indexPath.row == 0 {
                
                cell.menuTitle.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
            }
            
            if indexPath.row == 2 {
                
                cell.menuIcon.alpha = 0
            }
                       
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Feed", for: indexPath) as! FeedCollectionViewCell
            
            let video = videos[indexPath.row]
            
            cell.homeVC = self
            
            cell.userProfileImage.sd_setImage(with: URL(string: videosOwnerProfileUrls[indexPath.row]), placeholderImage: UIImage(named: "smell"))
            
            cell.userCaption.attributedText = videosCaptions[indexPath.row]
            
            cell.commentLbl.attributedText = singleComments[indexPath.row]
            
            cell.userName.text = videosOwnerNames[indexPath.row]
            cell.userName.font = UIFont.boldSystemFont(ofSize: 17)
            
            cell.videoPreview.sd_setImage(with: URL(string: video.videoImageUrl!), placeholderImage: UIImage(named: "smell"))
            
            if liked[indexPath.row] == true {
                
                cell.likeIcon.image = UIImage(named: "liked")
                
            }else {
                
                cell.likeIcon.image = UIImage(named: "like")
            }
            
            
            if let seconds = video.timeStamp?.doubleValue {
                
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                
                let period = timeStampDate.timeAgo()
                
                cell.timeStamp.text = "\(period) ago"
            }
            
            if self.got[indexPath.row] == false {
                
                /*if let numLikes = video.likes?.count{
                    
                    cell.numberOfLikesLbl.text = "\(numLikes)"
                    
                    
                }else{
                    
                    cell.numberOfLikesLbl.text = "0"
                    
                }*/
                
            }
            
            Database.database().reference().child("videos").child(video.videoId!).child("likes").observe(.value, with: {(snapshot) in
                
                
                cell.numberOfLikesLbl.text = "\(snapshot.childrenCount)"
                
            
                
                
           
           })
            
            
            
            /*NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: cell.videoLayer.playerLayer.player?.currentItem)*/
            
            
            if let numComments = video.comments?.count{
                
                cell.numberOfCommentsLbl.text = "\(numComments)"
                cell.viewAllCommentsBtn.setTitle("View all \(numComments) comments", for: .normal)
                
                
                
            }else {
                cell.numberOfCommentsLbl.text = "0"
                cell.viewAllCommentsBtn.setTitle("No comments", for: .normal)
                
            }
            
            if let numShares = video.shares?.count{
                
                cell.numberOfForwardsLbl.text = "\(numShares)"
                
            }else {
                
                cell.numberOfForwardsLbl.text = "0"
                
            }
            
            
            if (cellCalls != globalCount){
                
                
                
                cellCalls += 1
            }
            
            self.got[indexPath.row] = true
            
            //completedFetch = true
            
            return cell
            
        }
        
        
    }
    
    var scrolled = false
    
    var playingAtRow = 0
    
    var currentRow = 0
    var previousRow = -1
    
    var playingFirst = false
    
    var playingVideos = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        var visibleRect = CGRect()

        visibleRect.origin = feedCollectionView.contentOffset
        visibleRect.size = feedCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = feedCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        if currentRow != indexPath.row {
            
            let cell = feedCollectionView.cellForItem(at: indexPath) as! FeedCollectionViewCell
            
            let video = videos[indexPath.row]
            
            let url = URL(string: video.videoUrl!)!
            
            let indexP = NSIndexPath(row: playingAtRow, section: 0) as IndexPath
            
            let previousCel = feedCollectionView.cellForItem(at: indexP) as! FeedCollectionViewCell
            
            if previousCel.videoLayer.state == .playing {
                
                previousCel.videoLayer.pause(reason: .userInteraction)
                
            }
            
            if playingVideos == true {
                
                let childValues = ["uniqueId": uniqueId]
                Database.database().reference().child("videos").child(video.videoId!).child("views").child(uniqueId).updateChildValues(childValues as [AnyHashable : Any])
                
                cell.videoLayer.play(for: url)
            }
            
            
            
            previousRow = playingAtRow
            
            playingAtRow = indexPath.row
            
            currentRow = playingAtRow
            
            //checkProgress(cell: cell)
            
            /*NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: cell.videoLayer.playerLayer.player?.currentItem)*/
            
            
            
        }
        
        currentRow = indexPath.row
        
        
        

    }
    
    @objc func viewUserProfileF(cell: UICollectionViewCell){
        
        let indexP = feedCollectionView.indexPath(for: cell)
        
        let video = videos[indexP!.row]
        
        let vc = ProfileViewController()
        
        vc.userId = video.userId!
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func likeF(cell: UICollectionViewCell){
        
        let indexP = feedCollectionView.indexPath(for: cell)
        
        let video = videos[indexP!.row]
        
        let cell = cell as! FeedCollectionViewCell
        
        if liked[indexP!.row] == false {
            
            //videos[indexP!.row].likes?.append(1)
            
            let childValues = ["uniqueId": uniqueId]
        Database.database().reference().child("videos").child(video.videoId!).child("likes").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            cell.likeIcon.image = UIImage(named: "liked")
            liked[indexP!.row] = true
            
            let num = Int(cell.numberOfLikesLbl.text!)
            
            //cell.numberOfLikesLbl.text = "\(num! + 1)"
            
            
            
            
        }else {
            
        Database.database().reference().child("videos").child(video.videoId!).child("likes").child(self.uniqueId).removeValue()
            
            cell.likeIcon.image = UIImage(named: "like")
            liked[indexP!.row] = false
            
            let num = Int(cell.numberOfLikesLbl.text!)
            
            //cell.numberOfLikesLbl.text = "\(num! - 1)"
            
            //video.likes?.removeLast()
        }
        
    }
    
    @objc func commentF(cell: UICollectionViewCell){
        
        let index = feedCollectionView.indexPath(for: cell)
        
        let cVC = CommentsViewController()
        cVC.videoKey = videos[index!.row].videoId!
        
        let vc = UINavigationController(rootViewController: cVC)
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
    
    var globalIndexPath: IndexPath?
    
    @objc func shareF(cell: UICollectionViewCell){
        
        globalIndexPath = feedCollectionView.indexPath(for: cell)
        
        sharePicture.sd_setImage(with: URL(string: videos[globalIndexPath!.row].videoImageUrl!), placeholderImage: UIImage(named: "smell"))
        
        tagF()
        
        
    }
    
    @objc func viewCommentsF(cell: UICollectionViewCell){
        
        let index = feedCollectionView.indexPath(for: cell)
        
        let cVC = CommentsViewController()
        cVC.videoKey = videos[index!.row].videoId!
        
        let vc = UINavigationController(rootViewController: cVC)
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
    
    var inappropriateText: UITextField?
    
    var passedIndex: IndexPath!
    
    @objc func optionsF(cell: UICollectionViewCell){
        
        let index = feedCollectionView.indexPath(for: cell)
        
        passedIndex = index!
        
        let videoId = videos[index!.row].videoId!
        
        let alert = UIAlertController(title: "Take Action", message: nil, preferredStyle: .alert)
        
        let reportF = UIAlertAction(title: "Report Inappropriate", style: .default) { (action) in
            
        
            self.inappropriateF()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
        }
        
        alert.addAction(reportF)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func inappropriateF(){
        
        let alertController = UIAlertController(title: "Why is it inapproriate for you ?", message: nil, preferredStyle: .alert)
        // Add textfield to alert view
        alertController.addTextField { (textField) in
            self.inappropriateText = textField
        }
        
        let reportF = UIAlertAction(title: "Report", style: .default) { (action) in
            
            let childValues = ["reason": self.inappropriateText?.text!]
            
            Database.database().reference().child("reports").child("videos").child(self.videos[self.passedIndex.row].videoId!).child("reports").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            self.reportedBlockUserOptionF()
        
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
        }
        
        alertController.addAction(reportF)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func reportedBlockUserOptionF(){
        
        let alertController = UIAlertController(title: "Content has been flagged as objectionable.", message: nil, preferredStyle: .alert)
        // Add textfield to alert view
        
        let attributedString = NSAttributedString(string: "Content has been flagged as objectionable.", attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : UIColor.orange
        ])
        
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        
        let reportF = UIAlertAction(title: "Block \(videosOwnerNames[passedIndex.row])", style: .default) { (action) in
            
            let childValues = ["uniqueId": self.uniqueId]
            
            Database.database().reference().child("videos").child(self.videos[self.passedIndex.row].videoId!).child("blockedFromViewing").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            Database.database().reference().child("users").child(self.videos[self.passedIndex.row].userId!).child("blocked").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            self.blockUserF()
            
        
        }
        
        reportF.setValue(UIColor.red, forKey: "titleTextColor")
        
        
        let cancel = UIAlertAction(title: "Close", style: .cancel) { (action) in
        
        }
        
        alertController.addAction(reportF)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func blockUserF(){
        
        let alertController = UIAlertController(title: "User blocked.", message: nil, preferredStyle: .alert)
        
        
        
        let cancel = UIAlertAction(title: "Close", style: .cancel) { (action) in
        
        }
        
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == storiesCollectionView {
            
            if indexPath.row == 0 {
                
                let story = UIStoryboard(name: "Main", bundle:nil)
                   let vc = story.instantiateViewController(withIdentifier: "NewViewController") as! OptiViewController
                vc.videoCategory = "stories"
                
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                
                present(navigationController, animated: true, completion: nil)
                
                
            }else {
                
                let tbv = VideoViewController()
                tbv.currentRow = indexPath.row - 1
                tbv.globalStory = stories[indexPath.row - 1]
                tbv.globalUniqueId = uniqueId
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }
            
            
            
        }else if collectionView == feedCollectionView {
            
            let video = videos[indexPath.row]
            
            /*let fullVideoVC = FullVideoViewController()
            fullVideoVC.videoUrl = video.videoUrl
            fullVideoVC.videoOwnerId = video.userId
            fullVideoVC.userCaption.text += video.caption!
            fullVideoVC.videoCaption = video.caption
            fullVideoVC.videoKey = video.videoId
            fullVideoVC.sharePicture.sd_setImage(with: URL(string: video.videoImageUrl!), placeholderImage: UIImage(named: "smell"))
            fullVideoVC.videoImage = video.videoImageUrl
            fullVideoVC.videoWidth = video.videoImageWidth as! CGFloat
            fullVideoVC.videoHeight = video.videoImageHeight as! CGFloat
            //fullVideoVC.modalPresentationStyle = .fullScreen
            
            present(fullVideoVC, animated: true, completion: nil)*/
            let url = URL(string: video.videoUrl!)!
            
            let cell = feedCollectionView.cellForItem(at: indexPath) as! FeedCollectionViewCell
            
            currentRow = indexPath.row
            
            if playingVideos == false {
                
                cell.videoLayer.play(for: url)
                
                playingVideos = true
                
                
            }else {
                
                cell.videoLayer.pause(reason: .userInteraction)
                
                playingVideos = false
                
            }
            
            
            
            
            
        } else {
            
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
                
                let tbv = ProfileViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }
            
            
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == storiesCollectionView {
            
            let size = CGSize(width: 90, height: 90)
            
            return size
            
        }else if collectionView == menuCV {
            
            let size = CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
            
            return size
            
        } else {
            
            let video = videos[indexPath.row]
            
            let videoHeight = video.videoImageHeight!
            let videoWidth = video.videoImageWidth!
            
            let newSum = CGFloat((CGFloat(videoHeight) / CGFloat(videoWidth))) * view.frame.width
            
            let approxWidth = view.frame.width - 24
            
            let newSize = CGSize(width: approxWidth, height: 1000)
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            
            let estimatedFrame = NSString(string: video.caption!).boundingRect(with: newSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            let sumHeight = CGFloat(160)// + CGFloat(truncating: video.videoImageHeight!)
            
            let byViewWidth = CGFloat(view.frame.width / 1.5)
            
            let size = CGSize(width: view.frame.width, height: estimatedFrame.height + 84 + sumHeight + byViewWidth)
            
            return size
            
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! ShareTableViewCell
        
        cell.textLabel!.text = users[indexPath.row].fullName
        cell.detailTextLabel!.text = users[indexPath.row].userName
        
        cell.homeVC = self
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        
        backgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        backgroundView.layer.shadowOpacity = 1.0
        backgroundView.layer.shadowRadius = 0.0
        
        cell.selectedBackgroundView = backgroundView
        
        cell.profileImageView.sd_setImage(with: URL(string: users[indexPath.row].profileImageUrl!), placeholderImage: UIImage(named: "smell"))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ShareTableViewCell
        
        
        
        sendMessageF(passedId: users[indexPath.row].userId!, passedImage: users[indexPath.row].profileImageUrl!, cell: cell)
        
        //let indexPath = NSIndexPath(item: self.users[.count - 1], section: 0) as IndexPath
        
        
        
        
        
        
    }
    
    @objc func sendPostF(cell: UITableViewCell){
           
           
           
           
       }
       
       @objc func dismissDoneBtn(){
           
           bottomAnchor?.constant = 60
           
           UIView.animate(withDuration: 0.5) {
               
               self.view.layoutIfNeeded()
           }
           
       }
       
       @objc func sendMessageF(passedId: String, passedImage: String, cell: UITableViewCell){
           
           let properties = ["text": shareMessage.text!] as [String : AnyObject]
           
           sendMessageWithProperties(properties: properties, passedToId: passedId, passedProfileImage: passedImage, cell: cell)
           
           
       }
    
    var sharedUserName: String!
    var globalUserProfileImage: String!
    private func sendMessageWithProperties(properties: [String: AnyObject], passedToId: String, passedProfileImage: String, cell: UITableViewCell) {
        
        let ref = Database.database().reference().child("messages")
        
        let childRef = ref.childByAutoId()
        
        let fromId = Auth.auth().currentUser!.uid
        
        let toId = passedToId
        
        let timeStamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        let video = videos[globalIndexPath!.row]
        
        let itemReview = Database.database().reference().child("users").child(video.userId!)
        
        itemReview.observe(.value, with: {(snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                if let username = dict["userName"] as? String {
                
                    self.sharedUserName = username
                }
                
                if let userimage = dict["profileImageUrl"] as? String {
                    
                    self.globalUserProfileImage = userimage
                
                }
                
                
                var values = ["toId": toId, "fromId": fromId, "timeStamp": timeStamp, "profileImageUrl": passedProfileImage, "userId": video.userId, "userName": self.sharedUserName, "userProfileImage": self.globalUserProfileImage, "videoImage": video.videoImageUrl, "videoCaption": video.caption, "videoUrl": video.videoUrl, "videoWidth": video.videoImageWidth, "videoHeight": video.videoImageHeight, "videoKey": video.videoId] as [String : AnyObject]
                
                properties.forEach({values[$0] = $1})
                
                
                childRef.updateChildValues(values) { (error, ref) in
                    
                    if error != nil {
                        
                        return
                        
                    }else {
                        
                        
                        let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                        
                        let messageId = childRef.key!
                        
                        userMessagesRef.updateChildValues([messageId: 1])
                        
                        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                        
                        recipientUserMessagesRef.updateChildValues([messageId: 1])
                        
                        self.bottomAnchor?.constant = 0
                        
                        UIView.animate(withDuration: 0.5) {
                            
                            self.view.layoutIfNeeded()
                        }
                        
                        if self.shareMessage.text != ""{
                            
                            //send
                            
                            let textValues = ["toId": toId, "fromId": fromId, "timeStamp": timeStamp, "text": self.shareMessage.text] as [String : AnyObject]
                            
                            let textRef = Database.database().reference().child("messages")
                            
                            let textChildRef = textRef.childByAutoId()
                            
                            textChildRef.updateChildValues(textValues){ (error, ref) in
                                
                                if error != nil {
                                
                                }else {
                                    
                                    let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                                    
                                    
                                    let messageId = textChildRef.key!
                                    
                                    userMessagesRef.updateChildValues([messageId: 1])
                                    
                                    let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                                    
                                    recipientUserMessagesRef.updateChildValues([messageId: 1])
                                    
                                    
                                }
                                
                            }
                        }
                        
                        let childValues = ["uniqueId": fromId]
                        
                        Database.database().reference().child("videos").child(video.videoId!).child("shares").child(fromId).updateChildValues(childValues as [AnyHashable : Any])
                        
                        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.dismissDoneBtn), userInfo: nil, repeats: false)
                        
                        let cell = cell as! ShareTableViewCell
                        
                        cell.sendBtn.text = "Sent"//("Sent", for: .normal)
                        cell.sendBtn.textColor = .black//setTitleColor(.black, for: .normal)
                        cell.sendBtn.backgroundColor = .clear
                        cell.sendBtn.layer.borderWidth = 1
                        cell.sendBtn.layer.borderColor = UIColor.black.cgColor
                        
                        
                    }
                    
                    
                }
                
                
            }
            
        })
           
        
    
    }
    
    

}

class StoriesCollectionViewCell: UICollectionViewCell {
    
    let storyHighlight: UIImageView = {
        
        let vw = UIImageView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.image = UIImage(named: "Insta_gram")
        
        //vw.layer.masksToBounds = true
        //vw.layer.borderWidth = 2
        //vw.layer.borderColor = UIColor.red.cgColor
        
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 16
        vw.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        
        
        return vw
    }()
    
    let middleView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        vw.backgroundColor = .white
        
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 14
        vw.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        
        return vw
    }()
    
    let storyImage: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .black
        img.image = UIImage(named: "smell")
        img.contentMode = .scaleAspectFill
        
        img.clipsToBounds = true
        img.layer.cornerRadius = 12
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        
        return img
    }()
    
    let storyOwner: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Thapelo Matlou"
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: "BlackWidow", size: 12)
        
        return lbl
    }()
    
    let addStoryBackground: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        vw.layer.masksToBounds = true
        vw.layer.cornerRadius = 10
        
        
        return vw
    }()
    
    lazy var addStory: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        btn.isHidden = true
        
        
        let img = UIImage(named: "add2")
        
        btn.setImage(img, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
        btn.isUserInteractionEnabled = false
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup(){
        
        addSubview(storyHighlight)
        addSubview(middleView)
        addSubview(storyImage)
        addSubview(storyOwner)
        addSubview(addStory)
        
        storyHighlight.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        storyHighlight.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -16).isActive = true
        storyHighlight.heightAnchor.constraint(equalToConstant: self.frame.height - 14).isActive = true
        storyHighlight.widthAnchor.constraint(equalToConstant: self.frame.height - 14).isActive = true
        
        middleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        middleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -16).isActive = true
        middleView.heightAnchor.constraint(equalToConstant: self.frame.height - 17).isActive = true
        middleView.widthAnchor.constraint(equalToConstant: self.frame.height - 17).isActive = true
        
        
        storyImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        storyImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -16).isActive = true
        storyImage.heightAnchor.constraint(equalToConstant: self.frame.height - 24).isActive = true
        storyImage.widthAnchor.constraint(equalToConstant: self.frame.height - 24).isActive = true
        
        storyOwner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        storyOwner.topAnchor.constraint(equalTo: storyHighlight.bottomAnchor, constant: 8).isActive = true
        storyOwner.heightAnchor.constraint(equalToConstant: 18).isActive = true
        storyOwner.widthAnchor.constraint(equalToConstant: self.frame.height - 12).isActive = true
        
        
        addStory.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        addStory.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18).isActive = true
        addStory.heightAnchor.constraint(equalToConstant: 20).isActive = true
        addStory.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}
