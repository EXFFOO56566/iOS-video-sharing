//
//  DiscoverViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import Photos
import Alamofire
import AlamofireImage
import NVActivityIndicatorView



class DiscoverViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
    
    let titleIcons = ["home", "search", "add", "like", "user"]
    let titles = ["Home", "Categories", "Deals", "My Account", "Cart"]
    
    var searchImages = ["smell", "gfl", "einstein", "smell", "gfl", "einstein", "smell", "gfl", "einstein", "smell", "gfl", "einstein"]
    
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
    
       
    
    lazy var searchIcon: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "search")
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSearchF)))
        
        return img
        
    }()
    
    let searchValue: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Search"
        txt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        
        return txt
    }()
    
    lazy var messagesBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "feather")
        
        btn.setImage(img, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        btn.addTarget(self, action: #selector(callMessagesF), for: .touchUpInside)
        
        
        return btn
    }()
    
    lazy var searchCV: UICollectionView = {
    
        let layout = PinterestLayout()
        //layout.cellPadding = 1
        //layout.minimumInteritemSpacing = 0
        //layout.minimumLineSpacing = 0
        //layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "Search")
        cv.backgroundColor = .clear
        
        return cv
    
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
    

    let friendsTable: UITableView = {
        
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ShareTableViewCell.self, forCellReuseIdentifier: "FriendsCell")
        table.isHidden = true
        
        return table
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        
    }
    

    func setup(){
        
        
        view.addSubview(searchIcon)
        view.addSubview(searchCV)
        view.addSubview(messagesBtn)
        view.addSubview(searchValue)
        view.addSubview(friendsTable)
        view.addSubview(bottomView)
        view.addSubview(addBtn)
        view.addSubview(menuCV)
        
        view.addSubview(loadingLoader)
        
        menuCV.dataSource = self
        menuCV.delegate = self
        
        searchCV.dataSource = self
        searchCV.delegate = self
        
        friendsTable.dataSource = self
        friendsTable.delegate = self
        
        searchValue.delegate = self
        
        view.backgroundColor = .white
        
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
        
        searchIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        searchIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        searchIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        messagesBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        messagesBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        messagesBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messagesBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        searchCV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchCV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchCV.topAnchor.constraint(equalTo: searchIcon.bottomAnchor, constant: 12).isActive = true
        
        searchValue.leftAnchor.constraint(equalTo: searchIcon.rightAnchor, constant: 8).isActive = true
        searchValue.rightAnchor.constraint(equalTo: messagesBtn.leftAnchor, constant: -8).isActive = true
        searchValue.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchValue.topAnchor.constraint(equalTo: searchIcon.topAnchor, constant: 0).isActive = true
        
        loadingLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLoader.widthAnchor.constraint(equalToConstant: 45).isActive = true
        loadingLoader.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        friendsTable.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        friendsTable.topAnchor.constraint(equalTo: searchValue.bottomAnchor, constant: 0).isActive = true
        friendsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        friendsTable.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        //searchValue.becomeFirstResponder()
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createBezierPath().cgPath
        
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0

        // add the new layer to our custom view
        bottomView.layer.addSublayer(shapeLayer)
        
        bottomView.layer.shadowOffset = .zero
        bottomView.layer.shadowColor = UIColor.white.cgColor
        bottomView.layer.shadowRadius = 20
        bottomView.layer.shadowOpacity = 1
        
        callFirebase()
        
        if let layout = searchCV.collectionViewLayout as? PinterestLayout {
            layout.delegate = self as! PinterestLayoutDelegate
        }
        
      
        setupKeyboardObservers()
        
        
    }
    
    func setupKeyboardObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(){
        
        searchIcon.image = UIImage(named: "backIco")
        friendsTable.isHidden = false
        users = []
        
        
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        
        
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        searchIcon.image = UIImage(named: "search")
        friendsTable.isHidden = true
        searchValue.text = ""
        users = []
        
        
    }
    
    @objc func hideSearchF(tapGesture: UITapGestureRecognizer){
        
        searchIcon.image = UIImage(named: "search")
        friendsTable.isHidden = true
        searchValue.text = ""
        users = []
        
        view.endEditing(true)
        
    }
    
    var searchKeyResults = [String]()
    
    @objc func searchUsers(){
        
    }
    
    var searchResults = [String]()
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        searchResults = []
     searchKeyResults = []
        users = []
        
     
     if searchValue.text! == ""{
         
         //searchCV.alpha = 0
        users = []
        friendsTable.reloadData()
         
     }else {
         
         //searchCV.alpha = 1
        
        callFirebaseSearch(toSearch: searchValue.text!.lowercased())
         
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
    
    
    
    @objc func callMessagesF(){
        
        let chatsVC = ChatsTableViewController()
        chatsVC.modalPresentationStyle = .fullScreen
        
        let controller = UINavigationController(rootViewController: chatsVC)
        controller.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true, completion: nil)
    }
    
    var reloadingTimer = Timer()
    
    @objc func reloadTable(){
        
        self.searchCV.reloadData()
        self.searchCV.collectionViewLayout.invalidateLayout()
        
        
    }
    
    @objc func callFirebase(){
        
        let topProducts = Database.database().reference().child("videos")
        
        topProducts.observe(.childAdded) { (snapshotKey) in
            
            let key = snapshotKey.key
            
            let itemReview = Database.database().reference().child("videos").child(key)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    if let videoUrl = dict["videoUrl"] as? String {
                        
                        self.videoUrls.append(videoUrl)
                        
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
                    
                }
                
            })
            
            self.loadingLoader.alpha = 0
            
            self.searchCV.reloadData()
            self.searchCV.collectionViewLayout.invalidateLayout()
            self.reloadingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: true)
            //self.loadingLoader.alpha = 0
            
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
        
        if collectionView == menuCV {
            
            return 1
        }else {
            
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == menuCV {
            
            return 5
        }else {
            
            return videoUrls.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == menuCV {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuId", for: indexPath) as! MenuCollectionViewCell
            
            cell.menuIcon.image = UIImage(named: titleIcons[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.menuIcon.tintColor = .black
            
            //cell.menuTitle.text = titles[indexPath.row]
            
            if indexPath.row == 1 {
                
                cell.menuTitle.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
            }
            
            if indexPath.row == 2 {
                
                cell.menuIcon.alpha = 0
            }
            
            return cell
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Search", for: indexPath) as! SearchCollectionViewCell
            
            cell.videoPreview.sd_setImage(with: URL(string: videoImages[indexPath.row]), placeholderImage: UIImage(named: "smell"))
            
            //cell.layer.masksToBounds = true
            //cell.layer.cornerRadius = 0.03 * videoImageHeights[indexPath.row]
            
            
            
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
                
                let tbv = ProfileViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }
            
        }else {
            
            let fullVideoVC = FullVideoViewController()
            fullVideoVC.videoUrl = videoUrls[indexPath.row]
            fullVideoVC.videoOwnerId = videoOwnersIds[indexPath.row]
            fullVideoVC.userCaption.text += videoCaptions[indexPath.row]
            fullVideoVC.videoCaption = videoCaptions[indexPath.row]
            fullVideoVC.videoKey = videoKeys[indexPath.row]
            fullVideoVC.sharePicture.sd_setImage(with: URL(string: videoImages[indexPath.row]), placeholderImage: UIImage(named: "smell"))
            fullVideoVC.videoImage = videoImages[indexPath.row]
            fullVideoVC.videoWidth = videoImageWidths[indexPath.row]
            fullVideoVC.videoHeight = videoImageHeights[indexPath.row]
            //fullVideoVC.modalPresentationStyle = .fullScreen
            
            present(fullVideoVC, animated: true, completion: nil)
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == menuCV {
            
            let size = CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
            
            return size
           
        }else {
            
            //let image = UIImage(named: video[indexPath.row])
            
            let heightInPixels = videoImageHeights[indexPath.row] // view.frame.width
            
            let widthInPixels = videoImageWidths[indexPath.row]
            
            print(widthInPixels)
            print("DRAKE")
    
            
            let size = CGSize(width: view.frame.width / 2, height: (heightInPixels / widthInPixels) * view.frame.width)
            
            
            
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
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        
        backgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        backgroundView.layer.shadowOpacity = 1.0
        backgroundView.layer.shadowRadius = 0.0
        
        cell.sendBtn.isHidden = true
        
        cell.selectedBackgroundView = backgroundView
        
        cell.profileImageView.sd_setImage(with: URL(string: users[indexPath.row].profileImageUrl!), placeholderImage: UIImage(named: "smell"))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ShareTableViewCell
        
        let vc = ProfileViewController()
        
        vc.userId = users[indexPath.row].userId!
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
        
        
    }
    
    

}

extension DiscoverViewController: PinterestLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    let image = UIImage(named: searchImages[indexPath.row])
    
    let heightInPixels = videoImageHeights[indexPath.row] // view.frame.width
    
    let widthInPixels = videoImageWidths[indexPath.row]
    
    let finalHeight = (heightInPixels / widthInPixels) * view.frame.width / 2
    
    return finalHeight//UIImage(named: searchImages[indexPath.row])!.size.height
  }
}
