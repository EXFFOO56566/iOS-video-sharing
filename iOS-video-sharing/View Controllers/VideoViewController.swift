//
//  VideoViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import Photos

class VideoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    var globalStory: Video!
    var globalUniqueId: String!
    
    let titleIcons = ["home", "search", "add", "like", "user"]
    let titles = ["Home", "Categories", "Deals", "My Account", "Cart"]
    
    var stories = [Video]()
    
    var users = [User]()
    
    var liked = [Bool]()
    
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
    
    lazy var videosCollectionView: UICollectionView = {
        
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.view.frame.width, height: view.frame.height / 1.3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(VideosCollectionViewCell.self, forCellWithReuseIdentifier: "Videos")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return collectionView
        
    }()
    
    let loadingLoader: UIActivityIndicatorView = {
        
        let img = UIActivityIndicatorView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .black
        img.color = .black
        img.startAnimating()
        img.alpha = 1
        
        
        return img
        
    }()
    
    
    //
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
        
        view.backgroundColor = .black
        
        videosCollectionView.dataSource = self
        videosCollectionView.delegate = self
        
        menuCV.dataSource = self
        menuCV.delegate = self
        
        friendsTable.dataSource = self
        friendsTable.delegate = self
        
        view.addSubview(videosCollectionView)
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
        
        videosCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        videosCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        videosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        videosCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        loadingLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLoader.widthAnchor.constraint(equalToConstant: 35).isActive = true
        loadingLoader.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
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
        
        
        
        callStories()
        
        if currentRow != 0 {
            
            //call scroll to
            
        }
        
        getCurrentUser()
        
    }
    
    var playingVideos = false
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let indexP = NSIndexPath(row: currentRow, section: 0) as IndexPath
        
        let cell = videosCollectionView.cellForItem(at: indexP) as! VideosCollectionViewCell
        
        if playingVideos == true {
            
            cell.videoLayer.pause(reason: .userInteraction)
            
            playingVideos = false
            
        }
        
    }
    
    
    var uniqueId: String!
       
    
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
    
    var globalCount: Int!
    
    @objc func callStories(){
        
        let topProducts = Database.database().reference().child("stories")
        
        topProducts.observeSingleEvent(of: .value, with: { snapshot in

            let count = Int(snapshot.childrenCount)
            
            self.globalCount = count
            
            topProducts.observe(.childAdded) { (snapshotKey) in
                
                let key = snapshotKey.key
                
                let itemReview = Database.database().reference().child("stories").child(key)
                
                itemReview.observe(.value, with: {(snapshot) in
                    
                    if let dict = snapshot.value as? [String: AnyObject] {
                        
                        let story = Video()
                        
                        story.setValuesForKeys(dict)
        
                        if self.globalCount != self.stories.count {
                            
                            self.stories.append(story)
                            self.liked.append(false)
                            self.loadingLoader.alpha = 0
                            self.attemptReloadofTableStories()
                            
                            
                        }
                        
                        
                    }
                    
                })
               
                
            }
            
            
        })
        
    }
    
    var storiesTimer: Timer?
    
    @objc func attemptReloadofTableStories(){
        
        self.storiesTimer?.invalidate()
        self.storiesTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadStoriesCollectionView), userInfo: nil, repeats: false)
        
    }
    
    @objc func reloadStoriesCollectionView(){
        
        
        self.stories.sort { (message1, message2) -> Bool in
            
            let m1Time = message1.timeStamp!.intValue
            
            let m2Time = message2.timeStamp!.intValue
            
            return m1Time > m2Time
        }
        
        
        
        for i in stories {
            
            if globalStory.videoId == i.videoId {
                
                if (globalCount == stories.count) {
                    
                    let globalStoryPosition = stories.firstIndex(of: i)!
                    
                    //swap(&stories[0], &stories[globalStoryPosition])
                    
                    let element = stories.remove(at: globalStoryPosition)
                    stories.insert(element, at: 0)
                    
                }
                
            }
        }
        
        perform(#selector(callStoryLikes), with: nil, afterDelay: 1)
        
        
        
    }
    
    @objc func callStoryLikes(){
        
        for i in stories {
        
        let video = i
        
        if let videoId = video.videoId {
        Database.database().reference().child("stories").child(videoId).child("likes").observe(.value, with: {(snapshot) in

            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                
                for id in dict {
                    
                    if id.key == self.uniqueId {
                        
                        let position = self.stories.firstIndex(of: i)!
                        
                        self.liked[position] = true
                        
                    }else {
                    
                    
                    }
                
                }
            
            }
            
            DispatchQueue.main.async {
                
                self.videosCollectionView.reloadData()
            }
            
            if self.stories.count == self.globalCount {
                
                if self.currentRow != 0 {
                    
                    //call scroll to currentRow
                    
                    let iP = NSIndexPath(row: self.currentRow, section: 0) as IndexPath
                    
                    //self.videosCollectionView.scrollToItem(at: iP, at: .bottom, animated: true)
                    
                }
                
            }
        
        })
            
            }
            
        }
            
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
        
        if collectionView == videosCollectionView {
            
            return 1
            
        } else if collectionView == menuCV {
            
            return 1
            
        }else {
            
            return 1
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == videosCollectionView {
            
            return stories.count
            
        } else if collectionView == menuCV {
            
            return 5
            
        } else {
            
            return 9
            
        }
    }
    
    var scrolled = false
    
    var playingAtRow = 0
    
    var currentRow = 0
    var previousRow = -1
    
    var playingFirst = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()

        visibleRect.origin = videosCollectionView.contentOffset
        visibleRect.size = videosCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = videosCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        if currentRow != indexPath.row {
            
            let cell = videosCollectionView.cellForItem(at: indexPath) as! VideosCollectionViewCell
            
            let story = stories[indexPath.row]
            
            let url = URL(string: story.videoUrl!)!
            
            let indexP = NSIndexPath(row: playingAtRow, section: 0) as IndexPath
            
            let previousCel = videosCollectionView.cellForItem(at: indexP) as! VideosCollectionViewCell
            
            if previousCel.videoLayer.state == .playing {
                
                previousCel.videoLayer.pause(reason: .userInteraction)
                
            }
            
            cell.videoLayer.stateDidChanged = { state in
                switch state {
                case .none:
                    print("none")
                case .error(let error):
                    print("error - \(error.localizedDescription)")
                case .loading:
                    print("loading")
                case .paused(let playing, let buffering):
                    print("paused - progress \(Int(playing * 100))% buffering \(Int(buffering * 100))%")
                case .playing:
                    print("playing")
                }
            }
            
            let childValues = ["uniqueId": globalUniqueId]
            Database.database().reference().child("stories").child(story.videoId!).child("views").child(globalUniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            cell.videoLayer.play(for: url)
            
            previousRow = playingAtRow
            
            playingAtRow = indexPath.row
            
            currentRow = playingAtRow
            
            //checkProgress(cell: cell)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: cell.videoLayer.playerLayer.player?.currentItem)
            
            
            
            
            
        }
        
        currentRow = indexPath.row
        
        
        

    }
    
    var playerTimer: Timer?
    
    var publicCell: VideosCollectionViewCell!
    
    @objc func checkProgress(cell: UICollectionViewCell){
        
        publicCell = cell as? VideosCollectionViewCell
        
        self.playerTimer?.invalidate()
        self.playerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkAndScroll), userInfo: nil, repeats: true)
        
        
        
    }
    
    @objc func checkAndScroll(){
        
        print("whats good")
        
        let videoPlayer = publicCell.videoLayer.playerLayer.player

        NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
        
        
    }
    
    
    var firstCellPlaying = false
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == videosCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Videos", for: indexPath) as! VideosCollectionViewCell
            
            cell.videoViewVC = self
            
            let story = stories[indexPath.row]
            
            let itemReview = Database.database().reference().child("users").child(story.userId!)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    
                    if let userhandle = dict["userName"] as? String {
                        
                        cell.userName.text = userhandle
                        
                    }
                    
                    if let profile = dict["profileImageUrl"] as? String {
                        
                        cell.userProfileImage.sd_setImage(with: URL(string: profile), placeholderImage: UIImage(named: "smell"))
                        
                    }
                }
                
            })
            
            let url = URL(string: story.videoUrl!)!
            
            if playingFirst == false {
                
                if indexPath.row == 0 {
                    
                    let childValues = ["uniqueId": globalUniqueId]
                    Database.database().reference().child("stories").child(story.videoId!).child("views").child(globalUniqueId).updateChildValues(childValues as [AnyHashable : Any])
                    
                    cell.videoLayer.play(for: url)
                    
                    playingVideos = true
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: cell.videoLayer.playerLayer.player?.currentItem)
                    
                    publicCell = cell
                    
                    playingFirst = true
                    
                    
                    
                }
                
            }
            
            if liked[indexPath.row] == true {
                
                cell.likeBtn.setImage(UIImage(named: "liked"), for: .normal)
                
            }else {
                
                let img = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
                
                cell.likeBtn.setImage(img, for: .normal)
                cell.likeBtn.tintColor = .white
            }
            
            if let numViews = story.views?.count{
                
                cell.viewsLbl.text = "\(numViews)"
                
            }else {
                
                cell.viewsLbl.text = "0"
                
            }
            
            if let numComments = story.comments?.count {
                
                cell.commentsLbl.text = "\(numComments)"
                
            }else {
                
                cell.commentsLbl.text = "0"
                
            }
            
        Database.database().reference().child("stories").child(story.videoId!).child("likes").observe(.value, with: {(snapshot) in
            
                cell.likesLbl.text = "\(snapshot.childrenCount)"
        })
            
            print("calls")
            
            cell.layer.shadowColor = UIColor.white.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            cell.layer.shadowOpacity = 1.0
            cell.layer.shadowRadius = 0.0
            
            return cell
            
        } else if collectionView == menuCV {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuId", for: indexPath) as! MenuCollectionViewCell
                       
            cell.menuIcon.image = UIImage(named: titleIcons[indexPath.row])
            //cell.menuTitle.text = titles[indexPath.row]
            
            if indexPath.row == 2 {
                
                cell.menuIcon.alpha = 0
            }
                       
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Feed", for: indexPath) as! FeedCollectionViewCell
            
            //cell.userCaption.text = userCaptions[indexPath.row]
            
            return cell
            
        }
        
        
    }
    
    var inappropriateText: UITextField?
    
    var passedIndex: IndexPath!
    
    @objc func optionsF(cell: UICollectionViewCell){
        
        let index = videosCollectionView.indexPath(for: cell)
        
        passedIndex = index!
        
        let videoId = stories[index!.row].videoId!
        
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
        
        
        let reportF = UIAlertAction(title: "Block Account", style: .default) { (action) in
            
            let childValues = ["uniqueId": self.uniqueId]
            
            Database.database().reference().child("stories").child(self.stories[self.passedIndex.row].videoId!).child("blockedFromViewing").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
            Database.database().reference().child("users").child(self.stories[self.passedIndex.row].userId!).child("blocked").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
            
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
    
    
    
    @objc func viewUserProfileF(cell: UICollectionViewCell){
        
        let indexP = videosCollectionView.indexPath(for: cell)
        
        let video = stories[indexP!.row]
        
        let vc = ProfileViewController()
        
        vc.userId = video.userId!
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        
        let nOI = stories.count - 1
        
        if currentRow < nOI {
            
            let indexPath = NSIndexPath(row: currentRow + 1, section: 0) as IndexPath
            
            //videosCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            
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
                
                let tbv = ProfileViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }
        }else if collectionView == videosCollectionView {
            
            let story = stories[indexPath.row]
            
            let url = URL(string: story.videoUrl!)!
            
            let cell = videosCollectionView.cellForItem(at: indexPath) as! VideosCollectionViewCell
            
            currentRow = indexPath.row
            
            if playingVideos == false {
                
                cell.videoLayer.play(for: url)
                
                playingVideos = true
                
                
            }else {
                
                cell.videoLayer.pause(reason: .userInteraction)
                
                playingVideos = false
                
            }
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == videosCollectionView {
            
            let size = CGSize(width: view.frame.width, height: view.frame.height / 1.3)
            
            return size
            
        }else if collectionView == menuCV {
            
            let size = CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
            
            return size
            
        } else {
            
            let approxWidth = view.frame.width - 24
            
            let newSize = CGSize(width: approxWidth, height: 1000)
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            
            //let estimatedFrame = NSString(string: userCaptions[indexPath.row]).boundingRect(with: newSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            let size = CGSize(width: view.frame.width, height: view.frame.height + 84 + (view.frame.width / 1.5) + 160)
            
            return size
            
        }
        
        
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
        
        cell.videoVC = self
        
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
    
    @objc func likeF(cell: UICollectionViewCell){
           
           let indexP = videosCollectionView.indexPath(for: cell)
           
           let video = stories[indexP!.row]
           
           let cell = cell as! VideosCollectionViewCell
           
           if liked[indexP!.row] == false {
               
               //videos[indexP!.row].likes?.append(1)
               
               let childValues = ["uniqueId": uniqueId]
           Database.database().reference().child("stories").child(video.videoId!).child("likes").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
               
            cell.likeBtn.setImage(UIImage(named: "liked"), for: .normal)
            
               liked[indexP!.row] = true
               
               let num = Int(cell.likesLbl.text!)
               
               //cell.numberOfLikesLbl.text = "\(num! + 1)"
               
               
               
               
           }else {
               
           Database.database().reference().child("stories").child(video.videoId!).child("likes").child(self.uniqueId).removeValue()
               
               let img = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
               
               cell.likeBtn.setImage(img, for: .normal)
               cell.likeBtn.tintColor = .white
            
               liked[indexP!.row] = false
               
               let num = Int(cell.likesLbl.text!)
               
               //cell.numberOfLikesLbl.text = "\(num! - 1)"
               
               //video.likes?.removeLast()
           }
           
       }
       
       @objc func commentF(cell: UICollectionViewCell){
           
           let index = videosCollectionView.indexPath(for: cell)
           
           let cVC = CommentsViewController()
           cVC.videoKey = stories[index!.row].videoId!
           
           let vc = UINavigationController(rootViewController: cVC)
           
           vc.modalPresentationStyle = .fullScreen
           
           present(vc, animated: true, completion: nil)
           
       }
    
    @objc func viewCommentsF(cell: UICollectionViewCell){
        
        let index = videosCollectionView.indexPath(for: cell)
        
        let cVC = CommentsViewController()
        cVC.videoKey = stories[index!.row].videoId!
        
        let vc = UINavigationController(rootViewController: cVC)
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
    }
    
    var globalIndexPath: IndexPath?
       
       @objc func shareF(cell: UICollectionViewCell){
           
           globalIndexPath = videosCollectionView.indexPath(for: cell)
           
           sharePicture.sd_setImage(with: URL(string: stories[globalIndexPath!.row].videoImageUrl!), placeholderImage: UIImage(named: "smell"))
           
           tagF()
           
           
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
        
        let video = stories[globalIndexPath!.row]
        
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
                        
                        Database.database().reference().child("stories").child(video.videoId!).child("shares").child(fromId).updateChildValues(childValues as [AnyHashable : Any])
                        
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

extension VideoViewController: CachingPlayerItemDelegate {
    
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
