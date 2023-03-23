//
//  CommentsViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase
import VegaScrollFlowLayout

private let itemHeight: CGFloat = 84
private let lineSpacing: CGFloat = 4
private let xInset: CGFloat = 20
private let topInset: CGFloat = 6

class CommentsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let titleIcons = ["home", "search", "add", "like", "user"]
    let titles = ["Home", "Categories", "Deals", "My Account", "Cart"]
    
    var comments = [Comment]()
    var userIds = [String]()
    var userNames = [String]()
    var userProfileImageUrls = [String]()
    
    var timeStamps = [NSNumber]()
    
    var videoKey: String!
    
    let bottomView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        
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
    
    
    let postView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        
        return vw
        
    }()
    
    let layout = VegaScrollFlowLayout()
    
    lazy var commentsCV: UICollectionView = {
    
        
        //layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 16, height: 87)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CommentsCollectionViewCell.self, forCellWithReuseIdentifier: "Comments")
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 58, right: 0)
        
        
        return cv
    
    }()
       
    
    let containerView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .white
        
        return vw
    }()
    
    let userImgBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "smell")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .gray
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(userImgF), for: .touchUpInside)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 15
        
        return btn
        
    }()
    
    
    lazy var inputTextField: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Enter comment"
        txt.delegate = self
        txt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        return txt
    }()
    
    let sendBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Post", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(sendCommentF), for: .touchUpInside)
        
        return btn
        
    }()
    
    
    let separatorLine: UIView = {
        
        let vw = UIView()
        
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .lightGray
        
        return vw
        
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
    
    var uniqueId: String!
    
    var heightConstraint: NSLayoutConstraint?
    
    func setup(){
        
        view.backgroundColor = .white
        
        view.addSubview(postView)
        view.addSubview(commentsCV)
        
        setupInputComponents()
        
        view.addSubview(friendsTable)
        
        /*view.addSubview(bottomView)
        view.addSubview(addBtn)
        view.addSubview(menuCV)*/
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backF))
        
        navigationItem.title = "Comments"
        
        
        friendsTable.delegate = self
        friendsTable.dataSource = self
        
        menuCV.dataSource = self
        menuCV.delegate = self
        
        commentsCV.dataSource = self
        commentsCV.delegate = self
        
        postView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        postView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        heightConstraint = postView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        postView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        
        commentsCV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        commentsCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        commentsCV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        commentsCV.topAnchor.constraint(equalTo: postView.bottomAnchor, constant: 12).isActive = true
        
        friendsTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        friendsTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        friendsTable.bottomAnchor.constraint(equalTo: separatorLine.topAnchor).isActive = true
        friendsTable.topAnchor.constraint(equalTo: postView.bottomAnchor, constant: 12).isActive = true
        
        /*bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
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
        bottomView.layer.shadowOpacity = 1*/
        
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            uniqueId = user.uid
            
        }
        
        setupKeyboardObservers()
        
        fetchComments()
        
    }
    
    @objc func fetchComments(){
        
        let commentsRef = Database.database().reference().child("videos").child(videoKey).child("comments")
        
        commentsRef.observe(.childAdded, with: { (snapshot) in
            
            let commentsId = snapshot.key
            
            let commentsR = Database.database().reference().child("videos").child(self.videoKey).child("comments").child(commentsId)
            
            commentsR.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    let comment = Comment()
                    comment.setValuesForKeys(dict)
                    
                    self.comments.append(comment)
                    
                    self.attemptReloadofTable()
                    
                    
                }
                
            })
            
            
        })
        
        
    }
    
    
    var timer: Timer?
    
    @objc func attemptReloadofTable(){
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
        
    }
    
    @objc func reloadTable(){
        
        self.comments.sort { (message1, message2) -> Bool in
            
            let m1Time = message1.timeStamp!.intValue
            
            let m2Time = message2.timeStamp!.intValue
            
            return m1Time > m2Time
            
        }
        
        DispatchQueue.main.async {
            
            self.commentsCV.reloadData()
            
        }
        
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents(){
        
        view.addSubview(containerView)
        containerView.addSubview(userImgBtn)
        containerView.addSubview(sendBtn)
        containerView.addSubview(inputTextField)
        containerView.addSubview(separatorLine)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        containerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        userImgBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        userImgBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        userImgBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        userImgBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        sendBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 90).isActive = true
        sendBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputTextField.leftAnchor.constraint(equalTo: userImgBtn.rightAnchor, constant: 8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendBtn.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        separatorLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
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
        
        if comments.count > 0 {
            
            let indexPath = NSIndexPath(item: self.comments.count - 1, section: 0) as IndexPath
            
            commentsCV.scrollToItem(at: indexPath, at: .bottom, animated: true)
            
        }
        
        
        
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        
        UIView.animate(withDuration: duration) {
            
            self.view.layoutIfNeeded()
            
        }
        
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        containerViewBottomAnchor?.constant = 0
        
        UIView.animate(withDuration: duration) {
            
            self.view.layoutIfNeeded()
            
        }
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if inputTextField.text!.contains("@") == true {
            
            friendsTable.isHidden = false
        }else {
            
            friendsTable.isHidden = true
            
        }

    }
    
    var myUserId: String!
    var myProfileImageUrl: String!
    var myUserName: String!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            self.uniqueId = user.uid
            
            let itemReview = Database.database().reference().child("users").child(uniqueId)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    if let username = dict["userName"] as? String {
                        
                        self.myUserName = username
                    }
                    
                    if let userid = dict["userId"] as? String {
                        
                        self.myUserId = userid
                    }
                    
                    if let userimage = dict["profileImageUrl"] as? String {
                        
                        /*if (self.userId != ""){
                            
                            return
                            
                        }*/
                        
                        self.myProfileImageUrl = userimage
                        
                        
                        self.userImgBtn.imageView!.sd_setImage(with: URL(string: userimage)) { (image, error, cachType, url) in
                            
                            self.userImgBtn.setImage(image, for: .normal)
                            
                            
                        }
                        
                    }
                    
                }
                
            })
           
           
       }
        
        
    }
    
    @objc func userImgF(){
        
        
    }
    
    @objc func sendCommentF(){
        
        let ref = Database.database().reference().child("videos").child(videoKey).child("comments")
        
        let childRef = ref.childByAutoId()
        
        let timeStamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        var values = ["userId": myUserId,"userName": myUserName, "profileImageUrl": myProfileImageUrl, "timeStamp": timeStamp, "comment": inputTextField.text!] as [String : AnyObject]
        
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                
                return
                
            }else {
                
                self.inputTextField.text = nil
                
                let childValues = ["uniqueId": self.uniqueId]
            Database.database().reference().child("videos").child(self.videoKey).child("shares").child(self.uniqueId).updateChildValues(childValues as [AnyHashable : Any])
                
            }
            
        }
        
        
        
    }
    
    @objc func backF(){
        
        dismiss(animated: true, completion: nil)
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
               
            return comments.count
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           if collectionView == menuCV {
               
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuId", for: indexPath) as! MenuCollectionViewCell
               
               cell.menuIcon.image = UIImage(named: titleIcons[indexPath.row])
               //cell.menuTitle.text = titles[indexPath.row]
               
               if indexPath.row == 2 {
                   
                   cell.menuIcon.alpha = 0
               }
               
               return cell
           }else {
               
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Comments", for: indexPath) as! CommentsCollectionViewCell
            
            cell.layer.cornerRadius = 8
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.masksToBounds = false
            cell.backgroundColor = .white
            
               
               //cell.videoPreview.image = UIImage(named: searchImages[indexPath.row])
            
            let comment = comments[indexPath.row]
               
            cell.commentValue.text = comment.comment
            cell.commenterPicture.sd_setImage(with: URL(string: comment.profileImageUrl!), placeholderImage: UIImage(named: "smell"))
            
            if let seconds = comment.timeStamp?.doubleValue {
                
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                
                let period = timeStampDate.timeAgo()
                
                cell.commentTime.text = "\(period) ago"
                
                
            }
            
            
            
            
               return cell
           }
           
           
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           if collectionView == menuCV {
               
               let size = CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
               
               return size
              
           }else {
            
            let approxWidth = view.frame.width - 24
            
            let newSize = CGSize(width: approxWidth, height: 1000)
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            
            let estimatedFrame = NSString(string: comments[indexPath.row].comment!).boundingRect(with: newSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            let size = CGSize(width: view.frame.width - 14, height: estimatedFrame.height + 62 + 10)
            
            return size
           
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
        }
        
    }
       
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! ShareTableViewCell
        
        cell.textLabel!.text = "Pidima Matlou"
        cell.detailTextLabel!.text = "@yessir"
        cell.sendBtn.alpha = 0
        
        return cell
    }
       


}
