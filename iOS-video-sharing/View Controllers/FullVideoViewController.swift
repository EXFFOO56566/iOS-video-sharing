
//
//  FullVideoViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import Photos
import GSPlayer

class FullVideoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!

let titleIcons = ["home", "search", "add", "like", "user"]
let titles = ["Home", "Categories", "Deals", "My Account", "Cart"]
    
    var videoUrl: String!
    var videoOwnerId: String!
    var videoKey: String!
    
    var videoImage: String!
    
    var videoWidth: CGFloat!
    var videoHeight: CGFloat!
    
    var videoCaption: String!
    
    var users = [User]()

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

    
    let userProfileImage: UIButton = {
        
        let img = UIButton()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .black
        
        let valueImg = UIImage(named: "smell")
        img.imageView!.contentMode = .scaleAspectFill
        
        img.setImage(valueImg, for: .normal)
        
        img.clipsToBounds = true
        img.layer.cornerRadius = 16
        img.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        img.addTarget(self, action: #selector(callUnkownUserProfile), for: .touchUpInside)
        
        
        return img
    }()
    
    let userName: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Thapelo Matlou"
        lbl.textColor = .white
        
        
        return lbl
    }()
    
    lazy var FollowBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Follow", for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.white, for: .normal)
        
        return btn
    }()
    
    let userCaption: UITextView = {
        
        let lbl = UITextView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Thapelo Matlou "
        //lbl.numberOfLines = 2
        lbl.font = UIFont(name: lbl.font!.fontName, size: 15)
        lbl.isUserInteractionEnabled = false
        lbl.textColor = .white
        lbl.backgroundColor = .clear
        
        return lbl
    }()
    
    
    
    let videoLayer: VideoPlayerView = {
        
        let img = VideoPlayerView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .black
        //img.image = UIImage(named: "smell")
        //img.contentMode = .scaleAspectFill
        
        
        return img
    }()
    
    let viewsIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.image = UIImage(named: "views")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .white
        img.contentMode = .scaleAspectFill
        
        
        return img
    }()
    
    let viewsLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "1.7M"
        lbl.textColor = .white
        
        return lbl
    }()
    
    let likesIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .clear
        img.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .white
        img.contentMode = .scaleAspectFill
        img.isHidden = true
        
        
        return img
    }()
    
    let likesLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "257K"
        lbl.textColor = .white
        lbl.textAlignment = NSTextAlignment.center
        
        return lbl
    }()
    
    lazy var forwardBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .clear
        btn.alpha = 1
        
        btn.addTarget(self, action: #selector(tagF), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var commentBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "chat")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .clear
        btn.alpha = 1
        
        btn.addTarget(self, action: #selector(openComments), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var likeBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .clear
        btn.alpha = 1
        
        btn.addTarget(self, action: #selector(likeVideo), for: .touchUpInside)
        
        return btn
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
       
    lazy var optionsBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "options")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
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
    var bottomAnchor: NSLayoutConstraint?
    
    func setup(){
        
        view.backgroundColor = .black
        
        menuCV.dataSource = self
        menuCV.delegate = self
        
        
        friendsTable.dataSource = self
        friendsTable.delegate = self
        
        
        view.addSubview(videoLayer)
        view.addSubview(userProfileImage)
        view.addSubview(optionsBtn)
        view.addSubview(userName)
        //view.addSubview(FollowBtn)
        view.addSubview(userCaption)
        view.addSubview(viewsIcon)
        view.addSubview(viewsLbl)
        view.addSubview(likesIcon)
        view.addSubview(likesLbl)
        
        view.addSubview(forwardBtn)
        view.addSubview(commentBtn)
        view.addSubview(likeBtn)
        
        view.addSubview(bottomView)
        view.addSubview(addBtn)
        view.addSubview(menuCV)
        
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
        
        
        videoLayer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        videoLayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        videoLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        videoLayer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let url = URL(string: videoUrl)!
        
        videoLayer.play(for: url)
        
        userProfileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 46).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        optionsBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        optionsBtn.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor).isActive = true
        optionsBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        optionsBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        userName.leftAnchor.constraint(equalTo: userProfileImage.rightAnchor, constant: 12).isActive = true
        userName.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userName.rightAnchor.constraint(equalTo: optionsBtn.leftAnchor, constant: -12).isActive = true
        
        /*FollowBtn.leftAnchor.constraint(equalTo: userName.rightAnchor, constant: 12).isActive = true
        FollowBtn.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor).isActive = true
        FollowBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        FollowBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true*/
        
        userCaption.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        userCaption.bottomAnchor.constraint(equalTo: addBtn.topAnchor, constant: -24).isActive = true
        userCaption.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userCaption.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        viewsIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        viewsIcon.bottomAnchor.constraint(equalTo: userCaption.topAnchor, constant: -12).isActive = true
        viewsIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewsIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewsLbl.leftAnchor.constraint(equalTo: viewsIcon.rightAnchor, constant: 12).isActive = true
        viewsLbl.bottomAnchor.constraint(equalTo: userCaption.topAnchor, constant: -12).isActive = true
        viewsLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewsLbl.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        likesIcon.leftAnchor.constraint(equalTo: viewsLbl.rightAnchor, constant: 12).isActive = true
        likesIcon.centerYAnchor.constraint(equalTo: viewsLbl.centerYAnchor).isActive = true
        likesIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        likesIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        forwardBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        forwardBtn.bottomAnchor.constraint(equalTo: userCaption.topAnchor, constant: -12).isActive = true
        forwardBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forwardBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        commentBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        commentBtn.bottomAnchor.constraint(equalTo: forwardBtn.topAnchor, constant: -12).isActive = true
        commentBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        commentBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        likesLbl.centerXAnchor.constraint(equalTo: commentBtn.centerXAnchor, constant: 0).isActive = true
        likesLbl.bottomAnchor.constraint(equalTo: commentBtn.topAnchor, constant: -12).isActive = true
        likesLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likesLbl.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        likeBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        likeBtn.bottomAnchor.constraint(equalTo: likesLbl.topAnchor, constant: -12).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        likeBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        addBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true
        addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        menuCV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuCV.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        menuCV.heightAnchor.constraint(equalToConstant: view.frame.width / 5).isActive = true
        
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
        shareLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
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
        
        bottomView.layer.addSublayer(shapeLayer)
        
        
        //player = AVPlayer(url: URL(string: videoUrl)!)
        
        
        /*player.play()*/
        
        /*let url = URL(string: videoUrl)!
        let playerItem = CachingPlayerItem(url: url)
        playerItem.delegate = self
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoLayer.bounds
        videoLayer.layer.addSublayer(playerLayer)
        player.automaticallyWaitsToMinimizeStalling = false
        player.play()*/
        
        callUserProfile()
        
        callOwnerProfile()
        
        callVideoInfo()
    
    }
    
     @objc func optionsF(cell: UICollectionViewCell){
           
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
    
    var inappropriateText: UITextField?
       
       @objc func inappropriateF(){
           
           let alertController = UIAlertController(title: "Why is it inapproriate for you ?", message: nil, preferredStyle: .alert)
           // Add textfield to alert view
           alertController.addTextField { (textField) in
               self.inappropriateText = textField
           }
           
           let reportF = UIAlertAction(title: "Report", style: .default) { (action) in
               
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
           
           
        let reportF = UIAlertAction(title: "Block \(userName.text!)", style: .default) { (action) in
               
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
       

    override func viewWillDisappear(_ animated: Bool) {
        videoLayer.pause(reason: .userInteraction)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        videoLayer.resume()
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
    
    var reloadingTimer = Timer()
    
    @objc func reloadTable(){
        
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
            self.reloadingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
            //self.loadingLoader.alpha = 0
            
        }
        
    }
    
    
    @objc func removeSharebackground(tapGesture: UITapGestureRecognizer){
        
        print("lol")
        tagF()
        
    }
    
    @objc func openComments(){
        
        let cVC = CommentsViewController()
        cVC.videoKey = videoKey
        
        let vc = UINavigationController(rootViewController: cVC)
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func callUnkownUserProfile(){
        
        let vc = ProfileViewController()
        
        vc.userId = videoOwnerId
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
    
    var liked = false
    
    @objc func likeVideo(){
        
        if uniqueId == nil {
            
            return
        }
        
        let childValues = ["uniqueId": uniqueId]
        
        if liked == false {
            
            Database.database().reference().child("videos").child(self.videoKey).child("likes").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            self.numOfLikes += 1
            
            likesLbl.text = "\(numOfLikes)"
            
            let img = UIImage(named: "liked")?.withRenderingMode(.alwaysTemplate)
            self.likeBtn.setImage(img, for: .normal)
            
            //self.likeBtn.tintColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
            
            liked = true
        }else {
            
            Database.database().reference().child("videos").child(self.videoKey).child("likes").child(self.uniqueId).removeValue()
            
            self.numOfLikes -= 1
            
            let img = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
            self.likeBtn.setImage(img, for: .normal)
            
            self.likeBtn.tintColor = .white
            
            likesLbl.text = "\(numOfLikes)"
            
            
            
            liked = false
            
        }
        
        
        
    }
    
    var uniqueId: String!
    
    var globalUserProfileImage = ""
    
    @objc func callUserProfile(){
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            
            uniqueId = user.uid
            
            let childValues = ["uniqueId": uniqueId]
            
            Database.database().reference().child("videos").child(videoKey).child("views").child(uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            let itemReview = Database.database().reference().child("users").child(uniqueId)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    if let username = dict["fullName"] as? String {
                        
                    }
                    
                    if let userhandle = dict["userName"] as? String {
                        
                        //self.userHandle.text = "@" + userhandle.lowercased()
                        
                    }
                    
                }
                
            })
            
        }
    
    }
    
    @objc func callOwnerProfile(){
        
         let itemReview = Database.database().reference().child("users").child(videoOwnerId)
        
        itemReview.observe(.value, with: {(snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                 if let username = dict["userName"] as? String {
                    
                    self.userName.text = username
                    
                    let boldText = username + " "
                    let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
                    let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

                    let normalText = self.videoCaption
                    let normalAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    
                    if let normalT = normalText {
                        
                        let normalString = NSMutableAttributedString(string: normalT, attributes: normalAttrs)

                        attributedString.append(normalString)
                        
                        self.userCaption.attributedText = attributedString
                        
                    }else {
                        
                        
                        let normalString = NSMutableAttributedString(string: "No caption", attributes: normalAttrs)

                        attributedString.append(normalString)
                        
                        self.userCaption.attributedText = attributedString
                    }
                    
                    
                }
                
                if let userimage = dict["profileImageUrl"] as? String {
                               
                    print(userimage)
                    
                    self.globalUserProfileImage = userimage
                    
                    self.userProfileImage.imageView!.sd_setImage(with: URL(string: userimage)) { (image, error, cachType, url) in
                        
                        self.userProfileImage.setImage(image, for: .normal)
                    
                    }
                
                }
            
            }
        })
    
    }
    
    var numOfLikes = 0
    
    var gotNumberofLikes = false
    
    @objc func callVideoInfo(){
        
        Database.database().reference().child("videos").child(videoKey).child("views").observe(.value, with: {(snapshot) in
            
            let numOfChildren = snapshot.childrenCount
            
            self.viewsLbl.text = "\(numOfChildren)"
            
        })
        
        Database.database().reference().child("videos").child(videoKey).child("likes").observe(.value, with: {(snapshot) in
            
            let numOfChildren = snapshot.childrenCount
            
            self.numOfLikes = Int(numOfChildren)
            
            self.likesLbl.text = "\(numOfChildren)"
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                
                for id in dict {
                    
                    if id.key == self.uniqueId {
                        
                        self.liked = true
                        let img = UIImage(named: "liked")//?.withRenderingMode(.alwaysTemplate)
                        self.likeBtn.setImage(img, for: .normal)
                        
                    }
                }
                
            }
            
        })
        
    
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        
        //playerLayer.frame = videoLayer.bounds
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
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuId", for: indexPath) as! MenuCollectionViewCell
        
        cell.menuIcon.image = UIImage(named: titleIcons[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        
        cell.menuIcon.tintColor = .black
        
        cell.menuTitle.isHidden = true
        
        
        if indexPath.row == 2 {
            
            cell.menuIcon.alpha = 0
        }
        
        
        return cell
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
                
                let tbv = ProfileViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
        
        return size
        
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
        
        cell.fullVideoVC = self
        
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
    
    private func sendMessageWithProperties(properties: [String: AnyObject], passedToId: String, passedProfileImage: String, cell: UITableViewCell) {
        
        let ref = Database.database().reference().child("messages")
        
        let childRef = ref.childByAutoId()
        
        let fromId = Auth.auth().currentUser!.uid
        
        let toId = passedToId
        
        let timeStamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        var values = ["toId": toId, "fromId": fromId, "timeStamp": timeStamp, "profileImageUrl": passedProfileImage, "userId": videoOwnerId, "userName": userName.text!, "userProfileImage": globalUserProfileImage, "videoImage": videoImage, "videoCaption": videoCaption, "videoUrl": videoUrl, "videoWidth": videoWidth, "videoHeight": videoHeight, "videoKey": videoKey] as [String : AnyObject]
        
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
                
                Database.database().reference().child("videos").child(self.videoKey).child("shares").child(fromId).updateChildValues(childValues as [AnyHashable : Any])
                
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

}

extension FullVideoViewController: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        print("File is downloaded and ready for storing")
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        print("\(bytesDownloaded)/\(bytesExpected)")
    }
    
    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {
        print("Not enough data for playback. Probably because of the poor network. Wait a bit and try to play later.")
    }
    
    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        print(error)
    }
    
    
    
}
