//
//  PublishVideoViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/25.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import AVKit
import Photos
import Firebase

class PublishVideoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    var videoURL: URL!
    
    var videoCategory = "videos"
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    let backgroundImage: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "goofyBackground")
        
        img.contentMode = .scaleAspectFill
        
        return img
    }()
    
    let viewTitle: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Publish Video"
        lbl.textColor = .black
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont(name: lbl.font.fontName, size: 30)
        
        
        return lbl
    }()
    
    let publishVideoView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = UIColor.init(red: 17/255, green: 17/255, blue: 29/255, alpha: 1)
        
        return vw
    }()
    
    let captionValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Caption"
        txt.textColor = .white
        
        return txt
    }()

    let videoPreviewImg: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "smell")
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    lazy var publishBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.setTitle("Publish", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 16
        
        btn.addTarget(self, action: #selector(publishVideoImage), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var tagFriends: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Tag Friends", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.backgroundColor = .clear
        
        btn.addTarget(self, action: #selector(tagF), for: .touchUpInside)
        
        return btn
    }()
    
    let addHashtaglbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Add popular #"
        lbl.textColor = .white
        lbl.isHidden = true
        
        return lbl
    }()
    
    let hashtagsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HashtagsCollectionViewCell.self, forCellWithReuseIdentifier: "Hashtags")
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8)
        collectionView.backgroundColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.isHidden = true
        
        
        return collectionView
        
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
        txt.layer.borderColor = UIColor.gray.cgColor
        txt.layer.borderWidth = 2
        txt.layer.cornerRadius = 8
        txt.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txt.frame.height))
        txt.leftViewMode = .always
        
        return txt
    }()
    
    let friendsTable: UITableView = {
        
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "FriendsCell")
        
        return table
        
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

       
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setup()
        
    }
    
    var thumbnailImage: UIImage!
    
    var topMovingAnchor: NSLayoutConstraint?

    func setup(){
        
        view.backgroundColor = .white
        
        hashtagsCollectionView.dataSource = self
        hashtagsCollectionView.delegate = self
        
        //view.addSubview(viewTitle)
        view.addSubview(backgroundImage)
        view.addSubview(publishVideoView)
        //view.addSubview(videoPreviewImg)
        view.addSubview(captionValue)
        view.addSubview(publishBtn)
        view.addSubview(loadingLoader)
        
        //view.addSubview(tagFriends)
        view.addSubview(addHashtaglbl)
        view.addSubview(hashtagsCollectionView)
        
        
        view.addSubview(tagsView)
        tagsView.addSubview(cancelTags)
        tagsView.addSubview(tagsValue)
        tagsView.addSubview(friendsTable)
        
        friendsTable.delegate = self
        friendsTable.dataSource = self
        
        
        /*viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        viewTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        viewTitle.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true*/
        
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        backgroundImage.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        /*videoPreviewImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        videoPreviewImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        videoPreviewImg.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        videoPreviewImg.widthAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true*/
        
        publishVideoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        publishVideoView.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 0).isActive = true
        publishVideoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        publishVideoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = backgroundImage.bounds
        backgroundImage.layer.addSublayer(playerLayer)
        player.play()
        
        /*NotificationCenter.default.addObserver(
          forName: .AVPlayerItemDidPlayToEndTime,
          object: nil,
          queue: nil) { [weak self] _ in self?.restart() }*/
        
        captionValue.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        captionValue.topAnchor.constraint(equalTo: publishVideoView.topAnchor, constant: 12).isActive = true
        captionValue.heightAnchor.constraint(equalToConstant: 60).isActive = true
        captionValue.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        
        publishBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        publishBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        publishBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        publishBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        
        loadingLoader.centerXAnchor.constraint(equalTo: publishBtn.centerXAnchor).isActive = true
        loadingLoader.centerYAnchor.constraint(equalTo: publishBtn.centerYAnchor).isActive = true
        loadingLoader.heightAnchor.constraint(equalToConstant: 35).isActive = true
        loadingLoader.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        /*tagFriends.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        tagFriends.topAnchor.constraint(equalTo: captionValue.bottomAnchor, constant: 12).isActive = true
        tagFriends.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tagFriends.widthAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true*/
        
        addHashtaglbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        addHashtaglbl.topAnchor.constraint(equalTo: captionValue.bottomAnchor, constant: 12).isActive = true
        addHashtaglbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addHashtaglbl.widthAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true
        
        hashtagsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        hashtagsCollectionView.topAnchor.constraint(equalTo: addHashtaglbl.bottomAnchor, constant: 12).isActive = true
        hashtagsCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hashtagsCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true
        
        tagsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topMovingAnchor = tagsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        topMovingAnchor?.isActive = true
        tagsView.heightAnchor.constraint(equalToConstant: view.frame.height - 100).isActive = true
        tagsView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        cancelTags.rightAnchor.constraint(equalTo: tagsView.rightAnchor, constant: -8).isActive = true
        cancelTags.topAnchor.constraint(equalTo: tagsView.topAnchor, constant: 8).isActive = true
        cancelTags.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelTags.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        tagsValue.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        tagsValue.topAnchor.constraint(equalTo: cancelTags.bottomAnchor, constant: 8).isActive = true
        tagsValue.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tagsValue.widthAnchor.constraint(equalToConstant: view.frame.width - 8).isActive = true
        
        friendsTable.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        friendsTable.topAnchor.constraint(equalTo: tagsValue.bottomAnchor, constant: 8).isActive = true
        friendsTable.bottomAnchor.constraint(equalTo: tagsView.bottomAnchor, constant: -8).isActive = true
        friendsTable.widthAnchor.constraint(equalToConstant: view.frame.width - 8).isActive = true
        
        if let thumbnailImage = thumbnailImageForVideoUrl(videoUrl: videoURL) {
            
            self.thumbnailImage = thumbnailImage
        }
        
        callUserProfile()
        
    }
    
    var shouldViewTags = false
    
    @objc func tagF(){
        
        if shouldViewTags == false {
            
            topMovingAnchor?.isActive = false
            topMovingAnchor?.constant = 200
            topMovingAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
            }
            
            shouldViewTags = true
        }else {
            
            topMovingAnchor?.isActive = false
            topMovingAnchor?.constant = view.frame.height
            topMovingAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
            }
            
            shouldViewTags = false
        }
        
        
        
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
                        
                        //self.userFullName.text = username
                        print(username)
                        
                    }
                    
                    if let userhandle = dict["userName"] as? String {
                        
                        //self.userHandle.text = "@" + userhandle.lowercased()
                        
                    }
                    
                }
                
            })
            
        }
    
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      playerLayer.frame = backgroundImage.bounds
    }
    
    private func restart() {
      player.seek(to: .zero)
      player.play()
    }
    
    deinit {
      NotificationCenter.default.removeObserver(
        self,
        name: .AVPlayerItemDidPlayToEndTime,
        object: nil)
    }
    
    var videoName: String!
    
    @objc func publishVideoF(){
        
        loadingLoader.alpha = 1
        publishBtn.setTitle("", for: .normal)
        
        let storageRef = Storage.storage().reference().child("\(videoName).mp4")
        
        storageRef.putFile(from: videoURL, metadata: nil) { (mdata, error) in
            
            if error != nil {
                
                
                print(error)
                self.loadingLoader.alpha = 0
                self.publishBtn.setTitle("Publish", for: .normal)
                
                
            }else {
                
                
                
                storageRef.downloadURL { (url, error) in
                    
                    guard let downloadURL = url else {
                        
                        return
                    
                    }
                    
                    let itemReviewRef = Database.database().reference().child(self.videoCategory).child(self.videoName)
                    
                    let timeStamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
                           
                    let values = ["videoUrl": downloadURL.absoluteString, "videoId": self.videoName, "userId": self.uniqueId, "caption": self.captionValue.text!, "timeStamp": timeStamp] as [String : Any]
                           
                    itemReviewRef.updateChildValues(values) {(error, reference) in
                        
                        if error != nil {
                            
                            print(error)
                            self.loadingLoader.alpha = 0
                            self.publishBtn.setTitle("Publish", for: .normal)
                            
                        }else {
                            
                            self.player.pause()
                            let profileVC = ProfileViewController()
                            
                            profileVC.modalPresentationStyle = .fullScreen
                            
                            self.present(profileVC, animated: true, completion: nil)
                            self.loadingLoader.alpha = 0
                            self.publishBtn.setTitle("Publish", for: .normal)
                            
                        }
                        
                    }
                    
                }
                
                
            }
        }
        
        
    }
    
    @objc func publishVideoImage(){
        
        loadingLoader.alpha = 1
        publishBtn.setTitle("", for: .normal)
        
        videoName = NSUUID().uuidString
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("\(imageName).jpeg")
        
        let uploadData = thumbnailImage.jpegData(compressionQuality: 0.6)!
        
        let imageWidth = thumbnailImage.size.width
        
        let imageHeight = thumbnailImage.size.height
        
        storageRef.putData(uploadData, metadata: nil) { (mdata, error) in
            
            if error == nil {
                
                storageRef.downloadURL { (url, error) in
                    
                    guard let downloadURL = url else {
                        
                        return
                    
                    }
                    
                    let itemReviewRef = Database.database().reference().child(self.videoCategory).child(self.videoName)
                           
                    let values = ["videoImageUrl": downloadURL.absoluteString, "videoImageWidth": imageWidth, "videoImageHeight": imageHeight] as [String : Any]
                           
                    itemReviewRef.updateChildValues(values) {(error, reference) in
                        
                        if error == nil {
                            
                            self.publishVideoF()
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    @objc func thumbnailImageForVideoUrl(videoUrl: URL) -> UIImage? {
        
        let asset = AVAsset(url: videoUrl)
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTime(value: 2, timescale: 60), actualTime: nil)
            
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            
            
        }
        
        
        
        return nil
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hashtags", for: indexPath) as! HashtagsCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: view.frame.width / 4, height: 60)
        
        return size
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "FriendsCell")
        
        cell.textLabel!.text = "Pidima Matlou"
        cell.detailTextLabel!.text = "@yessir"
        
        return cell
    }

}
